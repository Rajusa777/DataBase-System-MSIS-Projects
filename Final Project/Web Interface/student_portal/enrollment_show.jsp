<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Enrollments</title>
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
            width: 95%;
            margin: 0 auto;
            border-collapse: collapse;
            background-color: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        th, td {
            padding: 12px 14px;
            text-align: left;
            border-bottom: 1px solid #ccc;
        }

        th {
            background-color: #16a085;
            color: white;
        }

        tr:hover {
            background-color: #ecf0f1;
        }

        .back-link {
            display: block;
            width: fit-content;
            margin: 25px auto;
            text-align: center;
            color: #138d75;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<h1>All Enrollments</h1>

<%
    String dbURL = "jdbc:oracle:thin:@your_host:your_port:your_service";
    String username = "your_db_user";
    String password = "your_db_password";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(dbURL, username, password);

        // Adjust query as needed if you're using JOINs or a view
        String sql = "SELECT * FROM enrollments ORDER BY B#, classid";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);
%>

<table>
    <tr>
        <th>Student B#</th>
        <th>Class ID</th>
        <th>Department</th>
        <th>Course #</th>
        <th>Semester</th>
        <th>Year</th>
    </tr>

<%
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getString("B#") %></td>
        <td><%= rs.getString("CLASSID") %></td>
        <td><%= rs.getString("DEPT") %></td>
        <td><%= rs.getString("COURSE#") %></td>
        <td><%= rs.getString("SEMESTER") %></td>
        <td><%= rs.getString("YEAR") %></td>
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

<a href="enrollment.jsp" class="back-link">← Back to Enrollment Menu</a>

</body>
</html>
