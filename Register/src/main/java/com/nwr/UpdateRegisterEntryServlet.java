package com.nwr;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/update-register-entry")
public class UpdateRegisterEntryServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fileNumber = request.getParameter("file_number");
        String details = request.getParameter("details");
        String functionYear = request.getParameter("function_year");
        String subject = request.getParameter("subject");
        String proposedCostStr = request.getParameter("proposed_cost");
        String vettedCostStr = request.getParameter("vetted_cost");
        String receivedDate = request.getParameter("received_date");
        String putupDate = request.getParameter("putup_date");
        String dispatchDate = request.getParameter("dispatch_date");
        String status = request.getParameter("status");

        double proposedCost = 0;
        double vettedCost = 0;

        try {
            if (proposedCostStr != null && !proposedCostStr.isEmpty()) {
                proposedCost = Double.parseDouble(proposedCostStr);
            }
            if (vettedCostStr != null && !vettedCostStr.isEmpty()) {
                vettedCost = Double.parseDouble(vettedCostStr);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace(); // Log invalid numbers
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/register", "root", "root");

            String sql = "UPDATE register_entries SET details=?, function_year=?, subject=?, proposed_cost=?, vetted_cost=?, received_date=?, putup_date=?, dispatch_date=?, status=? WHERE file_number=?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, details);
            stmt.setString(2, functionYear);
            stmt.setString(3, subject);
            stmt.setDouble(4, proposedCost);
            stmt.setDouble(5, vettedCost);
            stmt.setString(6, receivedDate != null && !receivedDate.isEmpty() ? receivedDate : null);
            stmt.setString(7, putupDate != null && !putupDate.isEmpty() ? putupDate : null);
            stmt.setString(8, dispatchDate != null && !dispatchDate.isEmpty() ? dispatchDate : null);
            stmt.setString(9, status);
            stmt.setString(10, fileNumber);

            int updated = stmt.executeUpdate();

            stmt.close();
            conn.close();

            if (updated > 0) {
                response.sendRedirect("user.jsp?message=updated");
            } else {
                response.sendRedirect("user.jsp?error=notfound");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user.jsp?error=exception");
        }
    }
}
