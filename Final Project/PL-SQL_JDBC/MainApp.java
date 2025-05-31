import java.sql.*;
import java.util.Scanner;
import oracle.jdbc.OracleTypes;


public class MainApp {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        Connection conn = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@acad111", "rezhilavanco", "Tekk$777iLiiT6");

            conn.setAutoCommit(false);

            System.out.println("Connected to Oracle DB!");

            while (true) {
                System.out.println("\n===== STUDENT REGISTRATION MENU =====");
                System.out.println("1. Manage Students");
                System.out.println("2. Manage Courses");
                System.out.println("3. Manage Classes");
                System.out.println("4. Enrollment");
                System.out.println("5. Prerequisites");
                System.out.println("6. Logs");
                System.out.println("7. Exit");
                System.out.print("Choose: ");
                int choice = scanner.nextInt();
                scanner.nextLine(); // consume newline

                switch (choice) {
                    case 1: studentMenu(conn, scanner); break;
                    case 2: courseMenu(conn, scanner); break;
                    case 3: classMenu(conn, scanner); break;
                    case 4: enrollmentMenu(conn, scanner); break;
                    case 5: prereqMenu(conn, scanner); break;
                    case 6: logMenu(conn, scanner); break;
                    case 7: System.out.println("Goodbye!"); return;
                    default: System.out.println("Invalid option.");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception ex) {}
        }
    }

    // === STUDENT MENU ===
    public static void studentMenu(Connection conn, Scanner scanner) throws SQLException {
        while (true) {
            System.out.println("\n=== Manage Students ===");
            System.out.println("a. Show All Students");
            System.out.println("b. Add Student");
            System.out.println("c. Delete Student");
            System.out.println("d. Back");
            System.out.print("Choose: ");
            String input = scanner.nextLine();

            if (input.equalsIgnoreCase("a")) {
                callShowStudents(conn);
            } else if (input.equalsIgnoreCase("b")) {
                callAddStudent(conn, scanner);
            } else if (input.equalsIgnoreCase("c")) {
                callDeleteStudent(conn, scanner);
            } else if (input.equalsIgnoreCase("d")) {
                break;
            } else {
                System.out.println("Invalid input.");
            }
        }
    }



    // === Core Logic Methods ===
    public static void callShowStudents(Connection conn) throws SQLException {
        String sql = "SELECT b#, first_name, last_name, st_level, gpa FROM students";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);

        System.out.println("\n--- Student List ---");
        while (rs.next()) {
            System.out.printf("%s - %s %s - %s - GPA: %.2f\n",
                    rs.getString("b#"), rs.getString("first_name"),
                    rs.getString("last_name"), rs.getString("st_level"),
                    rs.getDouble("gpa"));
        }

        rs.close(); stmt.close();
    }

    public static void callAddStudent(Connection conn, Scanner scanner) throws SQLException {
        System.out.print("Enter B#: ");
        String bnum = scanner.nextLine();
        System.out.print("Enter First Name: ");
        String fname = scanner.nextLine();
        System.out.print("Enter Last Name: ");
        String lname = scanner.nextLine();
        System.out.print("Enter Student Level: ");
        String level = scanner.nextLine();
        System.out.print("Enter GPA: ");
        double gpa = scanner.nextDouble(); scanner.nextLine();
        System.out.print("Enter Email: ");
        String email = scanner.nextLine();
        System.out.print("Enter Birthdate (YYYY-MM-DD): ");
        String bdate = scanner.nextLine();

        CallableStatement cs = conn.prepareCall("{ call student_pkg.add_student(?, ?, ?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD')) }");
        cs.setString(1, bnum);
        cs.setString(2, fname);
        cs.setString(3, lname);
        cs.setString(4, level);
        cs.setDouble(5, gpa);
        cs.setString(6, email);
        cs.setString(7, bdate);
        
        cs.execute();
        conn.commit(); // 

        System.out.println("Student added (if not already exists).");
    }


    public static void callDeleteStudent(Connection conn, Scanner scanner) throws SQLException {
        System.out.print("Enter B# to delete: ");
        String bnum = scanner.nextLine();

        CallableStatement cs = conn.prepareCall("{ call student_pkg.delete_student(?) }");
        cs.setString(1, bnum);
        cs.execute();

        System.out.println("Student deleted (if exists).");
    }


