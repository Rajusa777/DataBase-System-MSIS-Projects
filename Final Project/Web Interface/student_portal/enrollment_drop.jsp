<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Drop Student</title>
    <style>
        body {
            background-color: #f9f9f9;
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
            background-color: #e74c3c;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #c0392b;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #c0392b;
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

<h1>Drop Student from a Class</h1>

<%
    String message = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String bnum = request.getParameter("bnum");
        String classid = request.getParameter("classid");

        String dbURL = "jdbc:oracle:thin:@your_host:your_port:your_service";
        String username = "your_db_user";
        String password = "your_db_password";

        Connection conn = null;
        CallableStatement cstmt = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(dbURL, username, password);

            cstmt = conn.prepareCall("{call student_pkg.drop_student(?, ?)}");
            cstmt.setString(1, bnum);
            cstmt.setString(2, classid);

            cstmt.execute();
            message = "Student " + bnum + " successfully dropped from Class " + classid + ".";

        } catch (SQLException e) {
            message = "Error: " + e.getMessage();
        } finally {
            try { if (cstmt != null) cstmt.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
    }
%>

<% if (message != null) { %>
    <p class="<%= message.startsWith("Error") ? "error" : "message" %>"><%= message %></p>
<% } %>

<form method="post" action="enrollment_drop.jsp">
    <label for="bnum">Student B#</label>
    <input type="text" id="bnum" name="bnum" required>

    <label for="classid">Class ID</label>
    <input type="text" id="classid" name="classid" required>

    <button type="submit">Drop Student</button>
</form>

<a href="enrollment.jsp" class="back-link">← Back to Enrollment Menu</a>

</body>
</html>
