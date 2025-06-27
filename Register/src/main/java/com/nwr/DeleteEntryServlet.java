package com.nwr;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/delete-entry")
public class DeleteEntryServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fileNumberStr = request.getParameter("file_number");

        response.setContentType("text/html;charset=UTF-8");

        if (fileNumberStr == null || fileNumberStr.trim().isEmpty()) {
            response.getWriter().println("<h3>⚠️ Missing file number.</h3>");
        } else {
            try {
                int fileNumber = Integer.parseInt(fileNumberStr);

                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/register", "root", "root");

                String sql = "DELETE FROM register_entries WHERE file_number = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, fileNumber);

                int rows = stmt.executeUpdate();

                if (rows > 0) {
                    response.getWriter().println("<h3>✅ Entry with File Number " + fileNumber + " deleted successfully.</h3>");
                } else {
                    response.getWriter().println("<h3>❌ No entry found with File Number " + fileNumber + ".</h3>");
                }

                stmt.close();
                conn.close();
            } catch (NumberFormatException e) {
                response.getWriter().println("<h3>❌ Invalid file number format.</h3>");
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("<h3>❌ Database error: " + e.getMessage() + "</h3>");
            }
        }

        // Back button
        response.getWriter().println("<br><a href='admin.jsp'><button>🔙 Back to Admin Dashboard</button></a>");
    }
}
