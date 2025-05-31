<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Main Menu - Student Registration System</title>
    <style>
        body {
            background-color: #f0f4f8;
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 60px;
        }

        h1 {
            color: #2c3e50;
            font-size: 32px;
            margin-bottom: 40px;
        }

        .menu-container {
            display: grid;
            grid-template-columns: repeat(2, 200px);
            gap: 20px;
        }

        .menu-button {
            padding: 15px;
            background-color: #2ecc71;
            color: white;
            text-align: center;
            text-decoration: none;
            font-size: 16px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            transition: background-color 0.3s;
        }

        .menu-button:hover {
            background-color: #27ae60;
        }
    </style>
</head>
<body>

    <h1>Main Menu</h1>
    <div class="menu-container">
        <a href="students.jsp" class="menu-button">Students</a>
        <a href="courses.jsp" class="menu-button">Courses</a>
        <a href="classes.jsp" class="menu-button">Classes</a>
        <a href="enrollment.jsp" class="menu-button">Enrollment</a>
        <a href="prerequisites.jsp" class="menu-button">Prerequisites</a>
        <a href="logs.jsp" class="menu-button">Logs</a>
    </div>

</body>
</html>
