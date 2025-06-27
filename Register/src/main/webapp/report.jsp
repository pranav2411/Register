<%@ page import="java.util.*, java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String department = (String) request.getAttribute("department");
    int days = 0;
    Object daysAttr = request.getAttribute("days");
    if (daysAttr instanceof Integer) {
        days = (Integer) daysAttr;
    } else if (daysAttr instanceof String) {
        try {
            days = Integer.parseInt((String) daysAttr);
        } catch (Exception e) {
            days = 0;
        }
    }

    List<Map<String, Object>> reportData = (List<Map<String, Object>>) request.getAttribute("reportData");

    int totalOpening = 0, totalReceived = 0, totalVetted = 0, totalReturned = 0, totalPutup = 0, totalPending = 0, totalClosing = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Department Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 20px;
            background: #f4f6f9;
        }
        h1 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #6a5acd;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .btn-container {
            margin-top: 20px;
        }
        .btn {
            background: #6a5acd;
            color: white;
            padding: 10px 16px;
            margin-right: 10px;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            cursor: pointer;
        }
        .btn:hover {
            background: #483d8b;
        }
    </style>
</head>
<body>

<h1>Department Report - <%= (department == null || department.isEmpty()) ? "All Departments" : department %> (Last <%= days %> Days)</h1>

<div class="btn-container">
    <a href="javascript:history.back()" class="btn"> Back</a>
    <a href="export-report?type=excel&department=<%= department %>&days=<%= days %>" class="btn">Export to Excel</a>
    <a href="export-report?type=pdf&department=<%= department %>&days=<%= days %>" class="btn">Export to PDF</a>
</div>

<table>
    <tr>
        <th>Username</th>
        <th>Opening Balance</th>
        <th>Received Files</th>
        <th>Vetted Files</th>
        <th>Returned Files</th>
        <th>Put-up Files</th>
        <th>Files Pending</th>
        <th>Closing Balance</th>
    </tr>
    <% 
        if (reportData != null) {
            for (Map<String, Object> row : reportData) {
                int opening = (int) row.get("opening");
                int received = (int) row.get("received");
                int vetted = (int) row.get("vetted");
                int returned = (int) row.get("returned");
                int putup = (int) row.get("putup");
                int pending = (int) row.get("pending");
                int closing = (int) row.get("closing");

                totalOpening += opening;
                totalReceived += received;
                totalVetted += vetted;
                totalReturned += returned;
                totalPutup += putup;
                totalPending += pending;
                totalClosing += closing;
    %>
    <tr>
        <td><%= row.get("username") %></td>
        <td><%= opening %></td>
        <td><%= received %></td>
        <td><%= vetted %></td>
        <td><%= returned %></td>
        <td><%= putup %></td>
        <td><%= pending %></td>
        <td><%= closing %></td>
    </tr>
    <% 
            } 
        } else {
    %>
    <tr>
        <td colspan="8">No data available.</td>
    </tr>
    <% } %>

    <!-- Total row -->
    <tr style="font-weight: bold; background: #dcdcdc;">
        <td>Total</td>
        <td><%= totalOpening %></td>
        <td><%= totalReceived %></td>
        <td><%= totalVetted %></td>
        <td><%= totalReturned %></td>
        <td><%= totalPutup %></td>
        <td><%= totalPending %></td>
        <td><%= totalClosing %></td>
    </tr>
</table>

</body>
</html>
