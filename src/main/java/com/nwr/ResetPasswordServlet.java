package com.nwr;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String newPassword = request.getParameter("newPassword");

        response.setContentType("text/html;charset=UTF-8");

        if (username == null || username.isEmpty() || newPassword == null || newPassword.isEmpty()) {
            response.getWriter().println("<h3>⚠️ Missing username or password.</h3>");
        } else {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/register", "root", "root");

                String sql = "UPDATE users SET password = ? WHERE username = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, newPassword);
                stmt.setString(2, username);

                int rows = stmt.executeUpdate();
                if (rows > 0) {
                    response.getWriter().println("<h3>✅ Password reset successfully for user: " + username + "</h3>");
                } else {
                    response.getWriter().println("<h3>❌ User not found or password not updated.</h3>");
                }

                stmt.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("<h3>❌ Database error: " + e.getMessage() + "</h3>");
            }
        }

        // Back button
        response.getWriter().println("<br><a href='admin.jsp'><button>🔙 Back to Admin Dashboard</button></a>");
    }
}
