package com.nwr;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/delete-department")
public class DeleteDepartmentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String deptName = request.getParameter("name");

        if (deptName == null || deptName.trim().isEmpty()) {
            response.sendRedirect("superadmin.jsp?error=noDept");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/register", "root", "root");

            // Optional: check if any users exist in this department
            PreparedStatement check = conn.prepareStatement("SELECT COUNT(*) FROM users WHERE department = ?");
            check.setString(1, deptName);
            ResultSet rs = check.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                response.sendRedirect("superadmin.jsp?error=deptInUse");
                rs.close();
                check.close();
                conn.close();
                return;
            }
            rs.close();
            check.close();

            String sql = "DELETE FROM departments WHERE name=?";
            PreparedStatement pst = conn.prepareStatement(sql);
            pst.setString(1, deptName);
            int deleted = pst.executeUpdate();

            pst.close();
            conn.close();

            if (deleted > 0) {
                response.sendRedirect("superadmin.jsp?deptDeleted=true");
            } else {
                response.sendRedirect("superadmin.jsp?error=deptNotFound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}