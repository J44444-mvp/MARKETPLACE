<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
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
        
        .date-badge { 
            background: #fff; padding: 8px 15px; border-radius: 20px; 
            font-size: 14px; color: #800000; font-weight: 600;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 8px;
        }

        /* Cards Container */
        .cards-container { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); 
            gap: 20px; 
            margin-bottom: 30px; 
        }
        
        .card { background: white; padding: 20px; border-radius: 12px; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 15px rgba(0,0,0,0.05); transition: 0.3s; }
        .card:hover { transform: translateY(-5px); }
        .card-info h3 { margin: 0; font-size: 32px; color: #333; }
        .card-info p { margin: 5px 0 0; color: #777; font-size: 14px; }
        .card-icon { width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        
        /* Icon Colors */
        .icon-blue { background: #e3f2fd; color: #1976d2; }     /* Students */
        .icon-green { background: #e8f5e9; color: #2e7d32; }    /* Total Items */
        .icon-orange { background: #fff3e0; color: #ef6c00; }   /* Pending */
        .icon-purple { background: #f3e5f5; color: #8e24aa; }   /* Sold */
        .icon-red { background: #ffebee; color: #c62828; }      /* Rejected */

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
        int rejectedCount = 0;

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
                else if(s.contains("rejected")) rejectedCount = c;
            }

        } catch(Exception e) { e.printStackTrace(); } 
        finally { if(conn != null) try { conn.close(); } catch(SQLException ignore) {} }
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
                <div class="card-icon icon-purple"><i class="fas fa-hand-holding-usd"></i></div>
            </div>

            <div class="card">
                <div class="card-info"><h3><%= rejectedCount %></h3><p>Rejected Items</p></div>
                <div class="card-icon icon-red"><i class="fas fa-ban"></i></div>
            </div>
        </div>
        
        </div>

</body>
</html>