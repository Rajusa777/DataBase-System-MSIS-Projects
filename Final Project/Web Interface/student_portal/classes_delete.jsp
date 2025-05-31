<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Class</title>
    <style>
        body {
            background-color: #fcfcfc;
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
            background-color: #c0392b;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }

        button:hover {
            background-color: #a93226;
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

<h1>Delete Class</h1>

<%
    String message = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String classid = request.getParameter("classid");

        String dbURL = "jdbc:oracle:thin:@your_host:your_port:your_service";
        String username = "your_db_user";
        String password = "your_db_password";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(dbURL, username, password);

            String sql = "DELETE FROM classes WHERE classid = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, classid);

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                message = "Class with ID " + classid + " deleted successfully!";
            } else {
                message = "No class found with ID " + classid + ".";
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

<form method="post" action="classes_delete.jsp">
    <label for="classid">Enter Class ID to Delete</label>
    <input type="text" id="classid" name="classid" required>

    <button type="submit">Delete Class</button>
</form>

<a href="classes.jsp" class="back-link">← Back to Class Menu</a>

</body>
</html>
