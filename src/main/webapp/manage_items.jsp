<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Items | Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- THEME COLORS --- */
        :root {
            --primary-color: #800000;   /* Deep Maroon */
            --bg-color: #f4f6f9;        /* Light Grey Background */
            --text-color: #333;
            --white: #ffffff;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        
        body { display: flex; min-height: 100vh; background-color: var(--bg-color); color: var(--text-color); }

        /* --- SIDEBAR --- */
        .sidebar { 
            width: 260px; 
            background-color: var(--primary-color); 
            color: white; 
            display: flex; 
            flex-direction: column; 
            padding: 20px; 
            position: fixed; 
            height: 100%; 
        }
        
        .sidebar-header { font-size: 20px; font-weight: 700; margin-bottom: 40px; display: flex; align-items: center; gap: 10px; padding-bottom: 20px; border-bottom: 1px solid rgba(255,255,255,0.1); }
        
        .sidebar a { 
            text-decoration: none; 
            color: rgba(255, 255, 255, 0.8); 
            padding: 12px 15px; 
            margin-bottom: 8px; 
            display: flex; align-items: center; gap: 15px;
            border-radius: 6px; 
            transition: 0.3s; 
            font-size: 14px;
        }
        
        .sidebar a:hover, .sidebar a.active { background-color: rgba(255, 255, 255, 0.2); color: white; font-weight: 500; }
        .sidebar a.logout { margin-top: auto; color: #ffcccc; }
        .sidebar a.logout:hover { background-color: rgba(255, 0, 0, 0.3); color: white; }

        /* --- MAIN CONTENT AREA --- */
        .main-content { margin-left: 260px; flex: 1; padding: 30px 40px; }

        /* --- HEADER SECTION --- */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-color);
        }

        /* Search Bar */
        .search-container {
            display: flex;
            gap: 10px;
        }

        .search-input {
            padding: 8px 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            width: 250px;
            font-size: 14px;
        }

        .btn-search {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-search:hover { background-color: #600000; }

        /* --- TABLE STYLES --- */
        .table-container {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        table { width: 100%; border-collapse: collapse; }

        thead { background-color: var(--primary-color); color: white; }
        
        th { padding: 15px; text-align: left; font-weight: 600; font-size: 14px; }
        td { padding: 12px 15px; border-bottom: 1px solid #eee; font-size: 14px; vertical-align: middle; }
        
        /* FIX 1: Only hover on BODY rows, not HEADER */
        tbody tr:hover { background-color: #f9f9f9; }

        /* FIX 2: Center the Action Column */
        th:last-child, td:last-child {
            text-align: center;
        }

        /* --- ACTION BUTTONS & FORMS --- */
        .action-form { display: flex; align-items: center; gap: 8px; }
        
        .price-input {
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 80px;
        }

        .status-select {
            padding: 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .icon-btn {
            background: none; border: none; font-size: 16px; cursor: pointer; transition: 0.2s;
        }
        
        .btn-save { color: #28a745; } 
        .btn-update-status { color: #007bff; } 
        
        .btn-delete {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            display: inline-flex; /* Helps centering */
            align-items: center; 
            gap: 5px;
        }
        .btn-delete:hover { background-color: #bd2130; }

        /* Alerts */
        .alert { padding: 10px 15px; margin-bottom: 20px; border-radius: 5px; font-size: 14px; }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }

        /* Pagination */
        .pagination { display: flex; justify-content: center; margin-top: 20px; gap: 5px; }
        .page-num {
            padding: 8px 12px;
            border: 1px solid #ddd;
            color: var(--primary-color);
            text-decoration: none;
            border-radius: 4px;
            background: white;
        }
        .page-num.active { background-color: var(--primary-color); color: white; border-color: var(--primary-color); }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-shield-alt"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="manage_items.jsp" class="active"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="admin_report.jsp"><i class="fas fa-chart-line"></i> Reports</a>
        <a href="LogoutServlet" class="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        
        <div class="page-header">
            <div class="page-title">Manage All Items</div>
            
            <form action="manage_items.jsp" method="get" class="search-container">
                <input type="text" name="search" class="search-input" placeholder="Search item name..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit" class="btn-search"><i class="fas fa-search"></i></button>
            </form>
        </div>

        <% 
            String msg = request.getParameter("msg");
            if("success".equals(msg)) {
        %>
            <div class="alert alert-success">Operation successful! Item updated.</div>
        <% } %>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th style="width: 50px;">ID</th>
                        <th>Item Name</th>
                        <th>Price (RM)</th>
                        <th>Update Status</th>
                        <th>Action</th> </tr>
                </thead>
                <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    // Pagination & Search Logic
                    int currentPage = 1;
                    if(request.getParameter("page") != null) currentPage = Integer.parseInt(request.getParameter("page"));
                    int recordsPerPage = 10;
                    int start = (currentPage - 1) * recordsPerPage;
                    
                    String search = request.getParameter("search");
                    String queryCount = "SELECT COUNT(*) FROM ITEMS";
                    String queryData = "SELECT * FROM ITEMS";
                    
                    if(search != null && !search.isEmpty()) {
                        queryCount += " WHERE LOWER(item_name) LIKE ?";
                        queryData += " WHERE LOWER(item_name) LIKE ?";
                    }
                    
                    queryData += " ORDER BY item_id DESC OFFSET " + start + " ROWS FETCH NEXT " + recordsPerPage + " ROWS ONLY";

                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                        
                        // Count Total
                        PreparedStatement stmtCount = conn.prepareStatement(queryCount);
                        if(search != null && !search.isEmpty()) stmtCount.setString(1, "%" + search.toLowerCase() + "%");
                        ResultSet rsCount = stmtCount.executeQuery();
                        int totalRecords = 0;
                        if(rsCount.next()) totalRecords = rsCount.getInt(1);
                        int totalPages = (int) Math.ceil((double)totalRecords / recordsPerPage);

                        // Fetch Data
                        pstmt = conn.prepareStatement(queryData);
                        if(search != null && !search.isEmpty()) pstmt.setString(1, "%" + search.toLowerCase() + "%");
                        rs = pstmt.executeQuery();

                        while(rs.next()) {
                            int id = rs.getInt("item_id");
                %>
                    <tr>
                        <td>#<%= id %></td>
                        <td><%= rs.getString("item_name") %></td>
                        
                        <td>
                            <form action="UpdateItemServlet" method="post" class="action-form" onsubmit="return confirm('Are you sure you want to update the price?');">
                                <input type="hidden" name="id" value="<%= id %>">
                                <b>RM</b>
                                <input type="number" step="0.01" name="price" class="price-input" value="<%= rs.getDouble("price") %>">
                                <button type="submit" name="action" value="update" class="icon-btn btn-save" title="Save Price">
                                    <i class="fas fa-save"></i>
                                </button>
                            </form>
                        </td>

                        <td>
                            <form action="UpdateItemServlet" method="post" class="action-form" onsubmit="return confirm('Are you sure you want to change the status?');">
                                <input type="hidden" name="id" value="<%= id %>">
                                <select name="status" class="status-select">
                                    <option value="Pending" <%= "Pending".equals(rs.getString("status")) ? "selected" : "" %>>Pending</option>
                                    <option value="Available" <%= "Available".equals(rs.getString("status")) ? "selected" : "" %>>Available</option>
                                    <option value="Sold" <%= "Sold".equals(rs.getString("status")) ? "selected" : "" %>>Sold</option>
                                </select>
                                <button type="submit" name="action" value="update" class="icon-btn btn-update-status" title="Update Status">
                                    <i class="fas fa-check-circle"></i>
                                </button>
                            </form>
                        </td>

                        <td> <form action="UpdateItemServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this item?');">
                                <input type="hidden" name="id" value="<%= id %>">
                                <button type="submit" name="action" value="delete" class="btn-delete">
                                    <i class="fas fa-trash"></i> Delete
                                </button>
                            </form>
                        </td>
                    </tr>
                <%
                        }
                    } catch(Exception e) {
                        e.printStackTrace();
                    } finally {
                        if(conn != null) conn.close();
                    }
                %>
                </tbody>
            </table>
        </div>
        
        <% 
            // Pagination logic place here if needed
        %>
        </div>

</body>
</html>