<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Registration System</title>
    <style>
        body {
            background-color: #f5f8fa;
            font-family: Arial, sans-serif;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        h1 {
            font-size: 36px;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        .enter-button {
            padding: 15px 40px;
            font-size: 18px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            transition: background-color 0.3s;
        }

        .enter-button:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

    <h1>Welcome to the Student Registration System</h1>
    <form action="menu.jsp" method="get">
        <button class="enter-button" type="submit">Enter System</button>
    </form>

</body>
</html>
