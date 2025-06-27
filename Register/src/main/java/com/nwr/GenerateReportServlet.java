package com.nwr;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/generate-report")
public class GenerateReportServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String department = request.getParameter("department");
        String daysStr = request.getParameter("days");

        int days = 7;
        try {
            days = Integer.parseInt(daysStr);
        } catch (Exception ignored) {}

        List<Map<String, Object>> reportData = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/register", "root", "root");

            String userQuery = (department != null && !department.isEmpty())
                    ? "SELECT username FROM users WHERE department = ?"
                    : "SELECT username FROM users";
            PreparedStatement userStmt = conn.prepareStatement(userQuery);
            if (department != null && !department.isEmpty()) {
                userStmt.setString(1, department);
            }

            ResultSet userRs = userStmt.executeQuery();

            while (userRs.next()) {
                String username = userRs.getString("username");

                String sql = "SELECT " +
                        "COUNT(*) AS received, " +
                        "SUM(CASE WHEN status = 'V' THEN 1 ELSE 0 END) AS vetted, " +
                        "SUM(CASE WHEN status = 'R' THEN 1 ELSE 0 END) AS returned, " +
                        "SUM(CASE WHEN putup_date IS NOT NULL AND putup_date >= CURDATE() - INTERVAL ? DAY THEN 1 ELSE 0 END) AS putup, " +
                        "SUM(CASE WHEN status IS NULL OR status = '' THEN 1 ELSE 0 END) AS pending " +
                        "FROM register_entries " +
                        "WHERE username = ? AND received_date >= CURDATE() - INTERVAL ? DAY";

                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setInt(1, days);
                stmt.setString(2, username);
                stmt.setInt(3, days);

                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    int received = rs.getInt("received");
                    int vetted = rs.getInt("vetted");
                    int returned = rs.getInt("returned");
                    int putup = rs.getInt("putup");
                    int pending = rs.getInt("pending");

                    int opening = 0;
                    int closing = opening + received - vetted - returned;

                    Map<String, Object> row = new HashMap<>();
                    row.put("username", username);
                    row.put("opening", opening);
                    row.put("received", received);
                    row.put("vetted", vetted);
                    row.put("returned", returned);
                    row.put("putup", putup);
                    row.put("pending", pending);
                    row.put("closing", closing);

                    reportData.add(row);
                }

                stmt.close();
            }

            userRs.close();
            userStmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("department", department);
        request.setAttribute("days", days); // Keep this as Integer
        request.setAttribute("reportData", reportData);
        request.getRequestDispatcher("report.jsp").forward(request, response);
    }
}
