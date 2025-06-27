<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userId = request.getParameter("id");

    if (userId == null) {
        response.sendRedirect("superadmin.jsp");
        return;
    }

    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    Map<String, String> user = new HashMap<>();
    List<String> departmentList = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/register", "root", "root");

        pst = con.prepareStatement("SELECT * FROM users WHERE id = ?");
        pst.setInt(1, Integer.parseInt(userId));
        rs = pst.executeQuery();
        if (rs.next()) {
            user.put("id", rs.getString("id"));
            user.put("name", rs.getString("name"));
            user.put("username", rs.getString("username"));
            user.put("email", rs.getString("email"));
            user.put("role", rs.getString("role"));
            user.put("department", rs.getString("department"));
        }
        rs.close();
        pst.close();

        // Load department list
        pst = con.prepareStatement("SELECT name FROM departments");
        rs = pst.executeQuery();
        while (rs.next()) {
            departmentList.add(rs.getString("name"));
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (con != null) con.close();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit User</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f0f2f5;
            padding: 40px;
        }
        .form-box {
            background: #fff;
            padding: 30px;
            max-width: 500px;
            margin: auto;
            border-radius: 10px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
        }
        input[type="text"], input[type="email"], select {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        input[type="submit"] {
            width: 100%;
            padding: 12px;
            background: #6a5acd;
            border: none;
            color: white;
            font-weight: bold;
            cursor: pointer;
            border-radius: 6px;
        }
        input[type="submit"]:hover {
            background: red;
        }
    </style>
</head>
<body>
    <div class="form-box">
        <h2>Edit User</h2>
        <form action="edit-user" method="post">
            <input type="hidden" name="id" value="<%= user.get("id") %>">
            <input type="text" name="name" value="<%= user.get("name") %>" placeholder="Name" required>
            <input type="text" name="username" value="<%= user.get("username") %>" placeholder="Username" required>
            <input type="email" name="email" value="<%= user.get("email") %>" placeholder="Email" required>

            <select name="role" required>
                <option value="user" <%= "user".equals(user.get("role")) ? "selected" : "" %>>User</option>
                <option value="admin" <%= "admin".equals(user.get("role")) ? "selected" : "" %>>Admin</option>
                <option value="superadmin" <%= "superadmin".equals(user.get("role")) ? "selected" : "" %>>Superadmin</option>
            </select>

            <select name="department" required>
                <% for (String dept : departmentList) { %>
                    <option value="<%= dept %>" <%= dept.equals(user.get("department")) ? "selected" : "" %>>
                        <%= dept %>
                    </option>
                <% } %>
            </select>

            <input type="submit" value="Update User">
        </form>
    </div>
</body>
</html>
