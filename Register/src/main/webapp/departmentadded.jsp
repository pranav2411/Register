<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String departmentName = request.getParameter("departmentName");

    if (departmentName == null || departmentName.trim().isEmpty()) {
        response.sendRedirect("superadmin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Department Added Successfully</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 50px;
            display: flex;
            justify-content: center;
        }

        .box {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            width: 500px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            text-align: center;
        }

        h2 {
            color: green;
        }

        .info {
            font-size: 18px;
            margin: 20px 0;
            color: #333;
        }

        .btn {
            margin-top: 20px;
            padding: 12px 20px;
            background-color: #6a5acd;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn:hover {
            background-color: red;
        }
    </style>
</head>
<body>

<div class="box">
    <h2>✅ Department Added Successfully!</h2>
    <div class="info">
        Department Name: <strong><%= departmentName %></strong>
    </div>
    <a href="superadmin.jsp" class="btn">🔙 Back to Super Admin Dashboard</a>
</div>

</body>
</html>
