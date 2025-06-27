<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Dashboard Metrics
    int totalFiles = 0, vettedFiles = 0, pendingFiles = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/register", "root", "root");

        Statement stmt = conn.createStatement();
        ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM register_entries");
        if (rs1.next()) totalFiles = rs1.getInt(1);
        rs1.close();

        ResultSet rs2 = stmt.executeQuery("SELECT COUNT(*) FROM register_entries WHERE status = 'V'");
        if (rs2.next()) vettedFiles = rs2.getInt(1);
        rs2.close();

        ResultSet rs3 = stmt.executeQuery("SELECT COUNT(*) FROM register_entries WHERE status IS NULL OR status = ''");
        if (rs3.next()) pendingFiles = rs3.getInt(1);
        rs3.close();

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 20px; }
        h1 { color: #333; }
        .card-grid { display: flex; gap: 20px; flex-wrap: wrap; }
        .card {
            background: white; padding: 20px; border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1); width: 250px;
        }
        .card h2 { margin: 0 0 10px; color: #6a5acd; }
        .tools, .filters {
            margin-top: 30px; background: white; padding: 20px;
            border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .tools input, .tools button, .filters input, .filters select {
            padding: 8px; margin: 5px; border-radius: 4px; border: 1px solid #ccc;
        }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; background: white; }
        th, td { padding: 10px; border: 1px solid #ccc; }
        th { background: #eee; }
        .btn {
            background: #6a5acd; color: white;
            border: none; padding: 8px 12px;
            border-radius: 5px; cursor: pointer;
        }
        .btn:hover { background: #483d8b; }
    </style>
</head>
<body>

<h1>Welcome Admin</h1>

<div class="card-grid">
    <div class="card">
        <h2>Total Files</h2>
        <p><%= totalFiles %></p>
    </div>
    <div class="card">
        <h2>Vetted Files</h2>
        <p><%= vettedFiles %></p>
    </div>
    <div class="card">
        <h2>Pending Files</h2>
        <p><%= pendingFiles %></p>
    </div>
</div>

<!-- Filters -->
<div class="filters">
    <h2>Generate Department Report</h2>
    <form action="generate-report" method="get">
    <label>Department:</label>
    <select name="department">
        <option value="">All</option>
        <option value="Finance">Finance</option>
        <option value="HR">HR</option>
        <option value="Engineering">Engineering</option>
    </select>
    <label>Date Range:</label>
    <select name="days">
        <option value="7">Last 7 Days</option>
        <option value="10">Last 10 Days</option>
        <option value="30">Last 30 Days</option>
    </select>
    <input type="submit" value="Generate" class="btn">
</form>
</div>

<!-- Admin Tools -->
<div class="tools">
    <h2>Admin Tools</h2>
    <form action="reset-password" method="post">
        <input type="text" name="username" placeholder="Username to Reset" required>
        <input type="password" name="newPassword" placeholder="New Password" required>
        <button type="submit" class="btn">Reset Password</button>
    </form>

    <form action="delete-entry" method="post" style="margin-top:10px;">
        <input type="number" name="file_number" placeholder="File Number to Delete" required>
        <button type="submit" class="btn">Delete Entry</button>
    </form>
</div>

</body>
</html>
