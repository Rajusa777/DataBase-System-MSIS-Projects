<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Management</title>
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
            background-color: #e67e22;
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
            background-color: #d35400;
        }
    </style>
</head>
<body>

    <h1>Student Management</h1>
    <div class="action-buttons">
        <a href="students_show.jsp" class="btn">Show All Students</a>
        <a href="students_add.jsp" class="btn">Add Student</a>
        <a href="students_delete.jsp" class="btn">Delete Student</a>
    </div>

</body>
</html>
