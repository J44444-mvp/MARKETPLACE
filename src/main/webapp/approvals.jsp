<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Pending Approvals | Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- GENERAL & RESET --- */
        :root {
            --primary: #800000;         /* Maroon */
            --bg-color: #f4f6f9;
            --text-dark: #2c3e50;
        }

        * { box-sizing: border-box; font-family: 'Poppins', sans-serif; margin: 0; padding: 0; }
        body { display: flex; min-height: 100vh; background-color: var(--bg-color); color: var(--text-dark); }

        /* --- SIDEBAR --- */
        .sidebar { 
            width: 260px; 
            background-color: var(--primary); 
            color: white; 
            display: flex; 
            flex-direction: column; 
            padding: 25px; 
            position: fixed; 
            height: 100%; 
            z-index: 10;
        }
        
        .sidebar-header { font-size: 22px; font-weight: 700; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        
        .sidebar a { 
            text-decoration: none; 
            color: rgba(255, 255, 255, 0.85); 
            padding: 15px; 
            margin-bottom: 10px; 
            display: flex; align-items: center; gap: 12px;
            border-radius: 8px; 
            transition: 0.3s; 
            font-size: 14px;
        }
        
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.15); transform: translateX(5px); color: white; }
        .sidebar a.active { background-color: white; color: var(--primary); font-weight: 600; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }

        /* --- MAIN CONTENT --- */
        .main-content { margin-left: 260px; flex: 1; padding: 40px; }
        
        /* --- NEW HEADER STYLES (MATCHING MANAGE USERS) --- */
        .page-header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            border-left: 5px solid var(--primary);
            padding-left: 15px;
        }
        
        h2 { color: var(--primary); font-weight: 700; margin: 0; }

        .search-form { display: flex; gap: 5px; }
        .search-input {
            padding: 8px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            outline: none;
            width: 250px;
            font-size: 14px;
        }
        .search-btn {
            background-color: var(--primary);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }
        .search-btn:hover { background-color: #600000; }

        /* --- TABLE STYLES --- */
        .requests-table { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
        
        .requests-table th { 
            color: white; 
            background-color: var(--primary);
            font-weight: 600; 
            padding: 15px 20px; 
            text-align: left; 
            font-size: 13px; 
        }
        .requests-table th:first-child { border-top-left-radius: 8px; border-bottom-left-radius: 8px; }
        .requests-table th:last-child { border-top-right-radius: 8px; border-bottom-right-radius: 8px; }
        
        .main-row { background: white; box-shadow: 0 4px 6px rgba(0,0,0,0.05); transition: all 0.2s; border-radius: 8px; }
        .main-row td { padding: 18px 20px; vertical-align: middle; background: white; border-bottom: 1px solid #eee; }
        .main-row:hover { transform: translateY(-2px); box-shadow: 0 10px 25px rgba(0,0,0,0.1); }

        .price-text { color: #2e7d32; font-weight: 700; font-size: 14px; }
        .id-text { font-weight: 700; color: #333; }

        .btn-view { 
            background: #444; color: white; border: none;
            padding: 8px 18px; border-radius: 4px; cursor: pointer; transition: 0.2s; 
            display: inline-flex; align-items: center; gap: 8px; font-size: 12px;
        }
        .btn-view:hover { background: var(--primary); }

        /* --- EXPANDED DETAILS PANEL --- */
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
            border-color: var(--primary);
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
            color: var(--primary); 
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

        /* --- APPROVE / REJECT BUTTONS --- */
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
        .approve { background-color: #28a745; } /* Green */
        .approve:hover { background-color: #218838; }
        
        .reject { background-color: #dc3545; } /* Red */
        .reject:hover { background-color: #c82333; }

        /* --- CUSTOM POPUP --- */
        .custom-popup-overlay {
            display: none; /* Hidden by default */
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index: 2000;
            justify-content: center;
            align-items: center;
        }

        .custom-popup-content {
            background: white;
            padding: 40px;
            border-radius: 10px;
            text-align: center;
            width: 400px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            animation: popIn 0.3s ease-out;
        }

        @keyframes popIn {
            from { transform: scale(0.8); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }

        .popup-icon {
            width: 70px;
            height: 70px;
            background-color: #28a745; /* Green Circle */
            color: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 35px;
            margin: 0 auto 20px auto;
        }
        
        .popup-icon.error { background-color: #dc3545; }

        .popup-title {
            font-size: 24px;
            font-weight: 700;
            color: #000;
            margin-bottom: 10px;
        }

        .popup-message {
            font-size: 16px;
            color: #444;
            margin-bottom: 25px;
        }

        .popup-btn {
            background-color: #800000; /* Maroon Button */
            color: white;
            border: none;
            padding: 12px 50px;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: 0.3s;
        }
        .popup-btn:hover { background-color: #600000; }

        /* Pagination */
        .pagination-container { display: flex; justify-content: center; margin-top: 30px; gap: 5px; }
        .page-link { display: inline-flex; justify-content: center; align-items: center; width: 35px; height: 35px; border: 1px solid #ddd; color: var(--primary); text-decoration: none; border-radius: 4px; background-color: white; }
        .page-link.active { background-color: var(--primary); color: white; border-color: var(--primary); }

        /* Image Modal */
        .modal { 
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
        
        .modal-content {
            max-width: 90%;
            max-height: 90%;
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        
        .modal img { 
            max-width: 100%; 
            max-height: 80vh; 
            border: 5px solid white; 
            border-radius: 5px; 
        }
        
        .modal-nav {
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
        
        .modal-counter {
            color: white;
            font-size: 16px;
            margin-top: 10px;
        }
        
        .close { 
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
        <div class="sidebar-header"><i class="fas fa-shield-alt"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp"><i class="fas fa-th-large"></i> Dashboard</a>
        <a href="manage_items.jsp"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp" class="active"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="admin_report.jsp"><i class="fas fa-chart-line"></i> Reports</a>
        <a href="LogoutServlet" style="margin-top:auto; color: #ffadad;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        <div class="page-header-container">
            <h2>Pending Approval Requests</h2>
            
            <form action="approvals.jsp" method="get" class="search-form">
                <input type="text" name="search" class="search-input" placeholder="Search Student or Item..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                <button type="submit" class="search-btn">
                    <i class="fas fa-search"></i>
                </button>
            </form>
        </div>

        <table class="requests-table">
            <thead>
                <tr>
                    <th>Req ID</th>
                    <th>Student Name</th>
                    <th>Item Title</th>
                    <th>Date Submitted</th>
                    <th>Price</th>
                    <th>Phone</th>
                    <th style="text-align:right">Action</th>
                </tr>
            </thead>
            <tbody>
    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ResultSet countRs = null;
        
        // Search Logic
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

            // --- 2. FETCH DATA WITH ALL IMAGES ---
            String sql = "SELECT i.item_id, i.item_name, i.description, i.price, i.date_submitted, " +
                         "i.image_url, i.image_url2, i.image_url3, i.condition, i.brand, i.negotiable, i.meetup_location, " +
                         "u.full_name, u.email, u.phone_number " + 
                         "FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id " +
                         "WHERE i.status = 'PENDING' ";
            
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                sql += " AND (LOWER(i.item_name) LIKE ? OR LOWER(u.full_name) LIKE ?) ";
            }
            
            sql += "ORDER BY i.date_submitted DESC " +
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
                
                // Get all 3 images
                String img1 = rs.getString("image_url");
                String img2 = rs.getString("image_url2");
                String img3 = rs.getString("image_url3");
                
                // Collect non-empty images
                java.util.List<String> images = new java.util.ArrayList<>();
                if (img1 != null && !img1.isEmpty() && !img1.equals("null")) {
                    images.add(img1);
                }
                if (img2 != null && !img2.isEmpty() && !img2.equals("null")) {
                    images.add(img2);
                }
                if (img3 != null && !img3.isEmpty() && !img3.equals("null")) {
                    images.add(img3);
                }
                
                Timestamp ts = rs.getTimestamp("date_submitted");
                String dateStr = (ts != null) ? sdf.format(ts) : "-";
    %>
                <tr class="main-row">
                    <td><span class="id-text">#<%= id %></span></td>
                    <td><%= student %></td>
                    <td><%= title %></td>
                    <td style="color:#666;"><%= dateStr %></td>
                    <td class="price-text">RM <%= String.format("%.2f", price) %></td>
                    <td><%= phone != null ? phone : "N/A" %></td>
                    <td style="text-align:right">
                        <button class="btn-view" onclick="toggleDetails('<%= id %>')">
                            View <i class="fas fa-eye"></i>
                        </button>
                    </td>
                </tr>

                <tr id="details-<%= id %>" class="details-row">
                    <td colspan="7" style="padding: 0; background: transparent; border: none;">
                        <div class="details-wrapper">
                            
                            <!-- Image Gallery Section -->
                            <div class="image-gallery-section">
                                <div class="main-image-container">
                                    <%
                                        if (!images.isEmpty()) {
                                    %>
                                    <img id="main-img-<%= id %>" src="uploads/<%= images.get(0) %>" 
                                         class="main-image" 
                                         onclick="openImageModal(<%= id %>, 0)"
                                         onerror="this.src='https://via.placeholder.com/350x250/800000/ffffff?text=Image+Not+Found'">
                                    <div class="image-counter"><%= images.size() %> image(s)</div>
                                    <%
                                        } else {
                                    %>
                                    <div class="no-images-container">
                                        <i class="fas fa-image fa-3x"></i>
                                        <span>No Images Available</span>
                                    </div>
                                    <%
                                        }
                                    %>
                                </div>
                                
                                <!-- Thumbnail Container -->
                                <div class="thumbnail-container">
                                    <%
                                        if (!images.isEmpty()) {
                                            for (int i = 0; i < images.size(); i++) {
                                                String img = images.get(i);
                                    %>
                                    <div class="thumbnail <%= i == 0 ? "active" : "" %>" 
                                         onclick="changeMainImage(<%= id %>, <%= i %>, '<%= img %>')">
                                        <img src="uploads/<%= img %>" 
                                             onerror="this.src='https://via.placeholder.com/60/800000/ffffff?text=Img'">
                                    </div>
                                    <%
                                            }
                                        }
                                        
                                        // Show empty thumbnails for missing images
                                        int emptySlots = 3 - images.size();
                                        for (int i = 0; i < emptySlots; i++) {
                                    %>
                                    <div class="thumbnail empty-thumbnail">
                                        <i class="fas fa-image"></i>
                                        <span>Empty</span>
                                    </div>
                                    <%
                                        }
                                    %>
                                </div>
                            </div>

                            <!-- Item Details Section -->
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
                                    <button type="button" class="btn-action approve" onclick="processRequest(<%= id %>, 'approve')">
                                        <i class="fas fa-check"></i> Approve
                                    </button>

                                    <button type="button" class="btn-action reject" onclick="processRequest(<%= id %>, 'reject')">
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
                        <p style="color:#999;">All items have been processed.</p>
                    </td>
                </tr>
    <% 
            }
        } catch(Exception e) {
            e.printStackTrace();
    %>
                <tr>
                    <td colspan="7" style="text-align:center; padding:30px; color: red; background: #ffe6e6;">
                        <i class="fas fa-exclamation-triangle"></i>
                        <h4>Database Error</h4>
                        <p><strong>Error:</strong> <%= e.getMessage() %></p>
                        <p style="font-size:12px; margin-top:10px;">
                            <i class="fas fa-lightbulb"></i> 
                            <strong>Note:</strong> Make sure your ITEMS table has image_url2 and image_url3 columns.
                        </p>
                    </td>
                </tr>
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

        <% 
            String searchParam = (searchQuery != null && !searchQuery.isEmpty()) ? "&search=" + searchQuery : "";
            if (totalPages > 1) { 
        %>
        <div class="pagination-container">
            <% for (int i = 1; i <= totalPages; i++) { %>
                <a href="approvals.jsp?page=<%= i %><%= searchParam %>" class="page-link <%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
            <% } %>
        </div>
        <% } %>
    </div>

    <!-- Modal for full-size image viewing -->
    <div id="imageModal" class="modal">
        <span class="close" onclick="closeImageModal()">&times;</span>
        <span class="arrow prev" onclick="changeModalSlide(-1)">&#10094;</span>
        <div class="modal-content">
            <img id="modalImg" src="">
            <div class="modal-counter" id="modalCounter">1 / 1</div>
            <div class="modal-nav">
                <button class="nav-btn" onclick="downloadCurrentImage()">
                    <i class="fas fa-download"></i> Download
                </button>
            </div>
        </div>
        <span class="arrow next" onclick="changeModalSlide(1)">&#10095;</span>
    </div>

    <div id="successPopup" class="custom-popup-overlay">
        <div class="custom-popup-content">
            <div class="popup-icon" id="popupIcon">
                <i class="fas fa-check"></i>
            </div>
            <div class="popup-title">Success!</div>
            <div class="popup-message" id="popupMessage">Action completed successfully!</div>
            <button class="popup-btn" onclick="closePopupAndReload()">OK</button>
        </div>
    </div>

    <script>
        // Store images for each item for modal navigation
        let itemImagesMap = {};
        let currentItemId = null;
        let currentImageIndex = 0;
        
        // --- Toggle Details Row ---
        function toggleDetails(id) {
            var rows = document.querySelectorAll('.details-row');
            var target = document.getElementById('details-' + id);
            // Close others
            rows.forEach(row => { if(row !== target) row.style.display = 'none'; });
            // Toggle clicked
            target.style.display = (target.style.display === 'table-row') ? 'none' : 'table-row';
        }
        
        // --- Change main image when thumbnail is clicked ---
        function changeMainImage(itemId, imageIndex, imageUrl) {
            // Update main image
            const mainImg = document.getElementById('main-img-' + itemId);
            if (mainImg) {
                mainImg.src = 'uploads/' + imageUrl;
                mainImg.onerror = function() {
                    this.src = 'https://via.placeholder.com/350x250/800000/ffffff?text=Image+Not+Found';
                };
            }
            
            // Update active thumbnail
            const thumbnails = document.querySelectorAll('#details-' + itemId + ' .thumbnail');
            thumbnails.forEach((thumb, index) => {
                thumb.classList.remove('active');
                if (index === imageIndex) {
                    thumb.classList.add('active');
                }
            });
            
            // Store current image index for this item
            if (!itemImagesMap[itemId]) {
                itemImagesMap[itemId] = {};
            }
            itemImagesMap[itemId].currentIndex = imageIndex;
        }
        
        // --- Open image modal ---
        function openImageModal(itemId, imageIndex) {
            const detailsRow = document.getElementById('details-' + itemId);
            if (!detailsRow) return;
            
            // Get all images for this item
            const thumbnails = detailsRow.querySelectorAll('.thumbnail:not(.empty-thumbnail) img');
            if (thumbnails.length === 0) return;
            
            const images = Array.from(thumbnails).map(img => img.src);
            
            // Store current item and images
            currentItemId = itemId;
            currentImageIndex = imageIndex;
            itemImagesMap[itemId] = {
                images: images,
                currentIndex: imageIndex
            };
            
            // Show modal with current image
            document.getElementById('modalImg').src = images[imageIndex];
            document.getElementById('modalCounter').textContent = `${imageIndex + 1} / ${images.length}`;
            document.getElementById('imageModal').style.display = "flex";
        }
        
        function closeImageModal() { 
            document.getElementById('imageModal').style.display = "none"; 
            currentItemId = null;
            currentImageIndex = 0;
        }
        
        function changeModalSlide(direction) {
            if (currentItemId && itemImagesMap[currentItemId]) {
                const images = itemImagesMap[currentItemId].images;
                let newIndex = currentImageIndex + direction;
                
                // Handle wrap-around
                if (newIndex < 0) newIndex = images.length - 1;
                if (newIndex >= images.length) newIndex = 0;
                
                currentImageIndex = newIndex;
                itemImagesMap[currentItemId].currentIndex = newIndex;
                
                // Update modal
                document.getElementById('modalImg').src = images[newIndex];
                document.getElementById('modalCounter').textContent = `${newIndex + 1} / ${images.length}`;
                
                // Also update the main image in the details view
                const mainImg = document.getElementById('main-img-' + currentItemId);
                if (mainImg) {
                    mainImg.src = images[newIndex];
                    
                    // Update active thumbnail
                    const thumbnails = document.querySelectorAll('#details-' + currentItemId + ' .thumbnail:not(.empty-thumbnail)');
                    thumbnails.forEach((thumb, index) => {
                        thumb.classList.remove('active');
                        if (index === newIndex) {
                            thumb.classList.add('active');
                        }
                    });
                }
            }
        }
        
        function downloadCurrentImage() {
            if (currentItemId && itemImagesMap[currentItemId]) {
                const imageUrl = itemImagesMap[currentItemId].images[currentImageIndex];
                const link = document.createElement('a');
                link.href = imageUrl;
                link.download = `item-${currentItemId}-image-${currentImageIndex + 1}.jpg`;
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }
        }
        
        // Keyboard navigation for modal
        document.addEventListener('keydown', function(event) {
            const modal = document.getElementById('imageModal');
            if (modal.style.display === 'flex') {
                if (event.key === 'Escape') {
                    closeImageModal();
                } else if (event.key === 'ArrowLeft') {
                    changeModalSlide(-1);
                } else if (event.key === 'ArrowRight') {
                    changeModalSlide(1);
                }
            }
        });

        // --- NEW: AJAX PROCESSING & POPUP ---
        function processRequest(itemId, actionType) {
            // Prepare data to send to Servlet
            const params = new URLSearchParams();
            params.append('itemId', itemId);
            params.append('action', actionType);

            // Send request to ProcessItemServlet without reloading page immediately
            fetch('ProcessItemServlet', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params
            })
            .then(response => {
                showPopup(actionType);
            })
            .catch(error => {
                console.error('Error:', error);
                alert("An error occurred connecting to the server.");
            });
        }

        function showPopup(actionType) {
            const popup = document.getElementById('successPopup');
            const message = document.getElementById('popupMessage');
            const icon = document.getElementById('popupIcon');

            // Reset icon style
            icon.classList.remove('error');
            icon.style.backgroundColor = "#28a745"; // Green
            icon.innerHTML = '<i class="fas fa-check"></i>';

            if (actionType === 'approve') {
                message.innerText = "Item approved successfully!";
            } else if (actionType === 'reject') {
                message.innerText = "Item rejected successfully!";
            }

            popup.style.display = "flex";
        }

        function closePopupAndReload() {
            document.getElementById('successPopup').style.display = "none";
            location.reload(); 
        }
    </script>
</body>
</html>