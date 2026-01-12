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
        .status-badge { padding: 4px 8px; border-radius: 12px; font-size: 11px; font-weight: 700; text-transform: uppercase; display: inline-block; min-width: 80px; text-align: center; }
        .status-pending { background: #fff3cd; color: #856404; }
        .status-available { background: #d4edda; color: #155724; }
        .status-rejected { background: #f8d7da; color: #721c24; }
        .status-sold { background: #e2e3e5; color: #383d41; }

        /* Hidden Print Header */
        .print-header { display: none; }

        /* Summary Stats */
        .summary-stats { display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap; }
        .stat-card { background: white; border-radius: 6px; padding: 15px; flex: 1; min-width: 150px; border-left: 4px solid var(--primary); box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .stat-number { font-size: 24px; font-weight: 700; color: var(--primary); }
        .stat-label { font-size: 12px; color: #666; margin-top: 5px; }

        /* Revenue Summary (Screen only) */
        .revenue-summary { 
            background: white; 
            border-radius: 8px; 
            padding: 20px; 
            margin-bottom: 20px; 
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            border-left: 4px solid #28a745;
        }
        .revenue-summary h4 { 
            color: #28a745; 
            margin-bottom: 15px; 
            font-size: 16px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }
        .revenue-grid { 
            display: grid; 
            grid-template-columns: repeat(3, 1fr); 
            gap: 15px; 
        }
        .revenue-item { 
            padding: 10px; 
            background: #f8f9fa; 
            border-radius: 4px; 
        }
        .revenue-label { 
            font-size: 11px; 
            color: #666; 
            text-transform: uppercase; 
            letter-spacing: 0.5px; 
            margin-bottom: 5px; 
        }
        .revenue-value { 
            font-size: 18px; 
            font-weight: 700; 
            color: #28a745; 
        }

        /* --- PRINT STYLES --- */
        @media print {
            body * { visibility: hidden; }
            .sidebar, .filter-box, .btn-print, .main-content h2, .summary-stats, .revenue-summary { display: none !important; }
            .main-content { margin: 0 !important; padding: 0 !important; width: 100% !important; }
            
            #printableArea, #printableArea * { visibility: visible; }
            #printableArea { position: absolute; left: 0; top: 0; width: 100%; background: white; padding: 0; }

            /* Show Custom Print Header */
            .print-header { 
                display: block !important; 
                margin-bottom: 20px; 
                text-align: center;
                border-bottom: 2px solid #000;
                padding-bottom: 15px;
            }
            .print-header h1 { 
                font-size: 20px; 
                color: #000; 
                margin-bottom: 5px; 
                font-weight: 700;
            }
            .print-header p { 
                font-size: 12px; 
                color: #444; 
                margin-bottom: 3px; 
            }

            /* Print Revenue Summary Table */
            .print-revenue-table {
                width: 100%;
                border-collapse: collapse;
                margin: 15px 0 20px 0;
                font-size: 11px;
            }
            .print-revenue-table thead th {
                background-color: #f2f2f2 !important;
                color: #000 !important;
                padding: 8px;
                text-align: center;
                border: 1px solid #ddd;
                font-weight: 700;
                font-size: 12px;
            }
            .print-revenue-table tbody td {
                padding: 10px;
                border: 1px solid #ddd;
                text-align: left;
                vertical-align: top;
            }
            .print-revenue-table tbody td b {
                font-size: 13px;
                color: #000;
                display: block;
                margin-top: 3px;
            }
            .print-revenue-label {
                font-size: 10px;
                color: #666;
            }

            /* Table for Print */
            table { 
                width: 100% !important; 
                border: 1px solid #000;
                font-size: 11px;
                margin-top: 15px;
            }
            th { 
                background-color: #eee !important; 
                color: #000 !important; 
                border: 1px solid #000; 
                -webkit-print-color-adjust: exact; 
                padding: 8px;
                font-size: 11px;
            }
            td { 
                border: 1px solid #ddd; 
                color: #000 !important; 
                padding: 8px;
                font-size: 11px;
            }
            
            /* Print Footer */
            .print-footer {
                margin-top: 20px;
                padding-top: 15px;
                border-top: 1px solid #000;
                text-align: center;
                font-size: 10px;
                color: #666;
            }
            
            @page { 
                margin: 15mm;
                size: A4 portrait;
            }
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
                            <option value="AVAILABLE" <%= "AVAILABLE".equals(request.getParameter("status")) ? "selected" : "" %>>Available Items</option>
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

        <%
            // Capture Parameters
            String filterStatus = request.getParameter("status");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            
            // Set defaults
            if (filterStatus == null || filterStatus.trim().isEmpty()) {
                filterStatus = "ALL";
            }
            
            // Get current date for default "To Date" if not specified
            java.util.Date currentDate = new java.util.Date();
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            if (endDate == null || endDate.trim().isEmpty()) {
                endDate = dateFormat.format(currentDate);
            }
            
            // Get one month ago for default "From Date" if not specified
            Calendar cal = Calendar.getInstance();
            cal.setTime(currentDate);
            cal.add(Calendar.MONTH, -1);
            if (startDate == null || startDate.trim().isEmpty()) {
                startDate = dateFormat.format(cal.getTime());
            }
            
            // For display
            SimpleDateFormat displayFormat = new SimpleDateFormat("dd MMM yyyy");
            String displayStart = (startDate == null || startDate.isEmpty()) ? "Beginning" : displayFormat.format(dateFormat.parse(startDate));
            String displayEnd = (endDate == null || endDate.isEmpty()) ? "Today" : displayFormat.format(dateFormat.parse(endDate));
            
            // Get Current Time for Print Header (MYT)
            SimpleDateFormat sdfPrint = new SimpleDateFormat("EEE, d MMM yyyy h:mm:ss a");
            sdfPrint.setTimeZone(TimeZone.getTimeZone("Asia/Kuala_Lumpur"));
            String printDate = sdfPrint.format(new java.util.Date());
            
            // Summary statistics - ADDED REVENUE STATS
            int totalItems = 0;
            int pendingCount = 0;
            int availableCount = 0;
            int soldCount = 0;
            int rejectedCount = 0;
            double totalRevenue = 0.0;
            double potentialRevenue = 0.0; // Available items value
            double totalMarketValue = 0.0; // All items value
            double avgSoldPrice = 0.0;
            double avgAvailablePrice = 0.0;
        %>

        <div class="report-section" id="printableArea">
            
            <div class="print-header">
                <h1>Campus Marketplace Report</h1>
                <p><strong>Generated On:</strong> <%= printDate %></p>
                <p><strong>Filter Category:</strong> <%= filterStatus %> ITEMS</p>
                <p><strong>Date Range:</strong> <%= displayStart %> to <%= displayEnd %></p>
                
                <%-- REVENUE SUMMARY TABLE FOR PRINT --%>
                <table class="print-revenue-table">
                    <thead>
                        <tr>
                            <th colspan="2">Revenue Summary</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            // Calculate revenue statistics
                            Connection revenueConn = null;
                            PreparedStatement revenueStmt = null;
                            ResultSet revenueRs = null;
                            
                            try {
                                Class.forName("org.apache.derby.jdbc.ClientDriver");
                                revenueConn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                                
                                // Build revenue query
                                StringBuilder revenueSql = new StringBuilder();
                                revenueSql.append("SELECT ");
                                revenueSql.append("COUNT(*) as total_items, ");
                                revenueSql.append("SUM(CASE WHEN UPPER(status) = 'SOLD' THEN 1 ELSE 0 END) as sold_items, ");
                                revenueSql.append("SUM(CASE WHEN UPPER(status) = 'AVAILABLE' THEN 1 ELSE 0 END) as available_items, ");
                                revenueSql.append("SUM(CASE WHEN UPPER(status) = 'SOLD' THEN price ELSE 0 END) as total_revenue, ");
                                revenueSql.append("SUM(CASE WHEN UPPER(status) = 'AVAILABLE' THEN price ELSE 0 END) as potential_revenue, ");
                                revenueSql.append("SUM(price) as total_market_value, ");
                                revenueSql.append("AVG(CASE WHEN UPPER(status) = 'SOLD' THEN price END) as avg_sold_price, ");
                                revenueSql.append("AVG(CASE WHEN UPPER(status) = 'AVAILABLE' THEN price END) as avg_available_price ");
                                revenueSql.append("FROM ITEMS WHERE 1=1 ");
                                
                                // Date filters only
                                if (startDate != null && !startDate.isEmpty()) {
                                    revenueSql.append(" AND date_submitted >= ?");
                                }
                                if (endDate != null && !endDate.isEmpty()) {
                                    revenueSql.append(" AND date_submitted <= ?");
                                }
                                
                                revenueStmt = revenueConn.prepareStatement(revenueSql.toString());
                                
                                int paramIndex = 1;
                                if (startDate != null && !startDate.isEmpty()) {
                                    revenueStmt.setString(paramIndex++, startDate + " 00:00:00");
                                }
                                if (endDate != null && !endDate.isEmpty()) {
                                    revenueStmt.setString(paramIndex++, endDate + " 23:59:59");
                                }
                                
                                revenueRs = revenueStmt.executeQuery();
                                
                                if (revenueRs.next()) {
                                    totalItems = revenueRs.getInt("total_items");
                                    soldCount = revenueRs.getInt("sold_items");
                                    availableCount = revenueRs.getInt("available_items");
                                    totalRevenue = revenueRs.getDouble("total_revenue");
                                    potentialRevenue = revenueRs.getDouble("potential_revenue");
                                    totalMarketValue = revenueRs.getDouble("total_market_value");
                                    avgSoldPrice = revenueRs.getDouble("avg_sold_price");
                                    avgAvailablePrice = revenueRs.getDouble("avg_available_price");
                                    
                                    // Calculate pending and rejected counts
                                    Connection countConn = null;
                                    try {
                                        countConn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                                        String countSql = "SELECT " +
                                            "SUM(CASE WHEN UPPER(status) = 'PENDING' THEN 1 ELSE 0 END) as pending, " +
                                            "SUM(CASE WHEN UPPER(status) = 'REJECTED' THEN 1 ELSE 0 END) as rejected " +
                                            "FROM ITEMS WHERE 1=1 ";
                                        
                                        if (startDate != null && !startDate.isEmpty()) {
                                            countSql += " AND date_submitted >= ?";
                                        }
                                        if (endDate != null && !endDate.isEmpty()) {
                                            countSql += " AND date_submitted <= ?";
                                        }
                                        
                                        PreparedStatement countStmt = countConn.prepareStatement(countSql);
                                        paramIndex = 1;
                                        if (startDate != null && !startDate.isEmpty()) {
                                            countStmt.setString(paramIndex++, startDate + " 00:00:00");
                                        }
                                        if (endDate != null && !endDate.isEmpty()) {
                                            countStmt.setString(paramIndex++, endDate + " 23:59:59");
                                        }
                                        
                                        ResultSet countRs = countStmt.executeQuery();
                                        if (countRs.next()) {
                                            pendingCount = countRs.getInt("pending");
                                            rejectedCount = countRs.getInt("rejected");
                                        }
                                        countRs.close();
                                        countStmt.close();
                                    } catch(Exception e) {
                                        e.printStackTrace();
                                    } finally {
                                        if (countConn != null) try { countConn.close(); } catch(Exception e) {}
                                    }
                                }
                                
                            } catch(Exception e) {
                                e.printStackTrace();
                            } finally {
                                if (revenueRs != null) try { revenueRs.close(); } catch (Exception e) {}
                                if (revenueStmt != null) try { revenueStmt.close(); } catch (Exception e) {}
                                if (revenueConn != null) try { revenueConn.close(); } catch (Exception e) {}
                            }
                            
                            // Calculate percentages
                            double soldPercentage = totalItems > 0 ? (soldCount * 100.0 / totalItems) : 0;
                            double availablePercentage = totalItems > 0 ? (availableCount * 100.0 / totalItems) : 0;
                            double conversionRate = (soldCount + availableCount) > 0 ? (soldCount * 100.0 / (soldCount + availableCount)) : 0;
                        %>
                        <tr>
                            <td width="50%">
                                <span class="print-revenue-label">Actual Revenue (Sold Items)</span><br>
                                <b>RM <%= String.format("%.2f", totalRevenue) %></b>
                            </td>
                            <td width="50%">
                                <span class="print-revenue-label">Potential Revenue (Available)</span><br>
                                <b>RM <%= String.format("%.2f", potentialRevenue) %></b>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="print-revenue-label">Total Market Value</span><br>
                                <b>RM <%= String.format("%.2f", totalMarketValue) %></b>
                            </td>
                            <td>
                                <span class="print-revenue-label">Conversion Rate</span><br>
                                <b><%= String.format("%.1f", conversionRate) %>%</b>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="print-revenue-label">Avg Sold Price</span><br>
                                <b>RM <%= String.format("%.2f", avgSoldPrice) %></b>
                            </td>
                            <td>
                                <span class="print-revenue-label">Avg Available Price</span><br>
                                <b>RM <%= String.format("%.2f", avgAvailablePrice) %></b>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="report-header">
                <h3>Results: <%= filterStatus %> Items (<%= displayStart %> to <%= displayEnd %>)</h3>
                <button onclick="window.print()" class="btn-print"><i class="fas fa-print"></i> Print Report</button>
            </div>

            <%-- REVENUE SUMMARY (SCREEN ONLY) --%>
            <div class="revenue-summary">
                <h4><i class="fas fa-chart-line"></i> Revenue Analysis</h4>
                <div class="revenue-grid">
                    <div class="revenue-item">
                        <div class="revenue-label">Actual Revenue</div>
                        <div class="revenue-value">RM <%= String.format("%.2f", totalRevenue) %></div>
                    </div>
                    <div class="revenue-item">
                        <div class="revenue-label">Potential Revenue</div>
                        <div class="revenue-value">RM <%= String.format("%.2f", potentialRevenue) %></div>
                    </div>
                    <div class="revenue-item">
                        <div class="revenue-label">Total Market Value</div>
                        <div class="revenue-value">RM <%= String.format("%.2f", totalMarketValue) %></div>
                    </div>
                    <div class="revenue-item">
                        <div class="revenue-label">Conversion Rate</div>
                        <div class="revenue-value"><%= String.format("%.1f", conversionRate) %>%</div>
                    </div>
                    <div class="revenue-item">
                        <div class="revenue-label">Avg Sold Price</div>
                        <div class="revenue-value">RM <%= String.format("%.2f", avgSoldPrice) %></div>
                    </div>
                    <div class="revenue-item">
                        <div class="revenue-label">Avg Available Price</div>
                        <div class="revenue-value">RM <%= String.format("%.2f", avgAvailablePrice) %></div>
                    </div>
                </div>
            </div>

            <div class="summary-stats">
                <div class="stat-card">
                    <div class="stat-number"><%= totalItems %></div>
                    <div class="stat-label">Total Items</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= pendingCount %></div>
                    <div class="stat-label">Pending</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= availableCount %></div>
                    <div class="stat-label">Available</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= soldCount %></div>
                    <div class="stat-label">Sold</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number"><%= rejectedCount %></div>
                    <div class="stat-label">Rejected</div>
                </div>
                <div class="stat-card">
                    <div class="stat-number">RM <%= String.format("%.2f", totalRevenue) %></div>
                    <div class="stat-label">Total Revenue</div>
                </div>
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
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                        
                        // BASE QUERY
                        StringBuilder sql = new StringBuilder();
                        sql.append("SELECT i.item_id, i.item_name, i.status, i.date_submitted, i.price, u.full_name ");
                        sql.append("FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id WHERE 1=1 ");
                        
                        // 1. Filter by Status
                        if(!"ALL".equals(filterStatus)) {
                            sql.append(" AND UPPER(i.status) = ? ");
                        }

                        // 2. Filter by Start Date
                        if(startDate != null && !startDate.trim().isEmpty()) {
                            sql.append(" AND i.date_submitted >= ? ");
                        }

                        // 3. Filter by End Date
                        if(endDate != null && !endDate.trim().isEmpty()) {
                            sql.append(" AND i.date_submitted <= ? ");
                        }

                        sql.append(" ORDER BY i.date_submitted DESC");

                        pstmt = conn.prepareStatement(sql.toString());
                        
                        int paramIndex = 1;
                        
                        // Set parameters
                        if(!"ALL".equals(filterStatus)) {
                            pstmt.setString(paramIndex++, filterStatus.toUpperCase());
                        }
                        
                        if(startDate != null && !startDate.trim().isEmpty()) {
                            pstmt.setString(paramIndex++, startDate + " 00:00:00");
                        }
                        
                        if(endDate != null && !endDate.trim().isEmpty()) {
                            pstmt.setString(paramIndex++, endDate + " 23:59:59");
                        }
                        
                        rs = pstmt.executeQuery();
                        boolean hasData = false;
                        
                        SimpleDateFormat sdfRow = new SimpleDateFormat("dd MMM yyyy");
                        sdfRow.setTimeZone(TimeZone.getTimeZone("Asia/Kuala_Lumpur"));

                        while(rs.next()) {
                            hasData = true;
                            // Retrieve and normalize status
                            String status = rs.getString("status");
                            if (status != null) {
                                status = status.trim().toUpperCase();
                            } else {
                                status = "PENDING";
                            }
                            
                            // Determine Badge Color
                            String badgeClass = "status-pending"; // Default
                            if(status.equals("AVAILABLE")) {
                                badgeClass = "status-available";
                            } else if(status.equals("REJECTED")) {
                                badgeClass = "status-rejected";
                            } else if(status.equals("SOLD")) {
                                badgeClass = "status-sold";
                            }
                            
                            String displayStatus = status;
                %>
                    <tr>
                        <td>#<%= rs.getInt("item_id") %></td>
                        <td><%= rs.getString("item_name") %></td>
                        <td><%= rs.getString("full_name") %></td>
                        <td><span class="status-badge <%= badgeClass %>"><%= displayStatus %></span></td>
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
                        e.printStackTrace();
                    } finally {
                        if (rs != null) try { rs.close(); } catch (Exception e) {}
                        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
                        if (conn != null) try { conn.close(); } catch (Exception e) {}
                    }
                %>
                </tbody>
            </table>
            
        </div>
    </div>
    
    <script>
        // Set default dates if not already set
        window.onload = function() {
            const today = new Date().toISOString().split('T')[0];
            const oneMonthAgo = new Date();
            oneMonthAgo.setMonth(oneMonthAgo.getMonth() - 1);
            const oneMonthAgoStr = oneMonthAgo.toISOString().split('T')[0];
            
            // Set default values in form inputs
            const startDateInput = document.querySelector('input[name="startDate"]');
            const endDateInput = document.querySelector('input[name="endDate"]');
            
            if (startDateInput && !startDateInput.value) {
                startDateInput.value = oneMonthAgoStr;
            }
            if (endDateInput && !endDateInput.value) {
                endDateInput.value = today;
            }
            
            // Make sure end date is not before start date
            startDateInput.addEventListener('change', function() {
                if (this.value > endDateInput.value) {
                    endDateInput.value = this.value;
                }
            });
            
            endDateInput.addEventListener('change', function() {
                if (this.value < startDateInput.value) {
                    startDateInput.value = this.value;
                }
            });
        };
    </script>
</body>
</html>