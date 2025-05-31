<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Student</title>
    <style>
        body {
            background-color: #f0f4f8;
            font-family: Arial, sans-serif;
            padding: 40px;
        }

        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        form {
            background-color: white;
            width: 400px;
            margin: 0 auto;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        button {
            margin-top: 20px;
            width: 100%;
            padding: 12px;
            background-color: #27ae60;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #1e8449;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #2980b9;
            text-decoration: none;
        }

        .message {
            text-align: center;
            font-weight: bold;
            color: green;
        }

        .error {
            text-align: center;
            font-weight: bold;
            color: red;
        }
    </style>
</head>
<body>

<h1>Add New Student</h1>

<%
    String message = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String bnum = request.getParameter("bnum");
        String fname = request.getParameter("fname");
        String lname = request.getParameter("lname");
        String level = request.getParameter("level");
        String gpa = request.getParameter("gpa");
        String email = request.getParameter("email");

        String dbURL = "jdbc:oracle:thin:@your_host:your_port:your_service";
        String username = "your_db_user";
        String password = "your_db_password";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(dbURL, username, password);

            String sql = "INSERT INTO students (B#, FIRST_NAME, LAST_NAME, ST_LEVEL, GPA, EMAIL) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bnum);
            pstmt.setString(2, fname);
            pstmt.setString(3, lname);
            pstmt.setString(4, level);
            pstmt.setDouble(5, Double.parseDouble(gpa));
            pstmt.setString(6, email);

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                message = "Student added successfully!";
            }

        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        } finally {
            try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
%>

<% if (message != null) { %>
    <p class="<%= message.startsWith("Error") ? "error" : "message" %>"><%= message %></p>
<% } %>

<form method="post" action="students_add.jsp">
    <label for="bnum">B#</label>
    <input type="text" id="bnum" name="bnum" required>

    <label for="fname">First Name</label>
    <input type="text" id="fname" name="fname" required>

    <label for="lname">Last Name</label>
    <input type="text" id="lname" name="lname" required>

    <label for="level">Student Level</label>
    <input type="text" id="level" name="level" required>

    <label for="gpa">GPA</label>
    <input type="text" id="gpa" name="gpa" required>

    <label for="email">Email</label>
    <input type="email" id="email" name="email" required>

    <button type="submit">Add Student</button>
</form>

<a href="students.jsp" class="back-link">← Back to Student Menu</a>

</body>
</html>
