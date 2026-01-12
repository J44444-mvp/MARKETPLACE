<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // --- DATABASE UPDATE LOGIC ---
    String actionReq = request.getParameter("actionReq");
    String itemIDReq = request.getParameter("itemIDReq");

    if (actionReq != null && itemIDReq != null) {
        Connection connUpdate = null;
        PreparedStatement pstmtUpdate = null;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            connUpdate = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // Set status based on button clicked
            String newStatus = "";
            if ("approve".equals(actionReq)) {
                newStatus = "AVAILABLE";
            } else if ("reject".equals(actionReq)) {
                newStatus = "REJECTED";
            }
            
            System.out.println("DEBUG: Updating item_id=" + itemIDReq + " to status=" + newStatus);
            
            String updateSql = "UPDATE ITEMS SET status = ? WHERE item_id = ?";
            pstmtUpdate = connUpdate.prepareStatement(updateSql);
            pstmtUpdate.setString(1, newStatus);
            pstmtUpdate.setInt(2, Integer.parseInt(itemIDReq));
            
            int rows = pstmtUpdate.executeUpdate();
            System.out.println("DEBUG: Rows updated = " + rows);
            
            if(rows > 0) {
                response.sendRedirect("approvals.jsp?success=true&action=" + actionReq);
                return; 
            } else {
                response.sendRedirect("approvals.jsp?error=true&message=Item not found");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("approvals.jsp?error=true&message=" + e.getMessage());
            return;
        } finally {
            if (pstmtUpdate != null) try { pstmtUpdate.close(); } catch(Exception e){}
            if (connUpdate != null) try { connUpdate.close(); } catch(Exception e){}
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Pending Approvals | Admin</title>
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

        /* ID and Price Styling */
        .id-text { font-weight: bold; color: #333; }
        .price-text { color: #28a745; font-weight: bold; font-size: 14px; }

        /* Action Buttons */
        .btn-view { 
            background-color: #6c757d; 
            color: white; 
            border: none; 
            padding: 6px 12px; 
            border-radius: 4px; 
            cursor: pointer; 
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
        }
        .btn-view:hover { background-color: #5a6268; }
        
        /* Expandable Details Section */
        .details-row { display: none; }
        .details-wrapper {
            background: #fff;
            padding: 25px;
            margin: 10px 0 20px 0;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            display: flex;
            gap: 30px;
            border: 1px solid #eee;
        }

        /* Image Gallery Styles */
        .image-gallery-section {
            width: 350px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .main-image-container {
            width: 100%;
            height: 250px;
            background: #f5f5f5;
            border-radius: 8px;
            overflow: hidden;
            position: relative;
            border: 1px solid #ddd;
        }
        
        .main-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            cursor: pointer;
        }
        
        .image-counter {
            position: absolute;
            bottom: 10px;
            right: 10px;
            background: rgba(0,0,0,0.7);
            color: white;
            padding: 3px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
        
        .thumbnail-container {
            display: flex;
            gap: 10px;
            justify-content: center;
        }
        
        .thumbnail {
            width: 60px;
            height: 60px;
            border-radius: 5px;
            overflow: hidden;
            cursor: pointer;
            border: 2px solid transparent;
            opacity: 0.7;
            transition: all 0.2s;
        }
        
        .thumbnail.active {
            border-color: #800000;
            opacity: 1;
            transform: scale(1.05);
        }
        
        .thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .empty-thumbnail {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background: #eee;
            color: #999;
            font-size: 10px;
            text-align: center;
            line-height: 1.2;
        }
        
        .no-images-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #666;
            gap: 10px;
        }

        .detail-info { 
            flex: 1; 
            display: flex; 
            flex-direction: column; 
        }
        .detail-title { 
            font-size: 24px; 
            color: #800000; 
            font-weight: 700; 
            margin-bottom: 10px; 
        }
        
        .info-grid { 
            display: grid; 
            grid-template-columns: 1fr 1fr; 
            gap: 15px; 
            margin-bottom: 20px; 
            color: #555; 
            font-size: 14px; 
        }
        .desc-box { 
            background: #f9f9f9; 
            padding: 15px; 
            border-radius: 6px; 
            color: #666; 
            font-size: 14px; 
            margin-bottom: 25px; 
            border-left: 3px solid #ccc; 
        }

        /* Approve/Reject Buttons */
        .btn-action { 
            padding: 10px 25px; 
            border: none; 
            border-radius: 5px; 
            color: white; 
            cursor: pointer; 
            font-weight: 600; 
            font-size: 14px; 
            display: inline-flex; 
            align-items: center; 
            gap: 8px; 
            margin-right: 10px;
            transition: 0.3s;
        }
        .btn-approve { background-color: #28a745; }
        .btn-approve:hover { background-color: #218838; }
        
        .btn-reject { background-color: #dc3545; }
        .btn-reject:hover { background-color: #c82333; }

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

        /* Image Modal */
        .image-modal { 
            display: none; 
            position: fixed; 
            z-index: 3000; 
            left: 0; 
            top: 0; 
            width: 100%; 
            height: 100%; 
            background-color: rgba(0,0,0,0.9); 
            justify-content: center; 
            align-items: center; 
        }
        
        .image-modal-content {
            max-width: 90%;
            max-height: 90%;
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .image-modal img { 
            max-width: 100%; 
            max-height: 80vh; 
            border: 5px solid white; 
            border-radius: 5px; 
        }
        
        .image-modal-nav {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
        }
        
        .nav-btn {
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .nav-btn:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .image-counter-modal {
            color: white;
            font-size: 16px;
            margin-top: 10px;
        }
        
        .close-modal { 
            position: absolute; 
            top: 30px; 
            right: 40px; 
            color: white; 
            font-size: 40px; 
            cursor: pointer; 
        }
        
        .arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            color: white;
            font-size: 40px;
            cursor: pointer;
            background: rgba(0,0,0,0.5);
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
        }
        
        .prev { left: 30px; }
        .next { right: 30px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manage_items.jsp"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp" class="active"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="admin_report.jsp"><i class="fas fa-chart-bar"></i> Reports</a>
        <a href="LogoutServlet" style="margin-top: auto;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        
        <div class="page-header">
            <h2>Pending Approvals</h2>
            
            <form action="approvals.jsp" method="get" class="search-container">
                <input type="text" name="search" class="search-input" placeholder="Search Student or Item..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit" class="btn-search"><i class="fas fa-search"></i></button>
            </form>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Student Name</th>
                        <th>Item Title</th>
                        <th>Date Submitted</th>
                        <th>Price</th>
                        <th>Phone</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ResultSet countRs = null;
        
        String searchQuery = request.getParameter("search");
        
        int currentPage = 1;
        int recordsPerPage = 5;
        if(request.getParameter("page") != null) {
            try { currentPage = Integer.parseInt(request.getParameter("page")); } catch(NumberFormatException e) { currentPage = 1; }
        }
        
        int start = (currentPage - 1) * recordsPerPage;
        int totalRecords = 0;
        int totalPages = 0;

        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            
            // --- 1. COUNT RECORDS ---
            String countSql = "SELECT COUNT(*) FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id WHERE i.status = 'PENDING'";
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                countSql += " AND (LOWER(i.item_name) LIKE ? OR LOWER(u.full_name) LIKE ?)";
            }
            
            PreparedStatement countStmt = conn.prepareStatement(countSql);
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String searchPattern = "%" + searchQuery.toLowerCase() + "%";
                countStmt.setString(1, searchPattern);
                countStmt.setString(2, searchPattern);
            }
            
            countRs = countStmt.executeQuery();
            if(countRs.next()) totalRecords = countRs.getInt(1);
            totalPages = (int) Math.ceil((double)totalRecords / recordsPerPage);
            countStmt.close();

            // --- 2. FETCH DATA ---
            String sql = "SELECT i.item_id, i.item_name, i.description, i.price, i.date_submitted, " +
                         "i.image_url, i.image_url2, i.image_url3, i.condition, i.brand, i.negotiable, i.meetup_location, " +
                         "u.full_name, u.email, u.phone_number " + 
                         "FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id " +
                         "WHERE i.status = 'PENDING' ";
            
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                sql += " AND (LOWER(i.item_name) LIKE ? OR LOWER(u.full_name) LIKE ?) ";
            }
            
            sql += "ORDER BY i.date_submitted ASC " +
                   "OFFSET " + start + " ROWS FETCH NEXT " + recordsPerPage + " ROWS ONLY";
            
            pstmt = conn.prepareStatement(sql);
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                String searchPattern = "%" + searchQuery.toLowerCase() + "%";
                pstmt.setString(1, searchPattern);
                pstmt.setString(2, searchPattern);
            }
            
            rs = pstmt.executeQuery();
            boolean hasData = false;
            SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

            while(rs.next()) {
                hasData = true;
                int id = rs.getInt("item_id");
                String title = rs.getString("item_name");
                String desc = rs.getString("description");
                double price = rs.getDouble("price");
                String student = rs.getString("full_name");
                String email = rs.getString("email");
                String phone = rs.getString("phone_number");
                String condition = rs.getString("condition");
                String brand = rs.getString("brand");
                String negotiable = rs.getString("negotiable");
                String meetupLocation = rs.getString("meetup_location");
                
                String img1 = rs.getString("image_url");
                String img2 = rs.getString("image_url2");
                String img3 = rs.getString("image_url3");
                
                java.util.List<String> images = new java.util.ArrayList<>();
                if (img1 != null && !img1.isEmpty() && !img1.equals("null")) images.add(img1);
                if (img2 != null && !img2.isEmpty() && !img2.equals("null")) images.add(img2);
                if (img3 != null && !img3.isEmpty() && !img3.equals("null")) images.add(img3);
                
                Timestamp ts = rs.getTimestamp("date_submitted");
                String dateStr = (ts != null) ? sdf.format(ts) : "-";
                
                StringBuilder jsImgArray = new StringBuilder("[");
                for(int i=0; i<images.size(); i++) {
                    jsImgArray.append("'").append(images.get(i)).append("'");
                    if(i < images.size()-1) jsImgArray.append(",");
                }
                jsImgArray.append("]");
    %>
                <script>
                    if(typeof itemImagesMap === 'undefined') itemImagesMap = {};
                    itemImagesMap[<%= id %>] = <%= jsImgArray.toString() %>;
                </script>

                <tr>
                    <td><span class="id-text">#<%= id %></span></td>
                    <td><%= student %></td>
                    <td><%= title %></td>
                    <td style="color:#666;"><%= dateStr %></td>
                    <td class="price-text">RM <%= String.format("%.2f", price) %></td>
                    <td><%= phone != null ? phone : "N/A" %></td>
                    <td>
                        <button class="btn-view" onclick="toggleDetails('<%= id %>')">
                            <i class="fas fa-eye"></i> View
                        </button>
                    </td>
                </tr>

                <tr id="details-<%= id %>" class="details-row">
                    <td colspan="7" style="padding: 0; background: transparent; border: none;">
                        <div class="details-wrapper">
                            <div class="image-gallery-section">
                                <div class="main-image-container">
                                    <% if (!images.isEmpty()) { %>
                                    <img id="main-img-<%= id %>" src="uploads/<%= images.get(0) %>" 
                                         class="main-image" onclick="openImageModal(<%= id %>, 0)"
                                         onerror="this.src='https://via.placeholder.com/350x250/800000/ffffff?text=Image+Not+Found'">
                                    <div class="image-counter"><%= images.size() %> image(s)</div>
                                    <% } else { %>
                                    <div class="no-images-container">
                                        <i class="fas fa-image fa-3x"></i>
                                        <span>No Images Available</span>
                                    </div>
                                    <% } %>
                                </div>
                                
                                <div class="thumbnail-container">
                                    <%
                                        if (!images.isEmpty()) {
                                            for (int i = 0; i < images.size(); i++) {
                                                String img = images.get(i);
                                    %>
                                    <div class="thumbnail <%= i == 0 ? "active" : "" %>" 
                                         onclick="changeMainImage(<%= id %>, <%= i %>, '<%= img %>')">
                                        <img src="uploads/<%= img %>" onerror="this.src='https://via.placeholder.com/60/800000/ffffff?text=Img'">
                                    </div>
                                    <%
                                            }
                                        }
                                        int emptySlots = 3 - images.size();
                                        for (int i = 0; i < emptySlots; i++) {
                                    %>
                                    <div class="thumbnail empty-thumbnail">
                                        <i class="fas fa-image"></i>
                                        <span>Empty</span>
                                    </div>
                                    <% } %>
                                </div>
                            </div>

                            <div class="detail-info">
                                <h3 class="detail-title"><%= title %></h3>
                                <div class="info-grid">
                                    <div><strong>Student:</strong> <%= student %></div>
                                    <div><strong>Email:</strong> <%= email %></div>
                                    <div><strong>Phone:</strong> <%= phone != null ? phone : "N/A" %></div>
                                    <div><strong>Date:</strong> <%= dateStr %></div>
                                    <div><strong>Condition:</strong> <%= condition != null ? condition : "Not specified" %></div>
                                    <div><strong>Brand:</strong> <%= brand != null && !brand.equals("null") ? brand : "Not specified" %></div>
                                    <div><strong>Price:</strong> <span style="color:#28a745; font-weight:bold;">RM <%= String.format("%.2f", price) %></span></div>
                                    <div><strong>Negotiable:</strong> <%= "yes".equalsIgnoreCase(negotiable) ? "Yes" : "No" %></div>
                                    <div><strong>Meetup Location:</strong> <%= meetupLocation != null ? meetupLocation : "Not specified" %></div>
                                </div>
                                <div class="desc-box">
                                    <strong>Description:</strong><br><%= desc %>
                                </div>
                                <div>
                                    <button type="button" class="btn-action btn-approve" onclick="processRequest(<%= id %>, 'approve')">
                                        <i class="fas fa-check"></i> Approve
                                    </button>
                                    <button type="button" class="btn-action btn-reject" onclick="processRequest(<%= id %>, 'reject')">
                                        <i class="fas fa-times"></i> Reject
                                    </button>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>
    <% 
            } 
            if(!hasData) { 
    %>
                <tr>
                    <td colspan="7" style="text-align:center; padding:30px;">
                        <i class="fas fa-search fa-2x" style="color:#ccc; margin-bottom:15px;"></i>
                        <h4 style="color:#666;">No pending approvals found</h4>
                    </td>
                </tr>
    <% 
            }
        } catch(Exception e) {
            e.printStackTrace();
    %>
                <tr><td colspan="7" style="color:red;">Error: <%= e.getMessage() %></td></tr>
    <%
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) {}
            if (countRs != null) try { countRs.close(); } catch (SQLException e) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) {}
            if (conn != null) try { conn.close(); } catch (SQLException e) {}
        }
    %>
                </tbody>
            </table>
        </div>

        <%-- PAGINATION --%>
        <% if (totalPages > 1) { 
            String searchParam = (searchQuery != null && !searchQuery.isEmpty()) ? "&search=" + searchQuery : "";
        %>
        <div class="pagination">
            
            <% if(currentPage > 1) { %>
                <a href="approvals.jsp?page=<%= currentPage - 1 %><%= searchParam %>">&laquo; Previous</a>
            <% } %>

            <% for(int i=1; i<=totalPages; i++) { %>
                <a href="approvals.jsp?page=<%= i %><%= searchParam %>" class="<%= (i==currentPage) ? "active" : "" %>"><%= i %></a>
            <% } %>

            <% if(currentPage < totalPages) { %>
                <a href="approvals.jsp?page=<%= currentPage + 1 %><%= searchParam %>">Next &raquo;</a>
            <% } %>
            
        </div>
        <% } %>
        
    </div>

    <!-- Image Modal -->
    <div id="imageModal" class="image-modal">
        <span class="close-modal" onclick="closeImageModal()">&times;</span>
        <span class="arrow prev" onclick="changeModalSlide(-1)">&#10094;</span>
        <div class="image-modal-content">
            <img id="modalImg" src="">
            <div class="image-counter-modal" id="modalCounter">1 / 1</div>
        </div>
        <span class="arrow next" onclick="changeModalSlide(1)">&#10095;</span>
    </div>

    <!-- Success Modal -->
    <div id="successModal" class="modal">
        <div class="modal-content success-text" style="width: 400px;">
            <div class="modal-header"><i class="fas fa-check-circle"></i></div>
            <h3>Success!</h3>
            <p id="successMessage">Action completed successfully!</p>
            <button class="btn-search" onclick="closeSuccessModal()" style="margin-top: 20px;">OK</button>
        </div>
    </div>

    <script>
        // --- Store Images for Modal ---
        let currentItemId = null;
        let currentImageIndex = 0;
        
        function toggleDetails(id) {
            var rows = document.querySelectorAll('.details-row');
            var target = document.getElementById('details-' + id);
            var isOpen = target.style.display === 'table-row';
            rows.forEach(row => { row.style.display = 'none'; });
            if (!isOpen) target.style.display = 'table-row';
        }

        // Process Request Function
        function processRequest(id, action) {
            let msg = action === 'approve' ? "Are you sure you want to APPROVE this item?" : "Are you sure you want to REJECT this item?";
            if (confirm(msg)) {
                window.location.href = "approvals.jsp?itemIDReq=" + id + "&actionReq=" + action;
            }
        }

        // Check if we just updated a status to show the modal
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const success = urlParams.get('success');
            const error = urlParams.get('error');
            const action = urlParams.get('action');
            const message = urlParams.get('message');
            
            if (success === 'true' || error === 'true') {
                const modal = document.getElementById('successModal');
                const successMessage = document.getElementById('successMessage');
                
                if (success === 'true') {
                    if (action === 'approve') {
                        successMessage.textContent = 'Item approved successfully! It is now available in the marketplace.';
                    } else if (action === 'reject') {
                        successMessage.textContent = 'Item rejected successfully!';
                    } else {
                        successMessage.textContent = 'Action completed successfully!';
                    }
                } else {
                    successMessage.textContent = message || 'An error occurred!';
                }
                
                modal.style.display = 'flex';
            }
        }

        function closeSuccessModal() {
            document.getElementById('successModal').style.display = 'none';
            // Clean URL parameters
            const url = new URL(window.location.href);
            url.searchParams.delete('success');
            url.searchParams.delete('error');
            url.searchParams.delete('action');
            url.searchParams.delete('message');
            window.history.replaceState({}, document.title, url);
        }

        function changeMainImage(itemId, index, imgName) {
            const mainImg = document.getElementById('main-img-' + itemId);
            mainImg.src = 'uploads/' + imgName;
            const container = mainImg.closest('.details-wrapper');
            const thumbs = container.querySelectorAll('.thumbnail');
            thumbs.forEach(t => t.classList.remove('active'));
            thumbs[index].classList.add('active');
        }

        // Image Modal Logic
        function openImageModal(itemId, index) {
            currentItemId = itemId;
            currentImageIndex = index;
            updateModalImage();
            document.getElementById('imageModal').style.display = 'flex';
        }

        function closeImageModal() {
            document.getElementById('imageModal').style.display = 'none';
        }

        function changeModalSlide(n) {
            const imgs = itemImagesMap[currentItemId];
            if (!imgs || imgs.length === 0) return;
            
            currentImageIndex += n;
            if (currentImageIndex >= imgs.length) currentImageIndex = 0;
            if (currentImageIndex < 0) currentImageIndex = imgs.length - 1;
            updateModalImage();
        }

        function updateModalImage() {
            const imgs = itemImagesMap[currentItemId];
            if (!imgs || imgs.length === 0) return;
            
            document.getElementById('modalImg').src = 'uploads/' + imgs[currentImageIndex];
            document.getElementById('modalCounter').innerText = (currentImageIndex + 1) + ' / ' + imgs.length;
        }
    </script>
</body>
</html>