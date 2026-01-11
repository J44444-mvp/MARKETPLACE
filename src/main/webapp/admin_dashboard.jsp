<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        /* --- STYLES --- */
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; margin: 0; }

        /* Sidebar */
        .sidebar { width: 260px; background-color: #800000; color: white; display: flex; flex-direction: column; padding: 20px; position: fixed; height: 100%; }
        .sidebar-header { font-size: 22px; font-weight: bold; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 20px; }
        .sidebar a { text-decoration: none; color: rgba(255, 255, 255, 0.8); padding: 15px; margin-bottom: 10px; display: block; border-radius: 8px; transition: 0.3s; }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.1); color: white; transform: translateX(5px); }
        .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }

        /* Main Content */
        .main-content { margin-left: 260px; flex: 1; padding: 30px; }
        .header-box { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .welcome-text { font-size: 24px; font-weight: bold; color: #333; }
        
        /* Malaysia Clock Badge */
        .date-badge { 
            background: #fff; padding: 8px 15px; border-radius: 20px; 
            font-size: 14px; color: #800000; font-weight: 600;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 8px;
        }

        /* Cards */
        .cards-container { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
        .card { background: white; padding: 20px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 15px rgba(0,0,0,0.05); transition: 0.3s; }
        .card:hover { transform: translateY(-5px); }
        .card-info h3 { margin: 0; font-size: 32px; color: #333; }
        .card-info p { margin: 5px 0 0; color: #777; font-size: 14px; }
        .card-icon { width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        .icon-blue { background: #e3f2fd; color: #1976d2; }
        .icon-green { background: #e8f5e9; color: #2e7d32; }
        .icon-orange { background: #fff3e0; color: #ef6c00; }
        .icon-red { background: #ffebee; color: #c62828; }

        /* Charts Section */
        .charts-container { display: grid; grid-template-columns: 2fr 1fr; gap: 20px; margin-bottom: 30px; }
        .chart-card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .chart-title { font-size: 18px; font-weight: bold; color: #333; margin-bottom: 20px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
        .canvas-container { position: relative; height: 300px; width: 100%; }

        /* Table Section */
        .table-section { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .section-title { font-size: 18px; font-weight: bold; color: #800000; }
        
        .btn-view-all { 
            text-decoration: none; background-color: #800000; color: white; 
            padding: 8px 15px; border-radius: 6px; font-size: 14px; transition: 0.3s;
        }
        .btn-view-all:hover { background-color: #600000; }

        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th { text-align: left; padding: 12px 15px; background-color: #f8f9fa; color: #555; border-bottom: 2px solid #ddd; font-size: 14px; }
        td { padding: 12px 15px; border-bottom: 1px solid #eee; color: #555; font-size: 14px; }
        .status-badge { padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: bold; text-transform: uppercase; }
        .status-pending { background-color: #fff3e0; color: #ef6c00; border: 1px solid #ffe0b2; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manage_items.jsp"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="admin_report.jsp"><i class="fas fa-chart-bar"></i> Reports</a>
        <a href="LogoutServlet" style="margin-top: auto;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <%
        // 1. Setup Clock
        SimpleDateFormat sdf = new SimpleDateFormat("EEE, d MMM yyyy h:mm a");
        sdf.setTimeZone(TimeZone.getTimeZone("Asia/Kuala_Lumpur"));
        String malaysiaTime = sdf.format(new java.util.Date());

        // 2. Initialize Variables
        int studentCount = 0;
        int totalItems = 0;
        int pendingCount = 0;
        int soldCount = 0;

        // Chart 1: Top Traders (Sellers & Buyers)
        StringBuilder traderLabels = new StringBuilder();
        StringBuilder traderSales = new StringBuilder();
        StringBuilder traderBuys = new StringBuilder();

        // Chart 2: Categories
        StringBuilder catLabels = new StringBuilder();
        StringBuilder catData = new StringBuilder();

        Connection conn = null;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            Statement stmt = conn.createStatement();

            // --- A. CARD STATS ---
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM USERS WHERE USERNAME NOT LIKE 'admin%'");
            if(rs.next()) studentCount = rs.getInt(1);
            
            rs = stmt.executeQuery("SELECT STATUS, COUNT(*) FROM ITEMS GROUP BY STATUS");
            while(rs.next()){
                String s = rs.getString(1).toLowerCase();
                int c = rs.getInt(2);
                totalItems += c;
                if(s.contains("pending")) pendingCount = c;
                else if(s.contains("sold")) soldCount = c;
            }

            // --- B. CHART 1: TOP TRADERS (Best Seller & Best Buyer) ---
            // Finds users with the most sales (Sold items) and purchases (Buyer ID)
            String sqlTraders = "SELECT u.USERNAME, " +
                              "(SELECT COUNT(*) FROM ITEMS i WHERE i.SELLER_ID = u.USER_ID AND i.STATUS = 'sold') as sales, " +
                              "(SELECT COUNT(*) FROM ITEMS i WHERE i.BUYER_ID = u.USER_ID) as purchases " +
                              "FROM USERS u ORDER BY sales DESC FETCH FIRST 5 ROWS ONLY";
            
            rs = stmt.executeQuery(sqlTraders);
            boolean firstT = true;
            while(rs.next()){
                if(!firstT){ traderLabels.append(","); traderSales.append(","); traderBuys.append(","); }
                traderLabels.append("'").append(rs.getString("USERNAME")).append("'");
                traderSales.append(rs.getInt("sales"));
                traderBuys.append(rs.getInt("purchases"));
                firstT = false;
            }

            // --- C. CHART 2: BEST CATEGORIES ---
            // Counts which category has the most sold items
            // NOTE: Ensure your ITEMS table has a 'CATEGORY' column. If not, change 'CATEGORY' to 'ITEM_NAME' or similar.
            String sqlCat = "SELECT CATEGORY, COUNT(*) as vol FROM ITEMS WHERE STATUS = 'sold' GROUP BY CATEGORY ORDER BY vol DESC FETCH FIRST 5 ROWS ONLY";
            
            try {
                rs = stmt.executeQuery(sqlCat);
                boolean firstC = true;
                while(rs.next()){
                    if(!firstC){ catLabels.append(","); catData.append(","); }
                    catLabels.append("'").append(rs.getString(1)).append("'");
                    catData.append(rs.getInt(2));
                    firstC = false;
                }
            } catch (SQLException e) {
                // Fallback if Category column is missing in DB
                catLabels.append("'No Category Data'"); catData.append("0");
            }
            
            if(traderLabels.length() == 0) { traderLabels.append("'No Data'"); traderSales.append("0"); traderBuys.append("0"); }
            if(catLabels.length() == 0) { catLabels.append("'No Sales'"); catData.append("0"); }

        } catch(Exception e) { e.printStackTrace(); }
    %>

    <div class="main-content">
        <div class="header-box">
            <div class="welcome-text">Dashboard Overview</div>
            <div class="date-badge"><i class="far fa-clock"></i> <%= malaysiaTime %> (MYT)</div>
        </div>

        <div class="cards-container">
            <div class="card">
                <div class="card-info"><h3><%= studentCount %></h3><p>Total Students</p></div>
                <div class="card-icon icon-blue"><i class="fas fa-user-graduate"></i></div>
            </div>
            <div class="card">
                <div class="card-info"><h3><%= totalItems %></h3><p>Total Items</p></div>
                <div class="card-icon icon-green"><i class="fas fa-shopping-bag"></i></div>
            </div>
            <div class="card">
                <div class="card-info"><h3><%= pendingCount %></h3><p>Pending Review</p></div>
                <div class="card-icon icon-orange"><i class="fas fa-clock"></i></div>
            </div>
            <div class="card">
                <div class="card-info"><h3><%= soldCount %></h3><p>Items Sold</p></div>
                <div class="card-icon icon-red"><i class="fas fa-hand-holding-usd"></i></div>
            </div>
        </div>

        <div class="charts-container">
            <div class="chart-card">
                <div class="chart-title">Top Traders (Best Sellers vs Buyers)</div>
                <div class="canvas-container"><canvas id="traderChart"></canvas></div>
            </div>
            <div class="chart-card">
                <div class="chart-title">Best Performing Categories</div>
                <div class="canvas-container"><canvas id="categoryChart"></canvas></div>
            </div>
        </div>

        <div class="table-section">
            <div class="section-header">
                <div class="section-title">Latest Pending Items</div>
                <a href="approvals.jsp" class="btn-view-all">Process Items <i class="fas fa-arrow-right"></i></a>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Item Name</th>
                        <th>Price (RM)</th>
                        <th>Seller ID</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            if(conn.isClosed()) conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                            Statement stmt2 = conn.createStatement();
                            ResultSet rs2 = stmt2.executeQuery("SELECT * FROM ITEMS WHERE STATUS = 'pending' ORDER BY ITEM_ID DESC FETCH FIRST 5 ROWS ONLY");
                            
                            boolean hasPending = false;
                            while(rs2.next()){ hasPending = true;
                    %>
                    <tr>
                        <td><%= rs2.getString("ITEM_NAME") %></td>
                        <td><%= rs2.getDouble("PRICE") %></td>
                        <td><%= rs2.getInt("SELLER_ID") %></td>
                        <td><span class="status-badge status-pending">Pending</span></td>
                    </tr>
                    <%      } 
                            if(!hasPending) { %>
                                <tr><td colspan="4" style="text-align:center; padding: 20px;">No new items found.</td></tr>
                    <%      }
                        } catch(Exception e){ e.printStackTrace(); } 
                        finally { if(conn!=null) conn.close(); }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // 1. TOP TRADERS CHART (Bar Chart: Sales vs Purchases)
        new Chart(document.getElementById('traderChart'), {
            type: 'bar',
            data: {
                labels: [<%= traderLabels %>],
                datasets: [
                    { 
                        label: 'Sales (Best Seller)', 
                        data: [<%= traderSales %>], 
                        backgroundColor: '#800000', // Maroon for Sales
                        borderRadius: 4
                    },
                    { 
                        label: 'Purchases (Best Buyer)', 
                        data: [<%= traderBuys %>], 
                        backgroundColor: '#1976D2', // Blue for Buys
                        borderRadius: 4
                    }
                ]
            },
            options: { 
                responsive: true, 
                maintainAspectRatio: false,
                scales: { 
                    y: { beginAtZero: true, ticks: { stepSize: 1 } } 
                },
                plugins: {
                    tooltip: {
                        mode: 'index',
                        intersect: false
                    }
                }
            }
        });

        // 2. CATEGORY CHART (Vertical Bar Chart for clarity)
        new Chart(document.getElementById('categoryChart'), {
            type: 'bar',
            data: {
                labels: [<%= catLabels %>],
                datasets: [{ 
                    label: 'Items Sold',
                    data: [<%= catData %>], 
                    backgroundColor: [
                        '#D32F2F', '#F57C00', '#FBC02D', '#388E3C', '#1976D2'
                    ],
                    borderRadius: 5
                }]
            },
            options: { 
                responsive: true, 
                maintainAspectRatio: false,
                indexAxis: 'y', // 'y' makes it a Horizontal Bar Chart (Easier to read categories)
                scales: { x: { beginAtZero: true } },
                plugins: { legend: { display: false } }
            }
        });
    </script>
</body>
</html>