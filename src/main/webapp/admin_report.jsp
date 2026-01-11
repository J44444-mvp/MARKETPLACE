<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Generate Report | Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- GENERAL STYLES --- */
        :root { --primary: #800000; --bg-color: #f4f6f9; --text-dark: #2c3e50; }
        * { box-sizing: border-box; font-family: 'Poppins', sans-serif; margin: 0; padding: 0; }
        body { display: flex; min-height: 100vh; background-color: var(--bg-color); color: var(--text-dark); }

        /* Sidebar */
        .sidebar { width: 260px; background-color: var(--primary); color: white; display: flex; flex-direction: column; padding: 25px; position: fixed; height: 100%; z-index: 10; }
        .sidebar-header { font-size: 22px; font-weight: 700; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .sidebar a { text-decoration: none; color: rgba(255, 255, 255, 0.85); padding: 15px; margin-bottom: 10px; display: flex; align-items: center; gap: 12px; border-radius: 8px; transition: 0.3s; font-size: 14px; }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.15); transform: translateX(5px); color: white; }
        .sidebar a.active { background-color: white; color: var(--primary); font-weight: 600; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }

        /* Main Content */
        .main-content { margin-left: 260px; flex: 1; padding: 40px; width: calc(100% - 260px); }
        h2 { color: var(--primary); margin-bottom: 20px; font-weight: 700; }

        /* Filter Box */
        .filter-box { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); margin-bottom: 30px; border-top: 4px solid var(--primary); }
        .filter-row { display: flex; gap: 20px; align-items: flex-end; }
        .form-group { flex: 1; }
        .form-group label { display: block; font-weight: 600; margin-bottom: 8px; font-size: 13px; color: #555; }
        .form-control { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; }
        .btn-generate { background: var(--primary); color: white; border: none; padding: 10px 25px; border-radius: 4px; cursor: pointer; font-weight: 600; height: 42px; display: flex; align-items: center; justify-content: center; gap: 8px; }
        .btn-generate:hover { background: #a31515; }

        /* Report Section */
        .report-section { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .report-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #eee; padding-bottom: 15px; }
        .btn-print { background: #333; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; display: flex; align-items: center; gap: 8px; font-size: 13px; }
        .btn-print:hover { background: #555; }

        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th { background: #f8f9fa; color: #333; font-weight: 600; padding: 12px; text-align: left; border-bottom: 2px solid #ddd; font-size: 13px; }
        td { padding: 12px; border-bottom: 1px solid #eee; font-size: 13px; color: #555; }

        /* Status Badges */
        .status-badge { padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 700; text-transform: uppercase; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-approved { background: #d4edda; color: #155724; }
        .status-rejected { background: #f8d7da; color: #721c24; }
        .status-sold { background: #e2e3e5; color: #383d41; }

        /* Hidden Print Header */
        .print-header { display: none; }

        /* --- PRINT STYLES --- */
        @media print {
            body * { visibility: hidden; }
            .sidebar, .filter-box, .btn-print, .main-content h2 { display: none !important; }
            .main-content { margin: 0 !important; padding: 0 !important; width: 100% !important; }
            
            #printableArea, #printableArea * { visibility: visible; }
            #printableArea { position: absolute; left: 0; top: 0; width: 100%; background: white; padding: 0; }

            /* Show Custom Print Header */
            .print-header { display: block !important; text-align: center; margin-bottom: 20px; border-bottom: 2px solid #000; padding-bottom: 15px; }
            .print-header h1 { font-size: 24px; color: #000; margin-bottom: 5px; }
            .print-header p { font-size: 14px; color: #444; margin-bottom: 3px; }

            /* Table for Print */
            table { width: 100% !important; border: 1px solid #000; }
            th { background-color: #eee !important; color: #000 !important; border: 1px solid #000; -webkit-print-color-adjust: exact; }
            td { border: 1px solid #ddd; color: #000 !important; }
            @page { margin: 15mm; }
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-shield-alt"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="manage_items.jsp"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="admin_report.jsp" class="active"><i class="fas fa-chart-line"></i> Reports</a>
        <a href="LogoutServlet" style="margin-top:auto; color: #ffadad;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        <h2>Generate Report</h2>

        <div class="filter-box">
            <form action="admin_report.jsp" method="GET">
                <div class="filter-row">
                    <div class="form-group">
                        <label>Report Status</label>
                        <select name="status" class="form-control">
                            <option value="ALL">All Statuses</option>
                            <option value="PENDING" <%= "PENDING".equals(request.getParameter("status")) ? "selected" : "" %>>Pending Approval</option>
                            <option value="APPROVED" <%= "APPROVED".equals(request.getParameter("status")) ? "selected" : "" %>>Active / Approved</option>
                            <option value="SOLD" <%= "SOLD".equals(request.getParameter("status")) ? "selected" : "" %>>Sold Items</option>
                            <option value="REJECTED" <%= "REJECTED".equals(request.getParameter("status")) ? "selected" : "" %>>Rejected Items</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>From Date</label>
                        <input type="date" name="startDate" class="form-control" value="<%= request.getParameter("startDate") == null ? "" : request.getParameter("startDate") %>">
                    </div>

                    <div class="form-group">
                        <label>To Date</label>
                        <input type="date" name="endDate" class="form-control" value="<%= request.getParameter("endDate") == null ? "" : request.getParameter("endDate") %>">
                    </div>

                    <button type="submit" class="btn-generate"><i class="fas fa-filter"></i> Generate</button>
                </div>
            </form>
        </div>

        <div class="report-section" id="printableArea">
            
            <%
                // Capture Parameters for Display in Header & Logic
                String filterStatus = request.getParameter("status");
                String startDate = request.getParameter("startDate");
                String endDate = request.getParameter("endDate");

                if (filterStatus == null) filterStatus = "ALL";
                String displayStart = (startDate == null || startDate.isEmpty()) ? "Beginning" : startDate;
                String displayEnd = (endDate == null || endDate.isEmpty()) ? "Today" : endDate;
                
                // --- FIX FOR MYT DATE DISPLAY ---
                SimpleDateFormat sdfPrint = new SimpleDateFormat("EEE, d MMM yyyy h:mm:ss a 'MYT'");
                sdfPrint.setTimeZone(TimeZone.getTimeZone("Asia/Kuala_Lumpur"));
                String printDate = sdfPrint.format(new java.util.Date());
            %>

            <div class="print-header">
                <h1>Campus Marketplace Report</h1>
                <p><strong>Generated On:</strong> <%= printDate %></p>
                <p><strong>Filter Category:</strong> <%= filterStatus %> ITEMS</p>
                <p><strong>Date Range:</strong> <%= displayStart %> to <%= displayEnd %></p>
            </div>

            <div class="report-header">
                <h3>Results: <%= filterStatus %> Items</h3>
                <button onclick="window.print()" class="btn-print"><i class="fas fa-print"></i> Print Report</button>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Item Name</th>
                        <th>Student Name</th>
                        <th>Status</th>
                        <th>Date Submitted</th>
                        <th>Price (RM)</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection conn = null;
                    Statement stmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                        
                        // Start with a generic True condition (1=1) so we can simply append AND conditions
                        String sql = "SELECT i.item_id, i.item_name, i.status, i.date_submitted, i.price, u.full_name " +
                                     "FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id WHERE 1=1 ";
                        
                        // 1. Filter by Status
                        if(!"ALL".equals(filterStatus)) {
                            sql += " AND i.status = '" + filterStatus + "' ";
                        }

                        // 2. Filter by Start Date
                        if(startDate != null && !startDate.isEmpty()) {
                            sql += " AND i.date_submitted >= '" + startDate + " 00:00:00' ";
                        }

                        // 3. Filter by End Date
                        if(endDate != null && !endDate.isEmpty()) {
                            sql += " AND i.date_submitted <= '" + endDate + " 23:59:59' ";
                        }

                        sql += " ORDER BY i.date_submitted DESC";

                        stmt = conn.createStatement();
                        rs = stmt.executeQuery(sql);
                        boolean hasData = false;
                        
                        // Formatter for table rows
                        SimpleDateFormat sdfRow = new SimpleDateFormat("dd MMM yyyy");
                        // Optional: Force row dates to MYT too if needed, though usually just date is fine
                        sdfRow.setTimeZone(TimeZone.getTimeZone("Asia/Kuala_Lumpur"));

                        while(rs.next()) {
                            hasData = true;
                            String status = rs.getString("status");
                            String badgeClass = "status-sold";
                            if(status.equals("PENDING")) badgeClass = "status-pending";
                            else if(status.equals("APPROVED")) badgeClass = "status-approved";
                            else if(status.equals("REJECTED")) badgeClass = "status-rejected";
                %>
                    <tr>
                        <td>#<%= rs.getInt("item_id") %></td>
                        <td><%= rs.getString("item_name") %></td>
                        <td><%= rs.getString("full_name") %></td>
                        <td><span class="status-badge <%= badgeClass %>"><%= status %></span></td>
                        <td><%= sdfRow.format(rs.getTimestamp("date_submitted")) %></td>
                        <td><%= String.format("%.2f", rs.getDouble("price")) %></td>
                    </tr>
                <% 
                        }
                        if(!hasData) {
                            out.println("<tr><td colspan='6' style='text-align:center; padding:20px; color:#777;'>No items found matching these filters.</td></tr>");
                        }
                    } catch(Exception e) {
                        out.println("<tr><td colspan='6' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>