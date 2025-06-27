package com.nwr;

import java.sql.*;
import java.util.*;

public class AdminDAO {
    private Connection conn;

    public AdminDAO() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/register", "root", "root");
    }

    public List<String> getDepartments() throws Exception {
        List<String> departments = new ArrayList<>();
        String sql = "SELECT name FROM departments";
        PreparedStatement pst = conn.prepareStatement(sql);
        ResultSet rs = pst.executeQuery();
        while (rs.next()) {
            departments.add(rs.getString("name"));
        }
        rs.close();
        pst.close();
        return departments;
    }

    public List<Map<String, String>> getUsers() throws Exception {
        List<Map<String, String>> users = new ArrayList<>();
        String sql = "SELECT id, name, username, role, department FROM users";
        PreparedStatement pst = conn.prepareStatement(sql);
        ResultSet rs = pst.executeQuery();
        while (rs.next()) {
            Map<String, String> user = new HashMap<>();
            user.put("id", rs.getString("id"));
            user.put("name", rs.getString("name"));
            user.put("username", rs.getString("username"));
            user.put("role", rs.getString("role"));
            user.put("department", rs.getString("department"));
            users.add(user);
        }
        rs.close();
        pst.close();
        return users;
    }

    public void close() throws Exception {
        if (conn != null) conn.close();
    }
}
