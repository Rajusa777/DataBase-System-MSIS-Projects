<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Delete Prerequisite</title>
    <style>
        body {
            background-color: #fefefe;
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
            width: 420px;
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

<h1>Delete Course Prerequisite</h1>

<%
    String message = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String dept = request.getParameter("dept");
        String courseNum = request.getParameter("course#");
        String preDept = request.getParameter("pre_dept");
        String preCourseNum = request.getParameter("pre_course#");

        String dbURL = "jdbc:oracle:thin:@your_host:your_port:your_service";
        String username = "your_db_user";
        String password = "your_db_password";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(dbURL, username, password);

            String sql = "DELETE FROM prerequisites WHERE dept = ? AND course# = ? AND pre_dept = ? AND pre_course# = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dept);
            pstmt.setString(2, courseNum);
            pstmt.setString(3, preDept);
            pstmt.setString(4, preCourseNum);

            int rowsDeleted = pstmt.executeUpdate();
            if (rowsDeleted > 0) {
                message = "Prerequisite deleted successfully!";
            } else {
                message = "No matching prerequisite found.";
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

<form method="post" action="prerequisites_delete.jsp">
    <label for="dept">Course Dept</label>
    <input type="text" id="dept" name="dept" required>

    <label for="course#">Course Number</label>
    <input type="text" id="course#" name="course#" required>

    <label for="pre_dept">Prerequisite Dept</label>
    <input type="text" id="pre_dept" name="pre_dept" required>

    <label for="pre_course#">Prerequisite Course Number</label>
    <input type="text" id="pre_course#" name="pre_course#" required>

    <button type="submit">Delete Prerequisite</button>
</form>

<a href="prerequisites.jsp" class="back-link">← Back to Prerequisite Menu</a>

</body>
</html>
