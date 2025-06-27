package com.nwr;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/register-entry")
public class RegisterEntryServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String file_number = request.getParameter("file_number");
        String details = request.getParameter("details");
        String function_year = request.getParameter("function_year");
        String subject = request.getParameter("subject");
        String proposed_cost = request.getParameter("proposed_cost");
        String vetted_cost = request.getParameter("vetted_cost");
        String received_date = request.getParameter("received_date");
        String putup_date = request.getParameter("putup_date");
        String dispatch_date = request.getParameter("dispatch_date");
        String status = request.getParameter("status");

        HttpSession session = request.getSession(false);
        String username = (session != null) ? (String) session.getAttribute("username") : null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/register", "root", "root");

            String sql = "INSERT INTO register_entries (file_number, details, function_year, subject, proposed_cost, vetted_cost, received_date, putup_date, dispatch_date, status, username) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(file_number));
            ps.setString(2, details);
            ps.setString(3, function_year);
            ps.setString(4, subject);
            ps.setString(5, proposed_cost);
            ps.setString(6, vetted_cost);
            ps.setString(7, received_date == null || received_date.isEmpty() ? null : received_date);
            ps.setString(8, putup_date == null || putup_date.isEmpty() ? null : putup_date);
            ps.setString(9, dispatch_date == null || dispatch_date.isEmpty() ? null : dispatch_date);
            ps.setString(10, status == null || status.isEmpty() ? null : status);
            ps.setString(11, username);

            ps.executeUpdate();
            conn.close();

            response.sendRedirect("user.jsp");
        } catch (Exception e) {
            response.getWriter().println("Database Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
