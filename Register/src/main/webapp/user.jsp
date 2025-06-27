<%@ page import="java.sql.*, java.util.*, javax.servlet.http.*, javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String searchFile = request.getParameter("searchFile");
    List<String[]> entries = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/register", "root", "root");

        String query = "SELECT * FROM register_entries WHERE username = ?";
        if (searchFile != null && !searchFile.trim().isEmpty()) {
            query += " AND file_number LIKE ?";
        }

        PreparedStatement ps = conn.prepareStatement(query);
        ps.setString(1, username);
        if (searchFile != null && !searchFile.trim().isEmpty()) {
            ps.setString(2, "%" + searchFile.trim() + "%");
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            entries.add(new String[]{
                rs.getString("file_number"),
                rs.getString("details"),
                rs.getString("function_year"),
                rs.getString("subject"),
                rs.getString("proposed_cost"),
                rs.getString("vetted_cost"),
                rs.getString("received_date"),
                rs.getString("putup_date"),
                rs.getString("dispatch_date"),
                rs.getString("status")
            });
        }
        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f0f2f5;
            margin: 0;
            padding: 20px;
        }
        h1, h2 {
            text-align: center;
        }
        .container {
            max-width: 1200px;
            margin: auto;
        }
        .card {
            background: white;
            padding: 20px;
            margin: 20px 0;
            border-radius: 10px;
            box-shadow: 0 0 10px #ccc;
        }
        input, select, textarea, button {
            padding: 8px;
            width: 100%;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
        }
        th, td {
            border: 1px solid #aaa;
            padding: 8px;
        }
        th {
            background: #eee;
        }
        .tool-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 10px;
        }
        .tool-link {
            background: #6a5acd;
            color: white;
            text-align: center;
            padding: 10px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
        }
        .tool-link:hover {
            background: #ff4c4c;
        }
        .report-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .report-buttons form {
            flex: 1;
            margin: 0 5px;
        }
        .report-buttons input[type="submit"] {
            background-color: #007bff;
            color: white;
            font-weight: bold;
            border: none;
            padding: 10px;
            cursor: pointer;
            border-radius: 5px;
        }
        .report-buttons input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .inline-edit {
            display: flex;
            flex-direction: column;
        }
    </style>
    <script>
        function delayedOpen(url) {
            setTimeout(() => window.open(url, '_blank'), 200);
        }
    </script>
</head>
<body>
<div class="container">
    <h1>Welcome, <%= username %></h1>

    <!-- Register Entry Form -->
    <div class="card">
        <h2>Add Register Entry</h2>
        <form action="register-entry" method="post">
            <label>File Number</label>
            <input type="text" name="file_number" required>

            <label>Details</label>
            <input type="text" name="details">

            <label>Function Year</label>
            <input type="text" name="function_year">

            <label>Subject</label>
            <textarea name="subject"></textarea>

            <label>Proposed Cost</label>
            <input type="number" step="0.01" name="proposed_cost">

            <label>Vetted Cost</label>
            <input type="number" step="0.01" name="vetted_cost">

            <label>Received Date</label>
            <input type="date" name="received_date">

            <label>Putup Date</label>
            <input type="date" name="putup_date">

            <label>Dispatch Date</label>
            <input type="date" name="dispatch_date">

            <label>Status</label>
            <select name="status">
                <option value="">-- Select --</option>
                <option value="V">V</option>
                <option value="R">R</option>
            </select>

            <button type="submit">Submit Entry</button>
        </form>
    </div>

    <!-- Important Links -->
    <div class="card">
        <h2>Important Links</h2>
        <div class="tool-grid">
            <a href="downloads/telephone-directory.pdf" class="tool-link" target="_blank">Telephone Directory</a>
            <a href="https://nwr.indianrailways.gov.in/" class="tool-link" target="_blank">NWR Circulars</a>
            <a href="https://efile.irfc.nic.in" class="tool-link" target="_blank">File Tracking</a>
            <a href="#" onclick="delayedOpen('https://services.eoffice.gov.in')" class="tool-link">eOffice</a>
            <a href="#" onclick="delayedOpen('https://aims.indianrailways.gov.in/IPAS/LoginForms/Login.jsp')" class="tool-link">IPAS</a>
            <a href="#" onclick="delayedOpen('https://parichay.nic.in/pnv1/assets/login?sid=SPARROWMINRAIL')" class="tool-link">SPARROW</a>
            <a href="#" onclick="delayedOpen('https://www.ireps.gov.in/')" class="tool-link">IREPS</a>
            <a href="#" onclick="delayedOpen('https://ircep.gov.in/IRPSM/')" class="tool-link">IRPSM</a>
            <a href="#" onclick="delayedOpen('https://email.gov.in/')" class="tool-link">NIC Mail</a>
            <a href="#" onclick="delayedOpen('https://gem.gov.in/')" class="tool-link">GeM</a>
            <a href="#" onclick="delayedOpen('https://home.rajasthan.gov.in/content/homeportal/en/homedepartment/contact-us/Helpline.html')" class="tool-link">Helpline</a>
        </div>
    </div>

    <!-- Generate Reports -->
    <div class="card">
        <h2>Generate Reports</h2>
        <div class="report-buttons">
            <form action="generate-report" method="get">
                <input type="hidden" name="days" value="7">
                <input type="submit" value="Last 7 Days Report">
            </form>
            <form action="generate-report" method="get">
                <input type="hidden" name="days" value="10">
                <input type="submit" value="Last 10 Days Report">
            </form>
            <form action="generate-report" method="get">
                <input type="hidden" name="days" value="30">
                <input type="submit" value="Last 30 Days Report">
            </form>
        </div>
    </div>

    <!-- Search and Table of Entries -->
    <div class="card">
        <h2>My Register Entries</h2>
        <form method="get" action="user.jsp">
            <label>Search by File Number</label>
            <input type="text" name="searchFile" placeholder="Enter file number" value="<%= (searchFile != null) ? searchFile : "" %>">
            <input type="submit" value="Search">
        </form>
        <table>
            <tr>
                <th>File Number</th>
                <th>Details</th>
                <th>Function Year</th>
                <th>Subject</th>
                <th>Proposed Cost</th>
                <th>Vetted Cost</th>
                <th>Received</th>
                <th>Putup</th>
                <th>Dispatch</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <% for (String[] entry : entries) { %>
                <form method="post" action="update-register-entry">
                    <tr>
                        <td><input type="text" name="file_number" value="<%= entry[0] %>" readonly></td>
                        <td><input type="text" name="details" value="<%= entry[1] %>"></td>
                        <td><input type="text" name="function_year" value="<%= entry[2] %>"></td>
                        <td><input type="text" name="subject" value="<%= entry[3] %>"></td>
                        <td><input type="number" step="0.01" name="proposed_cost" value="<%= entry[4] %>"></td>
                        <td><input type="number" step="0.01" name="vetted_cost" value="<%= entry[5] %>"></td>
                        <td><input type="date" name="received_date" value="<%= entry[6] %>"></td>
                        <td><input type="date" name="putup_date" value="<%= entry[7] %>"></td>
                        <td><input type="date" name="dispatch_date" value="<%= entry[8] %>"></td>
                        <td>
                            <select name="status">
                                <option value="">--</option>
                                <option value="V" <%= "V".equals(entry[9]) ? "selected" : "" %>>V</option>
                                <option value="R" <%= "R".equals(entry[9]) ? "selected" : "" %>>R</option>
                            </select>
                        </td>
                        <td><input type="submit" value="Update"></td>
                    </tr>
                </form>
            <% } %>
        </table>
    </div>

</div>
</body>
</html>
