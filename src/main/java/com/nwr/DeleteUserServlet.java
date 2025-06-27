package com.nwr;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/delete-user")
public class DeleteUserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userId = request.getParameter("id");

        if (userId == null || userId.trim().isEmpty()) {
            response.sendRedirect("superadmin.jsp?error=noUserId");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/register", "root", "root");

            String sql = "DELETE FROM users WHERE id=?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setInt(1, Integer.parseInt(userId));

            int deleted = pst.executeUpdate();
            pst.close();
            conn.close();

            if (deleted > 0) {
                response.sendRedirect("superadmin.jsp?deleted=true");
            } else {
                response.sendRedirect("superadmin.jsp?error=notFound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
