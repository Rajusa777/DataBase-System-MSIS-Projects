CREATE OR REPLACE PACKAGE BODY student_pkg AS

  PROCEDURE show_students IS
  BEGIN
    FOR s IN (SELECT * FROM students) LOOP
      dbms_output.put_line(s.B# || ' - ' || s.first_name || ' ' || s.last_name);
    END LOOP;
  END;

  PROCEDURE show_courses IS
  BEGIN
    FOR c IN (SELECT * FROM courses) LOOP
      dbms_output.put_line(c.dept_code || ' ' || c.course# || ' - ' || c.title);
    END LOOP;
  END;

  PROCEDURE show_classes IS
  BEGIN
    FOR c IN (SELECT * FROM classes) LOOP
      dbms_output.put_line(c.classid || ' - ' || c.course# || ' - ' || c.semester || ' ' || c.year);
    END LOOP;
  END;

  PROCEDURE show_g_enrollments IS
  BEGIN
    FOR e IN (SELECT * FROM g_enrollments) LOOP
      dbms_output.put_line(e.g_B# || ' enrolled in ' || e.classid || ' with score ' || e.score);
    END LOOP;
  END;


  PROCEDURE list_students_in_class(p_classid IN CHAR, p_result OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN p_result FOR
      SELECT s.B#, s.first_name, s.last_name
      FROM students s
      JOIN g_enrollments e ON s.B# = e.g_B#
      WHERE e.classid = p_classid;
  END;


  PROCEDURE get_prerequisites(
      dept_code IN VARCHAR2,
      course_num IN NUMBER,
      result OUT SYS_REFCURSOR
  ) IS
  BEGIN
    OPEN result FOR
      SELECT pre_dept_code, pre_course# AS pre_course_num, LEVEL AS path_level
      FROM prerequisites
      START WITH dept_code = get_prerequisites.dept_code AND course# = get_prerequisites.course_num
      CONNECT BY PRIOR pre_dept_code = dept_code AND PRIOR pre_course# = course#
      ORDER BY LEVEL;
  END;


  PROCEDURE enroll_student(b_num IN CHAR, class_id IN CHAR) IS
      v_student_count  NUMBER;
      v_class_count    NUMBER;
      v_enrolled_count NUMBER;
      v_dept_code      VARCHAR2(10);
      v_course_num     NUMBER;
      v_missing_prereq NUMBER;
  BEGIN
      -- 1. Check if student exists
      SELECT COUNT(*) INTO v_student_count
      FROM students
      WHERE B# = b_num;

      IF v_student_count = 0 THEN
          dbms_output.put_line('Enrollment failed: Student does not exist.');
          RETURN;
      END IF;

      -- 2. Check if class exists and get course info
      SELECT COUNT(*), MAX(dept_code), MAX(course#)
      INTO v_class_count, v_dept_code, v_course_num
      FROM classes
      WHERE classid = class_id;

      IF v_class_count = 0 THEN
          dbms_output.put_line('Enrollment failed: Class does not exist.');
          RETURN;
      END IF;

      -- 3. Check if already enrolled
      SELECT COUNT(*) INTO v_enrolled_count
      FROM g_enrollments
      WHERE g_B# = b_num AND classid = class_id;

      IF v_enrolled_count > 0 THEN
          dbms_output.put_line('Enrollment failed: Student already enrolled in this class.');
          RETURN;
      END IF;

      -- 4. Check if student completed prerequisites
      SELECT COUNT(*)
      INTO v_missing_prereq
      FROM prerequisites p
      WHERE p.dept_code = v_dept_code
        AND p.course# = v_course_num
        AND NOT EXISTS (
            SELECT 1
            FROM g_enrollments e
            JOIN classes c ON e.classid = c.classid
            WHERE e.g_B# = b_num
              AND c.dept_code = p.pre_dept_code
              AND c.course# = p.pre_course#
        );  -- ✅ <-- THIS closing parenthesis was missing

      IF v_missing_prereq > 0 THEN
          dbms_output.put_line('Enrollment failed: Missing prerequisites for ' || v_dept_code || ' ' || v_course_num || '.');
          RETURN;
      END IF;

      -- All validations passed, do the insert
      INSERT INTO g_enrollments (g_B#, classid)
      VALUES (b_num, class_id);

      COMMIT;
      dbms_output.put_line('Enrolled student ' || b_num || ' in class ' || class_id);
  EXCEPTION
      WHEN OTHERS THEN
          dbms_output.put_line('Enrollment failed: ' || SQLERRM);
  END;

  -- Drop student from a specific class

  PROCEDURE drop_student(b_num IN CHAR, class_id IN CHAR) IS
      v_student_count  NUMBER;
      v_is_grad        NUMBER;
      v_class_count    NUMBER;
      v_is_enrolled    NUMBER;
      v_semester       VARCHAR2(20);
      v_year           NUMBER;
      v_spring_enrolls NUMBER;
  BEGIN
      -- 1. Check student exists
      SELECT COUNT(*) INTO v_student_count
      FROM students
      WHERE B# = b_num;

      IF v_student_count = 0 THEN
          dbms_output.put_line('The B# is invalid.');
          RETURN;
      END IF;

      -- 2. Check student is graduate (master or PhD)
      SELECT COUNT(*) INTO v_is_grad
      FROM students
      WHERE B# = b_num AND LOWER(st_level) IN ('master', 'phd');

      IF v_is_grad = 0 THEN
          dbms_output.put_line('This is not a graduate student.');
          RETURN;
      END IF;

      -- 3. Check class exists
      SELECT COUNT(*) INTO v_class_count
      FROM classes
      WHERE classid = class_id;

      IF v_class_count = 0 THEN
          dbms_output.put_line('The classid is invalid.');
          RETURN;
      END IF;

      -- 4. Check student is enrolled
      SELECT COUNT(*) INTO v_is_enrolled
      FROM g_enrollments
      WHERE g_B# = b_num AND classid = class_id;

      IF v_is_enrolled = 0 THEN
          dbms_output.put_line('The student is not enrolled in the class.');
          RETURN;
      END IF;

      -- 5. Check if class is in Spring 2021
      SELECT semester, year INTO v_semester, v_year
      FROM classes
      WHERE classid = class_id;

      IF LOWER(v_semester) != 'spring' OR v_year != 2021 THEN
          dbms_output.put_line('Only enrollment in the current semester can be dropped.');
          RETURN;
      END IF;

      -- 6. Count Spring 2021 enrollments for student
      SELECT COUNT(*) INTO v_spring_enrolls
      FROM g_enrollments e
      JOIN classes c ON e.classid = c.classid
      WHERE e.g_B# = b_num AND LOWER(c.semester) = 'spring' AND c.year = 2021;

      IF v_spring_enrolls = 1 THEN
          dbms_output.put_line('This is the only class for this student in Spring 2021 and cannot be dropped.');
          RETURN;
      END IF;

      -- Drop if all checks pass
      DELETE FROM g_enrollments WHERE g_B# = b_num AND classid = class_id;
      COMMIT;

      dbms_output.put_line('Dropped student ' || b_num || ' from class ' || class_id);

  EXCEPTION
      WHEN OTHERS THEN
          dbms_output.put_line('Error: ' || SQLERRM);
  END;


  -- Delete student entirely (including all enrollments)
  PROCEDURE delete_student(b_num IN CHAR) IS
  BEGIN
      DELETE FROM g_enrollments WHERE g_B# = b_num;
      DELETE FROM students WHERE B# = b_num;

      COMMIT;
      dbms_output.put_line('Deleted student ' || b_num || ' and related enrollments.');
  EXCEPTION
      WHEN OTHERS THEN
          dbms_output.put_line('Error in delete_student: ' || SQLERRM);
  END;


  

  -- ✅ NEW PROCEDURE: Add student
  PROCEDURE add_student (
    p_b#      IN CHAR,
    p_fname   IN VARCHAR2,
    p_lname   IN VARCHAR2,
    p_level   IN VARCHAR2,
    p_gpa     IN NUMBER,
    p_email   IN VARCHAR2,
    p_bdate   IN DATE
  ) IS
    v_count NUMBER := 0;
  BEGIN
    SELECT COUNT(*) INTO v_count
    FROM students
    WHERE B# = p_b#;

    IF v_count > 0 THEN
      dbms_output.put_line('Student with B# ' || p_b# || ' already exists.');
      RETURN;
    END IF;

    INSERT INTO students(B#, first_name, last_name, st_level, gpa, email, bdate)
    VALUES (p_b#, p_fname, p_lname, p_level, p_gpa, p_email, p_bdate);

    COMMIT;  -- ✅ Ensure changes are saved

    dbms_output.put_line('Student added: ' || p_b# || ' - ' || p_fname || ' ' || p_lname);
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('Error in add_student: ' || SQLERRM);
  END;

  PROCEDURE add_course(p_dept_code IN VARCHAR2, p_course_num IN NUMBER, p_title IN VARCHAR2) IS
  BEGIN
    INSERT INTO courses (dept_code, course#, title)
    VALUES (p_dept_code, p_course_num, p_title);
    COMMIT;
    dbms_output.put_line('Course added: ' || p_dept_code || ' ' || p_course_num);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      dbms_output.put_line('Course already exists.');
    WHEN OTHERS THEN
      dbms_output.put_line('Error in add_course: ' || SQLERRM);
  END;

  PROCEDURE delete_course(p_dept_code IN VARCHAR2, p_course_num IN NUMBER) IS
  BEGIN
    DELETE FROM courses
    WHERE dept_code = p_dept_code AND course# = p_course_num;
    COMMIT;
    dbms_output.put_line('Course deleted: ' || p_dept_code || ' ' || p_course_num);
  END;


  PROCEDURE add_class(
    p_classid    IN CHAR,
    p_dept_code  IN VARCHAR2,
    p_course_num IN NUMBER,
    p_semester   IN VARCHAR2,
    p_year       IN NUMBER
  ) IS
    v_count NUMBER;
  BEGIN
    -- Check if course exists
    SELECT COUNT(*) INTO v_count
    FROM courses
    WHERE dept_code = p_dept_code AND course# = p_course_num;

    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Course does not exist. Please add the course first.');
    END IF;

    -- Now insert the class
    INSERT INTO classes (classid, dept_code, course#, semester, year)
    VALUES (p_classid, p_dept_code, p_course_num, p_semester, p_year);

    COMMIT;
    dbms_output.put_line('Class added: ' || p_classid);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      dbms_output.put_line('Class already exists.');
    WHEN OTHERS THEN
      dbms_output.put_line('Error in add_class: ' || SQLERRM);
  END;




  PROCEDURE delete_class(p_classid IN CHAR) IS
  BEGIN
    DELETE FROM classes
    WHERE classid = p_classid;

    COMMIT;

    dbms_output.put_line('Class deleted: ' || p_classid);
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('Error deleting class: ' || SQLERRM);
  END;


END student_pkg;
/