public static void courseMenu(Connection conn, Scanner scanner) throws SQLException {
    while (true) {
        System.out.println("\n=== Manage Courses ===");
        System.out.println("a. Show All Courses");
        System.out.println("b. Add Course");
        System.out.println("c. Delete Course");
        System.out.println("d. Back");
        System.out.print("Choose: ");
        String input = scanner.nextLine();

        if (input.equalsIgnoreCase("a")) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM courses");
            while (rs.next()) {
                System.out.println(rs.getString("dept_code") + " " +
                                   rs.getInt("course#") + ": " +
                                   rs.getString("title"));
            }
            rs.close(); stmt.close();
        } else if (input.equalsIgnoreCase("b")) {
            System.out.print("Enter Department Code: ");
            String dept = scanner.nextLine();
            System.out.print("Enter Course Number: ");
            int courseNum = scanner.nextInt(); scanner.nextLine();
            System.out.print("Enter Course Title: ");
            String title = scanner.nextLine();

            CallableStatement cs = conn.prepareCall("{ call student_pkg.add_course(?, ?, ?) }");
            cs.setString(1, dept);
            cs.setInt(2, courseNum);
            cs.setString(3, title);
            cs.execute();
            cs.close();
            System.out.println("Course added successfully (if not already exists).");

        } else if (input.equalsIgnoreCase("c")) {
            System.out.print("Enter Department Code: ");
            String dept = scanner.nextLine();
            System.out.print("Enter Course Number: ");
            int courseNum = scanner.nextInt(); scanner.nextLine();

            CallableStatement cs = conn.prepareCall("{ call student_pkg.delete_course(?, ?) }");
            cs.setString(1, dept);
            cs.setInt(2, courseNum);
            cs.execute();
            cs.close();
            System.out.println("Course deleted successfully (if exists).");

        } else if (input.equalsIgnoreCase("d")) {
            break;
        } else {
            System.out.println("Invalid input.");
        }
    }
}


public static void classMenu(Connection conn, Scanner scanner) throws SQLException {
    while (true) {
        System.out.println("\n=== Manage Classes ===");
        System.out.println("a. Show All Classes");
        System.out.println("b. Add Class");
        System.out.println("c. Delete Class");
        System.out.println("d. Back");
        System.out.print("Choose: ");
        String input = scanner.nextLine();

        if (input.equalsIgnoreCase("a")) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM classes");
            while (rs.next()) {
                System.out.println(rs.getString("classid") + ": " +
                                   rs.getString("dept_code") + " " +
                                   rs.getInt("course#") + ", " +
                                   rs.getString("semester") + " " +
                                   rs.getInt("year"));
            }
            rs.close(); stmt.close();

        } else if (input.equalsIgnoreCase("b")) {
            System.out.print("Enter Class ID: ");
            String classid = scanner.nextLine();
            System.out.print("Enter Department Code: ");
            String dept = scanner.nextLine();
            System.out.print("Enter Course Number: ");
            int courseNum = scanner.nextInt(); scanner.nextLine();
            System.out.print("Enter Semester: ");
            String semester = scanner.nextLine();
            System.out.print("Enter Year: ");
            int year = scanner.nextInt(); scanner.nextLine();

            CallableStatement cs = conn.prepareCall("{ call student_pkg.add_class(?, ?, ?, ?, ?) }");
            cs.setString(1, classid);
            cs.setString(2, dept);
            cs.setInt(3, courseNum);
            cs.setString(4, semester);
            cs.setInt(5, year);
            cs.execute();
            cs.close();
            System.out.println("Class added successfully.");

        } else if (input.equalsIgnoreCase("c")) {
            System.out.print("Enter Class ID to delete: ");
            String classid = scanner.nextLine();

            CallableStatement cs = conn.prepareCall("{ call student_pkg.delete_class(?) }");
            cs.setString(1, classid);
            cs.execute();
            cs.close();
            System.out.println("Class deleted successfully (if exists).");

        } else if (input.equalsIgnoreCase("d")) {
            break;
        } else {
            System.out.println("Invalid input.");
        }
    }
}


public static void enrollmentMenu(Connection conn, Scanner scanner) throws SQLException {
    while (true) {
        System.out.println("\n=== Enrollment ===");
        System.out.println("a. Enroll Student");
        System.out.println("b. Drop Student");
        System.out.println("c. Show Students in Class");
        System.out.println("d. Back");
        System.out.print("Choose: ");
        String input = scanner.nextLine();

        if (input.equalsIgnoreCase("a")) {
            callEnrollStudent(conn, scanner);  // Uses enhanced version
        } else if (input.equalsIgnoreCase("b")) {
            callDropStudent(conn, scanner);    // Cleanly refactored
        } else if (input.equalsIgnoreCase("c")) {
            System.out.print("Enter Class ID: ");
            String classid = scanner.nextLine();
            callListStudentsInClass(conn, classid);
        } else if (input.equalsIgnoreCase("d")) {
            break;
        } else {
            System.out.println("Invalid input.");
        }
    }
}



