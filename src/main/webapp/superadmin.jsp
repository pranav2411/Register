<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String filterDept = request.getParameter("filterDept");
    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
    int recordsPerPage = 10;
    int start = (currentPage - 1) * recordsPerPage;

    List<String[]> users = new ArrayList<>();
    List<String> departments = new ArrayList<>();
    int totalRecords = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/register", "root", "root");

        // Load departments
        Statement deptStmt = conn.createStatement();
        ResultSet deptRs = deptStmt.executeQuery("SELECT name FROM departments");
        while (deptRs.next()) {
            departments.add(deptRs.getString("name"));
        }
        deptRs.close();
        deptStmt.close();

        // Count total users for pagination
        String countSql = (filterDept != null && !filterDept.isEmpty()) ?
            "SELECT COUNT(*) FROM users WHERE department = ?" :
            "SELECT COUNT(*) FROM users";
        PreparedStatement countStmt = conn.prepareStatement(countSql);
        if (filterDept != null && !filterDept.isEmpty()) countStmt.setString(1, filterDept);
        ResultSet countRs = countStmt.executeQuery();
        if (countRs.next()) totalRecords = countRs.getInt(1);
        countRs.close();
        countStmt.close();

        // Paginated user list
        String userSql = (filterDept != null && !filterDept.isEmpty()) ?
            "SELECT * FROM users WHERE department = ? LIMIT ?, ?" :
            "SELECT * FROM users LIMIT ?, ?";
        PreparedStatement userStmt = conn.prepareStatement(userSql);
        if (filterDept != null && !filterDept.isEmpty()) {
            userStmt.setString(1, filterDept);
            userStmt.setInt(2, start);
            userStmt.setInt(3, recordsPerPage);
        } else {
            userStmt.setInt(1, start);
            userStmt.setInt(2, recordsPerPage);
        }
        ResultSet userRs = userStmt.executeQuery();
        while (userRs.next()) {
            users.add(new String[] {
                userRs.getString("id"),
                userRs.getString("name"),
                userRs.getString("username"),
                userRs.getString("email"),
                userRs.getString("role"),
                userRs.getString("department")
            });
        }
        userRs.close();
        userStmt.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Super Admin Panel</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; padding: 30px; }
        input, select { padding: 8px; margin: 5px; }
        table { width: 100%; border-collapse: collapse; background: white; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; }
        th { background: #eee; }
        .button { background: #6a5acd; color: white; padding: 6px 10px; text-decoration: none; border-radius: 4px; display: inline-block; margin: 2px; }
        .button:hover { background: red; }
        .pagination { margin-top: 20px; text-align: center; }
        .pagination a { margin: 0 5px; text-decoration: none; padding: 6px 12px; background: #6a5acd; color: white; border-radius: 4px; }
        .pagination a.active { background: red; }
    </style>
</head>
<body>

<div class="section">
       
<h2>Add New User</h2>
<% if (request.getAttribute("error") != null) { %>
    <p style="color:red;"><%= request.getAttribute("error") %></p>
<% } %>

<form action="add-user" method="post">
    <input type="text" name="name" placeholder="Full Name" required>
    <input type="text" name="username" placeholder="Username" required>
    <input type="password" name="password" placeholder="Password" required> <!-- Added -->
    <input type="email" name="email" placeholder="Email" required>
    <select name="role" required>
        <option value="user">User</option>
        <option value="admin">Admin</option>
        <option value="superadmin">Superadmin</option>
    </select>
    <select name="department" required>
        <% for(String dept : departments) { %>
            <option value="<%= dept %>"><%= dept %></option>
        <% } %>
    </select>
    <input type="submit" value="Add User">
</form>

    </div>
<h2>Add New Department</h2>
<form action="add-department" method="post">
    <input type="text" name="departmentName" placeholder="Department Name" required>
    <input type="submit" value="Add Department" class="button">
</form>

<h2>Departments</h2>
<table>
    <tr><th>Name</th><th>Action</th></tr>
    <% for(String dept : departments) { %>
        <tr>
            <td><%= dept %></td>
            <td>
                <a href="delete-department?name=<%= dept %>" class="button" onclick="return confirm('Delete department <%= dept %>?')">Delete</a>
            </td>
        </tr>
    <% } %>
</table>

<h2>Users</h2>
<form method="get" action="superadmin.jsp">
    <label>Filter by Department:</label>
    <select name="filterDept" onchange="this.form.submit()">
        <option value="">All</option>
        <% for(String dept : departments) { %>
            <option value="<%= dept %>" <%= dept.equals(filterDept) ? "selected" : "" %>><%= dept %></option>
        <% } %>
    </select>
</form>

<table>
    <tr><th>ID</th><th>Name</th><th>Username</th><th>Email</th><th>Role</th><th>Department</th><th>Actions</th></tr>
    <% for(String[] user : users) { %>
        <form action="edit-user" method="post">
            <tr>
                <td><input type="hidden" name="id" value="<%= user[0] %>"><%= user[0] %></td>
                <td><input type="text" name="name" value="<%= user[1] %>"></td>
                <td><input type="text" name="username" value="<%= user[2] %>"></td>
                <td><input type="email" name="email" value="<%= user[3] %>"></td>
                <td>
                    <select name="role">
                        <option value="user" <%= "user".equals(user[4]) ? "selected" : "" %>>User</option>
                        <option value="admin" <%= "admin".equals(user[4]) ? "selected" : "" %>>Admin</option>
                        <option value="superadmin" <%= "superadmin".equals(user[4]) ? "selected" : "" %>>Superadmin</option>
                    </select>
                </td>
                <td>
                    <select name="department">
                        <% for(String dept : departments) { %>
                            <option value="<%= dept %>" <%= dept.equals(user[5]) ? "selected" : "" %>><%= dept %></option>
                        <% } %>
                    </select>
                </td>
                <td>
                    <input type="submit" value="Save" class="button">
                    <a href="delete-user?id=<%= user[0] %>" class="button" onclick="return confirm('Delete user <%= user[2] %>?')">Delete</a>
                </td>
            </tr>
        </form>
    <% } %>
</table>

<div class="pagination">
    <% for(int i = 1; i <= totalPages; i++) { %>
        <a href="superadmin.jsp?page=<%= i %><%= filterDept != null && !filterDept.isEmpty() ? "&filterDept=" + filterDept : "" %>" class="<%= i == currentPage ? "active" : "" %>"><%= i %></a>
    <% } %>
</div>

</body>
</html>