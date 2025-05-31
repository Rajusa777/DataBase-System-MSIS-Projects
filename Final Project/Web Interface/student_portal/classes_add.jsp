<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Class</title>
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
            background-color: #f39c12;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #d68910;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #d68910;
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

<h1>Add New Class</h1>

<%
    String message = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String classid = request.getParameter("classid");
        String dept = request.getParameter("dept");
        String courseNum = request.getParameter("course#");
        String semester = request.getParameter("semester");
        String year = request.getParameter("year");
        String limit = request.getParameter("limit");

        String dbURL = "jdbc:oracle:thin:@your_host:your_port:your_service";
        String username = "your_db_user";
        String password = "your_db_password";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(dbURL, username, password);

            String sql = "INSERT INTO classes (classid, dept, course#, semester, year, limit) VALUES (?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, classid);
            pstmt.setString(2, dept);
            pstmt.setString(3, courseNum);
            pstmt.setString(4, semester);
            pstmt.setInt(5, Integer.parseInt(year));
            pstmt.setInt(6, Integer.parseInt(limit));

            int rowsInserted = pstmt.executeUpdate();
            if (rowsInserted > 0) {
                message = "Class added successfully!";
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

<form method="post" action="classes_add.jsp">
    <label for="classid">Class ID</label>
    <input type="text" id="classid" name="classid" required>

    <label for="dept">Department</label>
    <input type="text" id="dept" name="dept" required>

    <label for="course#">Course Number</label>
    <input type="text" id="course#" name="course#" required>

    <label for="semester">Semester</label>
    <input type="text" id="semester" name="semester" required>

    <label for="year">Year</label>
    <input type="number" id="year" name="year" required>

    <label for="limit">Limit</label>
    <input type="number" id="limit" name="limit" required>

    <button type="submit">Add Class</button>
</form>

<a href="classes.jsp" class="back-link">← Back to Class Menu</a>

</body>
</html>
