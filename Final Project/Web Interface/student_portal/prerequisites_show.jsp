<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Prerequisites</title>
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
            padding: 12px 14px;
            text-align: left;
            border-bottom: 1px solid #ccc;
        }

        th {
            background-color: #6c5ce7;
            color: white;
        }

        tr:hover {
            background-color: #f0f0ff;
        }

        .back-link {
            display: block;
            width: fit-content;
            margin: 25px auto;
            text-align: center;
            color: #5a4dcf;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<h1>All Course Prerequisites</h1>

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

        stmt = conn.createStatement();
        String sql = "SELECT * FROM prerequisites ORDER BY dept, course#";
        rs = stmt.executeQuery(sql);
%>

<table>
    <tr>
        <th>Department</th>
        <th>Course #</th>
        <th>Pre-Dept</th>
        <th>Pre-Course #</th>
    </tr>

<%
    while (rs.next()) {
%>
    <tr>
        <td><%= rs.getString("dept") %></td>
        <td><%= rs.getString("course#") %></td>
        <td><%= rs.getString("pre_dept") %></td>
        <td><%= rs.getString("pre_course#") %></td>
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

<a href="prerequisites.jsp" class="back-link">← Back to Prerequisite Menu</a>

</body>
</html>
