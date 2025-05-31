<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Prerequisite Management</title>
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
            background-color: #6c5ce7;
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
            background-color: #5a4dcf;
        }
    </style>
</head>
<body>

    <h1>Prerequisite Management</h1>
    <div class="action-buttons">
        <a href="prerequisites_show.jsp" class="btn">Show All Prerequisites</a>
        <a href="prerequisites_add.jsp" class="btn">Add Prerequisite</a>
        <a href="prerequisites_delete.jsp" class="btn">Delete Prerequisite</a>
    </div>

</body>
</html>
