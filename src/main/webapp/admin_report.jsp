<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Generate Reports</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- GENERAL STYLES --- */
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; margin: 0; }

        /* --- SIDEBAR (Same as your other pages) --- */
        .sidebar { width: 260px; background-color: #800000; color: white; display: flex; flex-direction: column; padding: 20px; position: fixed; height: 100%; }
        .sidebar-header { font-size: 22px; font-weight: bold; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 20px; }
        .sidebar a { text-decoration: none; color: rgba(255, 255, 255, 0.8); padding: 15px; margin-bottom: 10px; display: block; border-radius: 8px; transition: 0.3s; }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.1); color: white; transform: translateX(5px); }
        .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }

        /* --- MAIN CONTENT --- */
        .main-content { margin-left: 260px; flex: 1; padding: 40px; }
        h2 { color: #800000; margin-bottom: 20px; }

        /* --- FILTER CARD --- */
        .filter-card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }
        
        .form-group { margin-bottom: 15px; }
        .form-label { display: block; font-weight: bold; margin-bottom: 5px; color: #333; }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }

        .btn-generate {
            background-color: #800000;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
            transition: 0.3s;
        }
        .btn-generate:hover { background-color: #600000; }

        /* --- REPORT TABLE --- */
        .report-header { background-color: #800000; color: white; padding: 15px; border-radius: 8px 8px 0 0; font-weight: bold; }
        .report-table { width: 100%; border-collapse: collapse; background: white; }
        .report-table th, .report-table td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #eee; }
        .report-table th { background-color: #f8f8f8; color: #333; font-weight: 600; border-bottom: 2px solid #ddd; }
        
        /* Status Badges */
        .status-badge { padding: 5px 10px; border-radius: 15px; font-size: 12px; font-weight: bold; }
        .status-approved { background-color: #e6f9e6; color: green; }
        .status-rejected { background-color: #ffe6e6; color: #cc0000; }
        .status-pending { background-color: #fff8e1; color: #f57c00; }

        /* Print Button */
        .print-btn { float: right; background: #333; color: white; padding: 5px 15px; text-decoration: none; font-size: 12px; border-radius: 4px; cursor: pointer; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manage_items.jsp"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="admin_report.jsp" class="active"><i class="fas fa-chart-bar"></i> Reports</a>
        <a href="LogoutServlet" style="margin-top:auto;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        <h2>Generate Report</h2>

        <div class="filter-card">
            <h3 style="color:#800000; margin-top:0;">Report Filters</h3>
            <form action="admin_report.jsp" method="GET">
                
                <div class="form-group">
                    <label class="form-label">Report Type (Status)</label>
                    <select name="status" class="form-control">
                        <option value="ALL">All Statuses</option>
                        <option value="APPROVED">Approved Items</option>
                        <option value="PENDING">Pending Approvals</option>
                        <option value="REJECTED">Rejected Items</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Date Range (Start - End)</label>
                    <div style="display: flex; gap: 10px;">
                        <input type="date" name="startDate" class="form-control">
                        <input type="date" name="endDate" class="form-control">
                    </div>
                </div>

                <button type="submit" class="btn-generate">Generate Report</button>
            </form>
        </div>

        <div class="report-header">
            Report Preview
            <button onclick="window.print()" class="print-btn"><i class="fas fa-print"></i> Print</button>
        </div>
        
        <table class="report-table">
            <thead>
                <tr>
                    <th>Item</th>
                    <th>Student</th>
                    <th>Status</th>
                    <th>Date Submitted</th>
                    <th>Price</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // --- JAVA LOGIC FOR REPORT GENERATION ---
                    String filterStatus = request.getParameter("status");
                    String startDate = request.getParameter("startDate");
                    String endDate = request.getParameter("endDate");

                    // Defaults if null
                    if(filterStatus == null) filterStatus = "ALL";

                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                        
                        // 1. Build Dynamic SQL
                        StringBuilder sql = new StringBuilder();
                        sql.append("SELECT i.item_name, u.username, i.status, i.date_submitted, i.price ");
                        sql.append("FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id ");
                        sql.append("WHERE 1=1 "); // Base condition to make appending easier

                        List<String> params = new ArrayList<>();

                        // Filter by Status
                        if (!"ALL".equals(filterStatus)) {
                            sql.append("AND i.status = ? ");
                            params.add(filterStatus);
                        }

                        // Filter by Date (Comparing Strings works for 'yyyy-MM-dd' format in standard SQL often, 
                        // but explicit casting is safer. We will use simplified timestamp comparison logic)
                        if (startDate != null && !startDate.isEmpty()) {
                            sql.append("AND i.date_submitted >= TIMESTAMP('" + startDate + " 00:00:00') ");
                        }
                        if (endDate != null && !endDate.isEmpty()) {
                            sql.append("AND i.date_submitted <= TIMESTAMP('" + endDate + " 23:59:59') ");
                        }

                        sql.append("ORDER BY i.date_submitted DESC");

                        // 2. Prepare Statement
                        PreparedStatement pstmt = conn.prepareStatement(sql.toString());

                        // 3. Set Parameters (only for Status currently)
                        int paramIndex = 1;
                        if (!"ALL".equals(filterStatus)) {
                            pstmt.setString(paramIndex++, filterStatus);
                        }

                        // 4. Execute
                        ResultSet rs = pstmt.executeQuery();
                        boolean hasData = false;
                        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

                        while(rs.next()) {
                            hasData = true;
                            String itemName = rs.getString("item_name");
                            String student = rs.getString("username");
                            String status = rs.getString("status");
                            Timestamp dateSub = rs.getTimestamp("date_submitted");
                            double price = rs.getDouble("price");

                            // Style the status
                            String badgeClass = "status-pending";
                            if("APPROVED".equalsIgnoreCase(status)) badgeClass = "status-approved";
                            if("REJECTED".equalsIgnoreCase(status)) badgeClass = "status-rejected";
                %>
                <tr>
                    <td><%= itemName %></td>
                    <td><%= student %></td>
                    <td><span class="status-badge <%= badgeClass %>"><%= status %></span></td>
                    <td><%= (dateSub != null) ? sdf.format(dateSub) : "-" %></td>
                    <td>$<%= price %></td>
                </tr>
                <%
                        }
                        
                        if(!hasData) {
                %>
                    <tr><td colspan="5" style="text-align:center; padding: 20px;">No records found for these filters.</td></tr>
                <%
                        }
                        conn.close();
                    } catch(Exception e) {
                        out.println("<tr><td colspan='5' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>

    </div>

</body>
</html>