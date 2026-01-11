<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- GENERAL STYLES --- */
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; margin: 0; }

        /* --- SIDEBAR --- */
        .sidebar { width: 260px; background-color: #800000; color: white; display: flex; flex-direction: column; padding: 20px; position: fixed; height: 100%; z-index: 1000;}
        .sidebar-header { font-size: 22px; font-weight: bold; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 20px; }
        .sidebar a { text-decoration: none; color: rgba(255, 255, 255, 0.8); padding: 15px; margin-bottom: 10px; display: block; border-radius: 8px; transition: 0.3s; }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.1); color: white; transform: translateX(5px); }
        .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }

        /* --- MAIN CONTENT --- */
        .main-content { margin-left: 260px; flex: 1; padding: 40px; position: relative; }
        
        /* HEADER */
        .header-box { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .date-badge { background: white; padding: 8px 15px; border-radius: 20px; font-size: 14px; color: #555; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }

        /* STATS CARDS GRID */
        .stats-grid { 
            display: grid; 
            grid-template-columns: repeat(4, 1fr); 
            gap: 20px; 
            margin-bottom: 40px; 
        }

        /* CARD STYLING */
        .stat-card-container { position: relative; } 
        
        .stat-card { 
            background: white; 
            padding: 25px; 
            border-radius: 12px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); 
            transition: transform 0.2s;
            cursor: pointer;
            height: 120px;
        }
        
        /* HOVER INTERACTION */
        .stat-card-container:hover .stat-card { transform: translateY(-5px); z-index: 10; position: relative; }
        .stat-card-container:hover .hover-list { display: block; opacity: 1; transform: translateY(0); }

        /* DROPDOWN LIST */
        .hover-list {
            display: none;
            position: absolute;
            top: 110px; 
            left: 0;
            width: 100%;
            background: white;
            border-radius: 0 0 12px 12px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            padding: 10px;
            z-index: 99;
            opacity: 0;
            transform: translateY(-10px);
            transition: opacity 0.3s ease, transform 0.3s ease;
            max-height: 200px; 
            overflow-y: auto;
            border-top: 1px solid #eee;
        }

        .hover-list ul { list-style: none; padding: 0; margin: 0; }
        .hover-list li { padding: 8px; border-bottom: 1px solid #f4f4f4; font-size: 13px; color: #555; display: flex; justify-content: space-between;}
        .hover-list li:last-child { border-bottom: none; }
        .hover-list li span { font-weight: bold; color: #333; }
        .empty-msg { font-size: 12px; color: #999; text-align: center; padding: 10px; font-style: italic; }

        /* ICONS & TEXT */
        .stat-info h2 { margin: 0; font-size: 32px; color: #333; }
        .stat-info p { margin: 5px 0 0; color: #777; font-size: 14px; }
        .icon-circle { width: 50px; height: 50px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; }
        
        /* COLORS */
        .blue-bg { background-color: #e3f2fd; color: #1976d2; }    
        .green-bg { background-color: #e8f5e9; color: #388e3c; }   
        .orange-bg { background-color: #fff3e0; color: #f57c00; }  
        .red-bg { background-color: #ffebee; color: #d32f2f; }     

        /* TABLE SECTION */
        .section-title { font-size: 18px; font-weight: bold; margin-bottom: 15px; border-left: 4px solid #800000; padding-left: 10px; color: #333; }
        .table-container { background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #800000; color: white; padding: 15px; text-align: left; font-size: 14px; }
        td { padding: 15px; border-bottom: 1px solid #eee; color: #555; }
        
        .badge { padding: 5px 10px; border-radius: 15px; font-size: 12px; font-weight: bold; }
        .badge-pending { background-color: #fff3e0; color: #f57c00; }
        .btn-approve { background-color: #00b894; color: white; border: none; padding: 6px 15px; border-radius: 5px; cursor: pointer; font-size: 12px; }
    </style>
</head>
<body>

    <%
        int studentCount = 0;
        int itemCount = 0;
        int pendingCount = 0;
        int rejectedCount = 0;

        StringBuilder studentList = new StringBuilder();
        StringBuilder itemList = new StringBuilder();
        StringBuilder pendingList = new StringBuilder();
        StringBuilder rejectedList = new StringBuilder();

        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            stmt = conn.createStatement();

            // 1. STUDENTS
            rs = stmt.executeQuery("SELECT USERNAME FROM USERS FETCH FIRST 5 ROWS ONLY");
            while(rs.next()){ studentList.append("<li>").append(rs.getString("USERNAME")).append("</li>"); }
            rs = stmt.executeQuery("SELECT COUNT(*) FROM USERS"); if(rs.next()) studentCount = rs.getInt(1);


            // 2. ITEMS (FIXED CURRENCY HERE)
            rs = stmt.executeQuery("SELECT ITEM_NAME, PRICE FROM ITEMS FETCH FIRST 5 ROWS ONLY");
            while(rs.next()){ 
                // Changed $ to RM below
                itemList.append("<li><span>").append(rs.getString("ITEM_NAME")).append("</span> RM ").append(rs.getDouble("PRICE")).append("</li>"); 
            }
            rs = stmt.executeQuery("SELECT COUNT(*) FROM ITEMS"); if(rs.next()) itemCount = rs.getInt(1);


            // 3. PENDING
            rs = stmt.executeQuery("SELECT ITEM_NAME FROM ITEMS WHERE STATUS = 'PENDING' FETCH FIRST 5 ROWS ONLY");
            while(rs.next()){ pendingList.append("<li>").append(rs.getString("ITEM_NAME")).append("</li>"); }
            rs = stmt.executeQuery("SELECT COUNT(*) FROM ITEMS WHERE STATUS = 'PENDING'"); if(rs.next()) pendingCount = rs.getInt(1);


            // 4. REJECTED
            rs = stmt.executeQuery("SELECT ITEM_NAME FROM ITEMS WHERE STATUS = 'REJECTED' FETCH FIRST 5 ROWS ONLY");
            while(rs.next()){ rejectedList.append("<li>").append(rs.getString("ITEM_NAME")).append("</li>"); }
            rs = stmt.executeQuery("SELECT COUNT(*) FROM ITEMS WHERE STATUS = 'REJECTED'"); if(rs.next()) rejectedCount = rs.getInt(1);

        } catch(Exception e) {
            e.printStackTrace();
        }
    %>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manage_items.jsp"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="admin_report.jsp"><i class="fas fa-chart-bar"></i> Reports</a>
        <a href="LogoutServlet" style="margin-top: auto;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        
        <div class="header-box">
            <h2 style="color: #333; margin:0;">Welcome, Admin!</h2>
            <div class="date-badge">
                <i class="far fa-clock"></i> <%= new java.util.Date() %>
            </div>
        </div>

        <div class="stats-grid">
            
            <div class="stat-card-container">
                <div class="stat-card">
                    <div class="stat-info">
                        <h2><%= studentCount %></h2>
                        <p>Students</p>
                    </div>
                    <div class="icon-circle blue-bg"><i class="fas fa-user-graduate"></i></div>
                </div>
                <div class="hover-list">
                    <strong>Recent Students:</strong>
                    <ul><%= studentList.length() > 0 ? studentList.toString() : "<div class='empty-msg'>No students found.</div>" %></ul>
                </div>
            </div>

            <div class="stat-card-container">
                <div class="stat-card">
                    <div class="stat-info">
                        <h2><%= itemCount %></h2>
                        <p>Total Items</p>
                    </div>
                    <div class="icon-circle green-bg"><i class="fas fa-shopping-bag"></i></div>
                </div>
                <div class="hover-list">
                    <strong>Recent Listings:</strong>
                    <ul><%= itemList.length() > 0 ? itemList.toString() : "<div class='empty-msg'>No items found.</div>" %></ul>
                </div>
            </div>

            <div class="stat-card-container">
                <div class="stat-card">
                    <div class="stat-info">
                        <h2><%= pendingCount %></h2>
                        <p>Pending</p>
                    </div>
                    <div class="icon-circle orange-bg"><i class="fas fa-clock"></i></div>
                </div>
                <div class="hover-list">
                    <strong>Waiting Approval:</strong>
                    <ul><%= pendingList.length() > 0 ? pendingList.toString() : "<div class='empty-msg'>No pending items.</div>" %></ul>
                </div>
            </div>
            
            <div class="stat-card-container">
                <div class="stat-card">
                    <div class="stat-info">
                        <h2><%= rejectedCount %></h2>
                        <p>Rejected</p>
                    </div>
                    <div class="icon-circle red-bg"><i class="fas fa-ban"></i></div>
                </div>
                <div class="hover-list">
                    <strong>Recently Rejected:</strong>
                    <ul><%= rejectedList.length() > 0 ? rejectedList.toString() : "<div class='empty-msg'>No rejected items.</div>" %></ul>
                </div>
            </div>

        </div>

        <div style="margin-top: 20px;">
            <div style="overflow: hidden; margin-bottom: 15px;">
                <span class="section-title">Items Waiting for Approval</span>
            </div>
            
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>Item Name</th>
                            <th>Seller ID</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try {
                                rs = stmt.executeQuery("SELECT * FROM ITEMS WHERE STATUS = 'PENDING' ORDER BY ITEM_ID DESC FETCH FIRST 5 ROWS ONLY");
                                boolean hasPending = false;
                                while(rs.next()) {
                                    hasPending = true;
                        %>
                        <tr>
                            <td><strong><%= rs.getString("ITEM_NAME") %></strong></td>
                            <td>User #<%= rs.getInt("USER_ID") %></td>
                            <td>RM <%= rs.getDouble("PRICE") %></td>
                            <td><span class="badge badge-pending">PENDING</span></td>
                            <td>
                                <form action="AdminItemServlet" method="POST">
                                    <input type="hidden" name="action" value="updateItem">
                                    <input type="hidden" name="itemId" value="<%= rs.getInt("ITEM_ID") %>">
                                    <input type="hidden" name="price" value="<%= rs.getDouble("PRICE") %>">
                                    <input type="hidden" name="status" value="AVAILABLE">
                                    <button class="btn-approve"><i class="fas fa-check"></i> Approve</button>
                                </form>
                            </td>
                        </tr>
                        <%
                                }
                                if(!hasPending) {
                        %>
                            <tr><td colspan="5" style="text-align: center; padding: 30px;">No pending items found.</td></tr>
                        <%
                                }
                                conn.close();
                            } catch(Exception e) { e.printStackTrace(); }
                        %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</body>
</html>