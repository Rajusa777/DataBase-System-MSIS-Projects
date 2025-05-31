<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Courses</title>
    <style>
        body {
            background-color: #f4f7fa;
            font-family: Arial, sans-serif;
            padding: 40px;
        }

        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        table {
            width: 90%;
            margin: 0 auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px 16px;
            text-align: left;
            border-bottom: 1px solid #ccc;
        }

        th {
            background-color: #9b59b6;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .back-link {
            display: block;
            width: fit-content;
            margin: 20px auto;
            text-align: center;
            color: #8e44ad;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<h1>All Available Courses</h1>

<%
    // Database connection variables
    String dbURL = "jdbc:oracle:thin:@your_host:your_port:your_service";
    String username = "your_db_user";
    String password = "your_db_password";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(dbURL, username, password);

        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM courses ORDER BY dept, course#");

%>

<table>
    <tr>
        <th>Department</th>
        <th>Course Number</th>
        <th>Title</th>
    </tr>

<%
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getString("dept") %></td>
        <td><%= rs.getString("course#") %></td>
        <td><%= rs.getString("title") %></td>
    </tr>
<%
    }
%>
</table>

<%
    } catch (Exception e) {
        out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (stmt != null) stmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
%>

<a href="courses.jsp" class="back-link">← Back to Course Menu</a>

</body>
</html>
