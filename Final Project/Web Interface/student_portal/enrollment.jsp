<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Enrollment Management</title>
    <style>
        body {
            background-color: #f9f9f9;
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 60px;
        }

        h1 {
            font-size: 28px;
            color: #34495e;
            margin-bottom: 30px;
        }

        .action-buttons {
            display: flex;
            gap: 20px;
        }

        .btn {
            padding: 12px 25px;
            background-color: #16a085;
            color: white;
            font-size: 15px;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            text-align: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: background-color 0.3s;
        }

        .btn:hover {
            background-color: #138d75;
        }
    </style>
</head>
<body>

    <h1>Enrollment Management</h1>
    <div class="action-buttons">
        <a href="enrollment_add.jsp" class="btn">Enroll a Student</a>
        <a href="enrollment_drop.jsp" class="btn">Drop a Student</a>
        <a href="enrollment_show.jsp" class="btn">Show Enrollments</a>
    </div>

</body>
</html>