public static void prereqMenu(Connection conn, Scanner scanner) throws SQLException {
    while (true) {
        System.out.println("\n=== Prerequisites ===");
        System.out.println("a. Show Course Prerequisites");
        System.out.println("b. Back");
        System.out.print("Choose: ");
        String input = scanner.nextLine();

        if (input.equalsIgnoreCase("a")) {
            System.out.print("Enter Department Code: ");
            String dept = scanner.nextLine().toUpperCase();
            System.out.print("Enter Course Number: ");
            int courseNum = scanner.nextInt(); scanner.nextLine();

            CallableStatement cs = conn.prepareCall("{ call student_pkg.get_prerequisites(?, ?, ?) }");
            cs.setString(1, dept);
            cs.setInt(2, courseNum);
            cs.registerOutParameter(3, oracle.jdbc.OracleTypes.CURSOR);

            cs.execute();

            ResultSet rs = (ResultSet) cs.getObject(3);
            System.out.println("\n--- Prerequisites for " + dept + " " + courseNum + " ---");
            boolean found = false;
            while (rs.next()) {
                found = true;
                String preDept = rs.getString("pre_dept_code");
                int preCourse = rs.getInt("pre_course_num");
                int level = rs.getInt("path_level");

                String label = (level == 1) ? "(direct)" : "(indirect)";
                System.out.println("→ " + preDept + " " + preCourse + " " + label);
            }
            if (!found) {
                System.out.println("No prerequisites found.");
            }
            rs.close(); cs.close();
        } else if (input.equalsIgnoreCase("b")) {
            break;
        } else {
            System.out.println("Invalid input.");
        }
    }
}




public static void logMenu(Connection conn, Scanner scanner) throws SQLException {
    while (true) {
        System.out.println("\n=== Logs ===");
        System.out.println("a. Show All Logs");
        System.out.println("b. Back");
        System.out.print("Choose: ");
        String input = scanner.nextLine();

        if (input.equalsIgnoreCase("a")) {
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM logs");
            while (rs.next()) {
                System.out.println(rs.getString("user_name") + " - " +
                                   rs.getString("operation") + " on " +
                                   rs.getString("table_name") + " at " +
                                   rs.getTimestamp("op_time") + " [Key: " +
                                   rs.getString("tuple_keyvalue") + "]");
            }
            rs.close();
            stmt.close();
        } else if (input.equalsIgnoreCase("b")) {
            break;
        } else {
            System.out.println("Invalid input.");
        }
    }
}


public static void callListStudentsInClass(Connection conn, String classid) throws SQLException {
    CallableStatement cs = conn.prepareCall("{ call student_pkg.list_students_in_class(?, ?) }");
    cs.setString(1, classid);
    cs.registerOutParameter(2, oracle.jdbc.OracleTypes.CURSOR);

    cs.execute();

    ResultSet rs = (ResultSet) cs.getObject(2);
    System.out.println("\n--- Students in Class " + classid + " ---");
    boolean found = false;
    while (rs.next()) {
        found = true;
        String bnum = rs.getString("B#");
        String fname = rs.getString("first_name");
        String lname = rs.getString("last_name");
        System.out.println(bnum + " - " + fname + " " + lname);
    }
    if (!found) {
        System.out.println("No students enrolled in this class.");
    }
    rs.close();
    cs.close();
}

public static void callEnrollStudent(Connection conn, Scanner scanner) throws SQLException {
    System.out.print("Enter B#: ");
    String bnum = scanner.nextLine();
    System.out.print("Enter Class ID: ");
    String classid = scanner.nextLine();

    // Enable DBMS_OUTPUT
    Statement enableDbms = conn.createStatement();
    enableDbms.executeUpdate("BEGIN DBMS_OUTPUT.ENABLE(); END;");
    enableDbms.close();

    // Call stored procedure
    CallableStatement cs = conn.prepareCall("{call student_pkg.enroll_student(?, ?)}");
    cs.setString(1, bnum);
    cs.setString(2, classid);
    cs.execute();
    cs.close();

    // Print DBMS_OUTPUT lines
    CallableStatement csOutput = conn.prepareCall("BEGIN DBMS_OUTPUT.GET_LINE(?, ?); END;");
    csOutput.registerOutParameter(1, java.sql.Types.VARCHAR);
    csOutput.registerOutParameter(2, java.sql.Types.INTEGER);

    while (true) {
        csOutput.execute();
        int status = csOutput.getInt(2);
        if (status != 0) break;
        System.out.println(csOutput.getString(1));
    }
    csOutput.close();
}




public static void callDropStudent(Connection conn, Scanner scanner) throws SQLException {
    System.out.print("Enter B#: ");
    String bnum = scanner.nextLine();
    System.out.print("Enter Class ID: ");
    String classid = scanner.nextLine();

    // Enable DBMS_OUTPUT
    Statement enableDbms = conn.createStatement();
    enableDbms.executeUpdate("BEGIN DBMS_OUTPUT.ENABLE(); END;");
    enableDbms.close();

    // Call stored procedure
    CallableStatement cs = conn.prepareCall("{call student_pkg.drop_student(?, ?)}");
    cs.setString(1, bnum);
    cs.setString(2, classid);
    cs.execute();
    cs.close();

    // Print DBMS_OUTPUT lines
    CallableStatement csOutput = conn.prepareCall("BEGIN DBMS_OUTPUT.GET_LINE(?, ?); END;");
    csOutput.registerOutParameter(1, java.sql.Types.VARCHAR);
    csOutput.registerOutParameter(2, java.sql.Types.INTEGER);

    while (true) {
        csOutput.execute();
        int status = csOutput.getInt(2);
        if (status != 0) break;
        System.out.println(csOutput.getString(1));
    }
    csOutput.close();
}





}
