<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Added</title>
    <style>
        body { font-family: Arial; padding: 20px; background: #f0f0f0; }
        .card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 0 10px #aaa; }
        .btn { background: #6a5acd; color: white; padding: 10px 15px; text-decoration: none; border-radius: 4px; }
        .btn:hover { background: red; }
    </style>
</head>
<body>
    <div class="card">
        <h2>User Added Successfully!</h2>
        <p><strong>Name:</strong> <%= request.getAttribute("name") %></p>
        <p><strong>Username:</strong> <%= request.getAttribute("username") %></p>
        <p><strong>Email:</strong> <%= request.getAttribute("email") %></p>
        <p><strong>Role:</strong> <%= request.getAttribute("role") %></p>
        <p><strong>Department:</strong> <%= request.getAttribute("department") %></p>
        <a href="superadmin.jsp" class="btn">Back to Super Admin Panel</a>
    </div>
</body>
</html>
