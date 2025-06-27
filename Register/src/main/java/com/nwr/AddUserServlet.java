package com.nwr;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/add-user")
public class AddUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String department = request.getParameter("department");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/register", "root", "root");

            // 1. Check if username already exists
            String checkSql = "SELECT COUNT(*) FROM users WHERE username = ?";
            PreparedStatement checkStmt = con.prepareStatement(checkSql);
            checkStmt.setString(1, username);
            ResultSet rs = checkStmt.executeQuery();
            rs.next();
            int count = rs.getInt(1);
            rs.close();
            checkStmt.close();

            if (count > 0) {
                // Username already exists
                request.setAttribute("error", "Username already exists. Please choose a different one.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("superadmin.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // 2. Insert new user
            String insertSql = "INSERT INTO users (name, username, password, email, role, department) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement insertStmt = con.prepareStatement(insertSql);
            insertStmt.setString(1, name);
            insertStmt.setString(2, username);
            insertStmt.setString(3, password);
            insertStmt.setString(4, email);
            insertStmt.setString(5, role);
            insertStmt.setString(6, department);

            int rowsInserted = insertStmt.executeUpdate();
            insertStmt.close();
            con.close();

            if (rowsInserted > 0) {
                request.setAttribute("name", name);
                request.setAttribute("username", username);
                request.setAttribute("email", email);
                request.setAttribute("role", role);
                request.setAttribute("department", department);
                RequestDispatcher dispatcher = request.getRequestDispatcher("useradded.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendRedirect("superadmin.jsp?error=insertfailed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database Error: " + e.getMessage());
        }
    }
}
