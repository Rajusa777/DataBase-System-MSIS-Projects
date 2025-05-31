CREATE OR REPLACE PACKAGE student_pkg AS
  PROCEDURE show_students;
  PROCEDURE show_courses;
  PROCEDURE show_classes;
  PROCEDURE show_g_enrollments;
  PROCEDURE list_students_in_class(p_classid IN CHAR, p_result OUT SYS_REFCURSOR);
  PROCEDURE get_prerequisites(dept_code IN VARCHAR2, course_num IN NUMBER, result OUT SYS_REFCURSOR);
  PROCEDURE enroll_student(b_num IN CHAR, class_id IN CHAR);
  PROCEDURE drop_student(b_num IN CHAR, class_id IN CHAR);
  PROCEDURE delete_student(b_num IN CHAR);
  PROCEDURE add_course(p_dept_code IN VARCHAR2, p_course_num IN NUMBER, p_title IN VARCHAR2);
  PROCEDURE delete_course(p_dept_code IN VARCHAR2, p_course_num IN NUMBER);
  PROCEDURE add_class(p_classid IN CHAR, p_dept_code IN VARCHAR2, p_course_num IN NUMBER, p_semester IN VARCHAR2, p_year IN NUMBER);
  PROCEDURE delete_class(p_classid IN CHAR);


  --  NEW PROCEDURE: Add student
  PROCEDURE add_student (
    p_b#      IN CHAR,
    p_fname   IN VARCHAR2,
    p_lname   IN VARCHAR2,
    p_level   IN VARCHAR2,
    p_gpa     IN NUMBER,
    p_email   IN VARCHAR2,
    p_bdate   IN DATE
  );

 
END student_pkg;
/
