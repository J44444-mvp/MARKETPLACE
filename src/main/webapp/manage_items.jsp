<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Items | Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- GENERAL STYLES --- */
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; margin: 0; }

        /* Sidebar */
        .sidebar { width: 260px; background-color: #800000; color: white; display: flex; flex-direction: column; padding: 20px; position: fixed; height: 100%; }
        .sidebar-header { font-size: 22px; font-weight: bold; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 20px; }
        .sidebar a { text-decoration: none; color: rgba(255, 255, 255, 0.8); padding: 15px; margin-bottom: 10px; display: block; border-radius: 8px; transition: 0.3s; }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.1); color: white; transform: translateX(5px); }
        .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }

        /* Main Content */
        .main-content { margin-left: 260px; flex: 1; padding: 40px; }
        
        .page-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 10px; margin-bottom: 20px; }
        h2 { color: #800000; margin: 0; }
        
        /* Search Bar */
        .search-container { display: flex; gap: 10px; }
        .search-input { padding: 8px 15px; border: 1px solid #ccc; border-radius: 5px; width: 250px; font-size: 14px; }
        .btn-search { background-color: #800000; color: white; border: none; padding: 8px 15px; border-radius: 5px; cursor: pointer; transition: 0.3s; }
        .btn-search:hover { background-color: #500000; transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }

        /* Table */
        .table-container { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #800000; color: white; padding: 15px; text-align: left; }
        td { padding: 15px; border-bottom: 1px solid #eee; color: #333; }
        tbody tr:hover { background-color: #f9f9f9; }

        /* Status Badges */
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending { background-color: #ffc107; color: #000; }
        .status-available { background-color: #28a745; color: white; }
        .status-sold { background-color: #6c757d; color: white; }
        .status-rejected { background-color: #dc3545; color: white; }

        /* Action Buttons & Forms */
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
            min-width: 120px;
        }

        .btn-save { 
            background-color: #28a745;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: 0.3s;
        }
        .btn-save:hover { background-color: #218838; }
        
        .btn-update-status { 
            background-color: #007bff;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: 0.3s;
        }
        .btn-update-status:hover { background-color: #0056b3; }
        
        .btn-delete {
            background-color: #d32f2f;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 4px;
            cursor: pointer;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .btn-delete:hover { background-color: #b71c1c; }

        /* Pagination */
        .pagination { display: flex; justify-content: center; margin-top: 20px; gap: 5px; }
        .pagination a { color: #800000; float: left; padding: 8px 16px; text-decoration: none; transition: background-color .3s; border: 1px solid #ddd; border-radius: 5px; background-color: white; }
        .pagination a.active { background-color: #800000; color: white; border: 1px solid #800000; }
        .pagination a:hover:not(.active) { background-color: #ddd; }

        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); align-items: center; justify-content: center; }
        .modal-content { background-color: #fff; padding: 30px; border-radius: 8px; width: 450px; box-shadow: 0 4px 20px rgba(0,0,0,0.2); animation: fadeIn 0.3s ease-in-out; position: relative; }
        .close-btn { position: absolute; top: 15px; right: 20px; font-size: 24px; cursor: pointer; color: #888; }
        .close-btn:hover { color: #333; }
        
        .modal-header i { font-size: 60px; color: #28a745; margin-bottom: 20px; }
        .success-text { text-align: center; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manage_items.jsp" class="active"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="admin_report.jsp"><i class="fas fa-chart-bar"></i> Reports</a>
        <a href="LogoutServlet" style="margin-top: auto;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        
        <div class="page-header">
            <h2>Manage Items</h2>
            <form action="manage_items.jsp" method="get" class="search-container">
                <input type="text" name="search" class="search-input" placeholder="Search item name..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit" class="btn-search"><i class="fas fa-search"></i></button>
            </form>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Item Name</th>
                        <th>Status</th>
                        <th>Price (RM)</th> 
                        <th>Update Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    // Pagination & Search Logic
                    int currentPage = 1;
                    int recordsPerPage = 10;
                    int totalRecords = 0;
                    int totalPages = 0; 
                    
                    if(request.getParameter("page") != null) {
                        try { currentPage = Integer.parseInt(request.getParameter("page")); } catch(NumberFormatException e) {}
                    }
                    int start = (currentPage - 1) * recordsPerPage;
                    
                    String search = request.getParameter("search");
                    String queryCount = "SELECT COUNT(*) FROM ITEMS";
                    String queryData = "SELECT * FROM ITEMS";
                    
                    if(search != null && !search.isEmpty()) {
                        queryCount += " WHERE LOWER(item_name) LIKE ?";
                        queryData += " WHERE LOWER(item_name) LIKE ?";
                    }
                    
                    queryData += " ORDER BY item_id ASC OFFSET " + start + " ROWS FETCH NEXT " + recordsPerPage + " ROWS ONLY";

                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                        
                        // Count Total
                        PreparedStatement stmtCount = conn.prepareStatement(queryCount);
                        if(search != null && !search.isEmpty()) stmtCount.setString(1, "%" + search.toLowerCase() + "%");
                        ResultSet rsCount = stmtCount.executeQuery();
                        
                        if(rsCount.next()) totalRecords = rsCount.getInt(1);
                        totalPages = (int) Math.ceil((double)totalRecords / recordsPerPage);

                        // Fetch Data
                        pstmt = conn.prepareStatement(queryData);
                        if(search != null && !search.isEmpty()) pstmt.setString(1, "%" + search.toLowerCase() + "%");
                        rs = pstmt.executeQuery();

                        while(rs.next()) {
                            int id = rs.getInt("item_id");
                            String status = rs.getString("status");
                            String statusClass = "";
                            
                            if(status != null) {
                                status = status.toUpperCase();
                                if(status.equals("PENDING")) {
                                    statusClass = "status-pending";
                                } else if(status.equals("AVAILABLE")) {
                                    statusClass = "status-available";
                                } else if(status.equals("SOLD")) {
                                    statusClass = "status-sold";
                                } else if(status.equals("REJECTED")) {
                                    statusClass = "status-rejected";
                                }
                            }
                %>
                    <tr>
                        <td>#<%= id %></td>
                        <td><%= rs.getString("item_name") %></td>
                        <td>
                            <span class="status-badge <%= statusClass %>">
                                <%= status != null ? status : "UNKNOWN" %>
                            </span>
                        </td>
                        
                        <td>
                            <form action="UpdateItemServlet" method="post" class="action-form" onsubmit="return confirm('Are you sure you want to update the price?');">
                                <input type="hidden" name="id" value="<%= id %>">
                                <b>RM</b>
                                <input type="number" step="0.01" name="price" class="price-input" value="<%= rs.getDouble("price") %>">
                                <button type="submit" name="action" value="update_price" class="btn-save" title="Save Price">
                                    <i class="fas fa-save"></i> Save
                                </button>
                            </form>
                        </td>

                        <td>
                            <form action="UpdateItemServlet" method="post" class="action-form" onsubmit="return confirm('Are you sure you want to change the status?');">
                                <input type="hidden" name="id" value="<%= id %>">
                                <select name="status" class="status-select">
                                    <option value="NOT AVAILABLE" <%= "NOT AVAILABLE".equals(status) ? "selected" : "" %>>Not Available</option>
                                    <option value="AVAILABLE" <%= "AVAILABLE".equals(status) ? "selected" : "" %>>Available</option>
                                    <!--<option value="SOLD" <%= "SOLD".equals(status) ? "selected" : "" %>>Sold</option>-->
                                    <!--<option value="REJECTED" <%= "REJECTED".equals(status) ? "selected" : "" %>>Rejected</option>-->
                                </select>
                                <button type="submit" name="action" value="update_status" class="btn-update-status" title="Update Status">
                                    <i class="fas fa-check-circle"></i> Update
                                </button>
                            </form>
                        </td>

                        <td> 
                            <form action="UpdateItemServlet" method="post" onsubmit="return confirm('Are you sure you want to delete this item?');">
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
            if(totalPages > 1) { 
                String searchParam = (search != null && !search.isEmpty()) ? "&search=" + search : "";
        %>
        <div class="pagination">
            
            <% if(currentPage > 1) { %>
                <a href="manage_items.jsp?page=<%= currentPage - 1 %><%= searchParam %>">&laquo; Previous</a>
            <% } %>

            <% for(int i = 1; i <= totalPages; i++) { %>
                <a href="manage_items.jsp?page=<%= i %><%= searchParam %>" class="<%= (i == currentPage) ? "active" : "" %>">
                    <%= i %>
                </a>
            <% } %>

            <% if(currentPage < totalPages) { %>
                <a href="manage_items.jsp?page=<%= currentPage + 1 %><%= searchParam %>">Next &raquo;</a>
            <% } %>
            
        </div>
        <% } %>
        
    </div>

    <div id="successModal" class="modal">
        <div class="modal-content success-text" style="width: 400px;">
            <div class="modal-header"><i class="fas fa-check-circle"></i></div>
            <h3>Success!</h3>
            <p id="successMessage">Action completed successfully!</p>
            <button class="btn-search" onclick="closeSuccessModal()" style="margin-top: 20px;">OK</button>
        </div>
    </div>

    <script>
        // Check URL parameters on Page Load
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const msg = urlParams.get('msg');

            // If msg=success exists, show the modal
            if (msg === 'success') {
                document.getElementById('successModal').style.display = 'flex';
            }
        };

        function closeSuccessModal() { 
            document.getElementById('successModal').style.display = 'none';
            // Clean the URL parameter when closing
            const url = new URL(window.location.href);
            url.searchParams.delete('msg');
            window.history.replaceState({}, document.title, url);
        }
    </script>

</body>
</html>