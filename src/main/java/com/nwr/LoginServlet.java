package com.nwr;

import java.io.IOException;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/register", "root", "root");

            // Check credentials
            String query = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, username);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // Remember Me Cookie
                if ("on".equals(request.getParameter("remember"))) {
                    Cookie rememberCookie = new Cookie("rememberUser", username);
                    rememberCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
                    response.addCookie(rememberCookie);
                } else {
                    Cookie rememberCookie = new Cookie("rememberUser", "");
                    rememberCookie.setMaxAge(0);
                    response.addCookie(rememberCookie);
                }

                // Log login
                String ipAddress = request.getRemoteAddr();
                String insertLog = "INSERT INTO login_logs (username, ip_address) VALUES (?, ?)";
                PreparedStatement logStmt = con.prepareStatement(insertLog);
                logStmt.setString(1, username);
                logStmt.setString(2, ipAddress);
                logStmt.executeUpdate();
                logStmt.close();

                // Session
                String role = rs.getString("role");
                String name = rs.getString("name");
                HttpSession session = request.getSession();
                session.setAttribute("username", username);
                session.setAttribute("name", name);
                session.setAttribute("role", role);

                // Redirect by role
                switch (role) {
                    case "superadmin":
                        response.sendRedirect("superadmin.jsp");
                        break;
                    case "admin":
                        response.sendRedirect("admin.jsp");
                        break;
                    case "user":
                        response.sendRedirect("user.jsp");
                        break;
                    default:
                        response.sendRedirect("login.jsp?error=invalidrole");
                        break;
                }

            } else {
                // Invalid login
                response.sendRedirect("login.jsp?error=true");
            }

            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
