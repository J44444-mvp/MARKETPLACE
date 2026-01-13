<%@page import="java.sql.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Variables to store seller data for modal
    int sellerIdForModal = 0;
    String sellerNameForModal = "";
    String sellerEmailForModal = "";
    String sellerPhoneForModal = "";
    int totalItemsCount = 0;
    int activeItemsCount = 0;
    int soldItemsCount = 0;
    ArrayList<String[]> otherListings = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campus Marketplace | Product Details</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        :root {
            --primary-maroon: #800000;
            --light-maroon: #a00000;
            --dark-maroon: #600000;
            --background-white: #ffffff;
            --light-gray: #f8f9fa;
            --medium-gray: #e9ecef;
            --dark-gray: #6c757d;
            --text-dark: #343a40;
        }
        
        body {
            background-color: var(--light-gray);
            color: var(--text-dark);
        }
        
        .container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 15px;
        }
        
        header {
            background-color: var(--background-white);
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }
        
        .nav-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
        }
        
        .logo-icon {
            color: var(--primary-maroon);
            font-size: 28px;
        }
        
        .logo-text {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-maroon);
        }
        
        .logo-text span {
            color: var(--text-dark);
        }
        
        nav ul {
            display: flex;
            list-style: none;
            gap: 25px;
        }
        
        nav a {
            text-decoration: none;
            color: var(--text-dark);
            font-weight: 500;
            padding: 8px 12px;
            border-radius: 4px;
            transition: all 0.3s ease;
        }
        
        nav a:hover, nav a.active {
            background-color: var(--primary-maroon);
            color: white;
        }
        
        .user-actions {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .user-icon {
            background-color: var(--medium-gray);
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-maroon);
            cursor: pointer;
            text-decoration: none;
        }
        
        .btn {
            padding: 12px 24px;
            border-radius: 4px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
        }
        
        .btn-primary {
            background-color: var(--primary-maroon);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--dark-maroon);
        }
        
        .btn-outline {
            background-color: transparent;
            color: var(--primary-maroon);
            border: 2px solid var(--primary-maroon);
        }
        
        .btn-outline:hover {
            background-color: var(--primary-maroon);
            color: white;
        }
        
        .btn-large {
            padding: 15px 30px;
            font-size: 18px;
        }
        
        .btn-small {
            padding: 8px 16px;
            font-size: 14px;
        }
        
        .main-content {
            padding: 30px 0;
        }
        
        .product-detail-container {
            display: flex;
            gap: 40px;
        }
        
        .product-images {
            flex: 1;
        }
        
        .main-image {
            width: 100%;
            height: 400px;
            background-color: var(--medium-gray);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            overflow: hidden;
            position: relative;
        }
        
        .main-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .main-image i {
            font-size: 60px;
            color: var(--primary-maroon);
        }
        
        .no-image-text {
            position: absolute;
            color: var(--dark-gray);
            font-size: 16px;
            margin-top: 80px;
        }
        
        .image-thumbnails {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .thumbnail {
            width: 80px;
            height: 80px;
            background-color: var(--medium-gray);
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: 2px solid transparent;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .thumbnail:hover {
            transform: scale(1.05);
        }
        
        .thumbnail.active {
            border-color: var(--primary-maroon);
        }
        
        .thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .thumbnail i {
            font-size: 30px;
            color: var(--primary-maroon);
        }
        
        .product-info {
            flex: 1;
        }
        
        .product-status {
            display: inline-block;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        
        .product-status-available {
            background-color: #28a745;
        }
        
        .product-status-sold {
            background-color: #dc3545;
        }
        
        .product-status-approved {
            background-color: #28a745;
        }
        
        .product-status-pending {
            background-color: #ffc107;
            color: #000;
        }
        
        .product-status-rejected {
            background-color: #dc3545;
        }
        
        .product-title {
            font-size: 32px;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 10px;
        }
        
        .product-price {
            font-size: 36px;
            font-weight: 800;
            color: var(--primary-maroon);
            margin-bottom: 25px;
        }
        
        .seller-info {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            border: 1px solid var(--medium-gray);
        }
        
        .seller-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .seller-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background-color: var(--medium-gray);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-maroon);
            font-size: 24px;
            font-weight: 600;
        }
        
        .seller-details h4 {
            font-size: 20px;
            margin-bottom: 5px;
        }
        
        .seller-meta {
            display: flex;
            gap: 20px;
            font-size: 14px;
            color: var(--dark-gray);
        }
        
        .product-description {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid var(--medium-gray);
        }
        
        .description-title {
            font-size: 20px;
            font-weight: 600;
            color: var(--primary-maroon);
            margin-bottom: 15px;
        }
        
        .product-specs {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            margin-bottom: 25px;
            border: 1px solid var(--medium-gray);
        }
        
        .specs-title {
            font-size: 20px;
            font-weight: 600;
            color: var(--primary-maroon);
            margin-bottom: 15px;
        }
        
        .specs-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
        
        .spec-item {
            display: flex;
            justify-content: space-between;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--medium-gray);
        }
        
        .spec-label {
            font-weight: 500;
        }
        
        .spec-value {
            color: var(--dark-gray);
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            flex-wrap: wrap;
        }
        
        .seller-action-buttons {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        footer {
            background-color: var(--dark-maroon);
            color: white;
            padding: 40px 0 20px;
            margin-top: 50px;
        }
        
        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }
        
        .footer-section h3 {
            font-size: 20px;
            margin-bottom: 20px;
            color: white;
        }
        
        .footer-section ul {
            list-style: none;
        }
        
        .footer-section ul li {
            margin-bottom: 10px;
        }
        
        .footer-section ul li a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: color 0.3s ease;
        }
        
        .footer-section ul li a:hover {
            color: white;
        }
        
        .copyright {
            text-align: center;
            padding-top: 20px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            color: rgba(255, 255, 255, 0.7);
            font-size: 14px;
        }
        
        @media (max-width: 768px) {
            .nav-container {
                flex-direction: column;
                gap: 15px;
            }
            
            nav ul {
                flex-wrap: wrap;
                justify-content: center;
                gap: 10px;
            }
            
            .product-detail-container {
                flex-direction: column;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .specs-grid {
                grid-template-columns: 1fr;
            }
            
            .main-image {
                height: 300px;
            }
            
            .seller-action-buttons {
                flex-direction: column;
            }
        }
        
        .user-greeting {
            margin-right: 10px;
            color: var(--primary-maroon);
            font-weight: 500;
        }
        
        .logout-btn {
            padding: 8px 15px;
            font-size: 14px;
        }
        
        .message-success {
            background-color: #d4edda;
            color: #155724;
            padding: 10px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border: 1px solid #c3e6cb;
        }
        
        .message-error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 10px 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
        }
        
        .message-info {
            background-color: #d1ecf1;
            color: #0c5460;
            padding: 10px 15px;
            border-radius: 4px;
            margin-top: 20px;
            border: 1px solid #bee5eb;
        }
        
        .image-counter {
            position: absolute;
            bottom: 10px;
            right: 10px;
            background-color: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .empty-thumbnail {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: var(--dark-gray);
            font-size: 12px;
        }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        
        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 0;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .modal-header {
            background-color: var(--primary-maroon);
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .modal-header h3 {
            margin: 0;
            font-size: 20px;
        }
        
        .close-modal {
            background: none;
            border: none;
            color: white;
            font-size: 24px;
            cursor: pointer;
        }
        
        .modal-body {
            padding: 20px;
            max-height: 60vh;
            overflow-y: auto;
        }
        
        .seller-profile-card {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        
        .profile-header-modal {
            display: flex;
            align-items: center;
            gap: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid var(--medium-gray);
        }
        
        .seller-avatar-modal {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background-color: var(--medium-gray);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-maroon);
            font-size: 32px;
            font-weight: 600;
        }
        
        .seller-info-modal h4 {
            font-size: 22px;
            margin-bottom: 5px;
            color: var(--text-dark);
        }
        
        .seller-contact-modal {
            font-size: 14px;
            color: var(--dark-gray);
        }
        
        .seller-contact-modal div {
            margin-bottom: 5px;
        }
        
        .seller-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            text-align: center;
            padding: 15px;
            background-color: var(--light-gray);
            border-radius: 8px;
        }
        
        .stat-item {
            display: flex;
            flex-direction: column;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-maroon);
        }
        
        .stat-label {
            font-size: 12px;
            color: var(--dark-gray);
            margin-top: 5px;
        }
        
        .other-listings {
            margin-top: 10px;
        }
        
        .other-listings h4 {
            font-size: 16px;
            color: var(--primary-maroon);
            margin-bottom: 10px;
            padding-bottom: 5px;
            border-bottom: 1px solid var(--medium-gray);
        }
        
        .listing-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px;
            background-color: var(--light-gray);
            border-radius: 6px;
            margin-bottom: 8px;
            text-decoration: none;
            color: inherit;
            transition: background-color 0.3s;
        }
        
        .listing-item:hover {
            background-color: var(--medium-gray);
        }
        
        .listing-image {
            width: 50px;
            height: 50px;
            border-radius: 4px;
            background-color: white;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        
        .listing-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .listing-details {
            flex: 1;
        }
        
        .listing-title {
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 3px;
        }
        
        .listing-price {
            color: var(--primary-maroon);
            font-weight: 700;
            font-size: 14px;
        }
        
        .no-listings {
            text-align: center;
            padding: 20px;
            color: var(--dark-gray);
            font-style: italic;
        }
    </style>
</head>
<body>
    <header>
        <div class="container">
            <div class="nav-container">
                <a href="homepage.jsp" class="logo">
                    <div class="logo-icon">
                        <i class="fas fa-store"></i>
                    </div>
                    <div class="logo-text">Campus<span>Marketplace</span></div>
                </a>
                
                <nav>
                    <ul>
                        <li><a href="homepage.jsp">Home</a></li>
                        <li><a href="browse-item.jsp">Browse</a></li>
                        <li><a href="sell-item.jsp">Sell Item</a></li>
                        <li><a href="categories.jsp">Categories</a></li>
                    </ul>
                </nav>
                
                <div class="user-actions">
                    <%
                        String userName = (String) session.getAttribute("user");
                        Integer userId = (Integer) session.getAttribute("user_id");
                        String userRole = (String) session.getAttribute("role");
                    %>
                    <%
                        if (userName != null && !userName.isEmpty()) {
                    %>
                        <span class="user-greeting">Hello, <%= userName %>!</span>
                        <a href="profile.jsp" class="user-icon">
                            <i class="fas fa-user"></i>
                        </a>
                        <a href="LogoutServlet" class="btn btn-outline logout-btn">Log Out</a>
                    <%
                        } else {
                    %>
                        <a href="profile.jsp" class="user-icon">
                            <i class="fas fa-user"></i>
                        </a>
                        <a href="login.jsp" class="btn btn-outline">Log In</a>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
    </header>

    <!-- Seller Profile Modal -->
    <div id="sellerProfileModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-user"></i> Seller Profile</h3>
                <button class="close-modal">&times;</button>
            </div>
            <div class="modal-body" id="sellerProfileContent">
                <!-- Content will be loaded here -->
            </div>
        </div>
    </div>

    <div class="main-content">
        <div class="container">
            <%
                String itemId = request.getParameter("id");
                String message = request.getParameter("message");
                String error = request.getParameter("error");
                
                if (message != null) {
            %>
                <div class="message-success">
                    <i class="fas fa-check-circle"></i> <%= message %>
                </div>
            <%
                }
                
                if (error != null) {
            %>
                <div class="message-error">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
            <%
                }
                
                if (itemId == null || itemId.isEmpty()) {
            %>
                <div class="message-error">
                    <i class="fas fa-exclamation-circle"></i> Item ID is required
                </div>
            <%
                } else {
                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                        
                        // Get item details with all fields
                        String sql = "SELECT i.*, u.full_name, u.email, u.phone_number, u.user_id as seller_user_id " +
                                   "FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id " +
                                   "WHERE i.item_id = ? AND i.status IN ('APPROVED', 'AVAILABLE', 'SOLD')";
                        
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setInt(1, Integer.parseInt(itemId));
                        ResultSet rs = ps.executeQuery();
                        
                        if (rs.next()) {
                            String itemName = rs.getString("item_name");
                            String description = rs.getString("description");
                            double price = rs.getDouble("price");
                            String status = rs.getString("status");
                            String sellerName = rs.getString("full_name");
                            String sellerEmail = rs.getString("email");
                            String sellerPhone = rs.getString("phone_number");
                            Timestamp dateSubmitted = rs.getTimestamp("date_submitted");
                            String imageUrl = rs.getString("image_url");
                            String imageUrl2 = rs.getString("image_url2");
                            String imageUrl3 = rs.getString("image_url3");
                            String condition = rs.getString("condition");
                            String brand = rs.getString("brand");
                            String negotiable = rs.getString("negotiable");
                            String meetupLocation = rs.getString("meetup_location");
                            int sellerId = rs.getInt("seller_user_id");
                            
                            // Store seller info for modal
                            sellerIdForModal = sellerId;
                            sellerNameForModal = sellerName;
                            sellerEmailForModal = sellerEmail;
                            sellerPhoneForModal = sellerPhone;
                            
                            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
                            String formattedDate = dateSubmitted != null ? sdf.format(dateSubmitted) : "Unknown";
                            
                            // Collect all non-empty images
                            java.util.List<String> images = new java.util.ArrayList<>();
                            if (imageUrl != null && !imageUrl.isEmpty() && !imageUrl.equals("null")) {
                                images.add("uploads/" + imageUrl);
                            }
                            if (imageUrl2 != null && !imageUrl2.isEmpty() && !imageUrl2.equals("null")) {
                                images.add("uploads/" + imageUrl2);
                            }
                            if (imageUrl3 != null && !imageUrl3.isEmpty() && !imageUrl3.equals("null")) {
                                images.add("uploads/" + imageUrl3);
                            }
                            
                            // Handle missing condition
                            if (condition == null || condition.isEmpty() || condition.equals("null")) {
                                condition = "Not specified";
                            }
                            
                            // Fetch seller statistics and other listings
                            try {
                                // Count active items
                                String activeCountQuery = "SELECT COUNT(*) as count FROM ITEMS WHERE user_id = ? AND (status = 'AVAILABLE' OR status = 'APPROVED')";
                                PreparedStatement activeCountStmt = conn.prepareStatement(activeCountQuery);
                                activeCountStmt.setInt(1, sellerId);
                                ResultSet activeCountRs = activeCountStmt.executeQuery();
                                if (activeCountRs.next()) {
                                    activeItemsCount = activeCountRs.getInt("count");
                                }
                                activeCountStmt.close();
                                
                                // Count sold items
                                String soldCountQuery = "SELECT COUNT(*) as count FROM ITEMS WHERE user_id = ? AND status = 'SOLD'";
                                PreparedStatement soldCountStmt = conn.prepareStatement(soldCountQuery);
                                soldCountStmt.setInt(1, sellerId);
                                ResultSet soldCountRs = soldCountStmt.executeQuery();
                                if (soldCountRs.next()) {
                                    soldItemsCount = soldCountRs.getInt("count");
                                }
                                soldCountStmt.close();
                                
                                totalItemsCount = activeItemsCount + soldItemsCount;
                                
                                // Get seller's other active listings (excluding current item)
                                String otherListingsQuery = "SELECT item_id, item_name, price, image_url FROM ITEMS " +
                                                           "WHERE user_id = ? AND (status = 'AVAILABLE' OR status = 'APPROVED') " +
                                                           "AND item_id != ? " +
                                                           "ORDER BY date_submitted DESC";
                                
                                PreparedStatement otherListingsStmt = conn.prepareStatement(otherListingsQuery);
                                otherListingsStmt.setInt(1, sellerId);
                                otherListingsStmt.setInt(2, Integer.parseInt(itemId));
                                ResultSet otherListingsRs = otherListingsStmt.executeQuery();
                                
                                while (otherListingsRs.next()) {
                                    String[] listing = new String[4];
                                    listing[0] = String.valueOf(otherListingsRs.getInt("item_id"));
                                    listing[1] = otherListingsRs.getString("item_name");
                                    listing[2] = String.format("%.2f", otherListingsRs.getDouble("price"));
                                    listing[3] = otherListingsRs.getString("image_url");
                                    otherListings.add(listing);
                                }
                                otherListingsStmt.close();
                                
                            } catch (Exception e) {
                                // If there's an error fetching stats, we'll still show the modal with basic info
                                System.out.println("Error fetching seller stats: " + e.getMessage());
                            }
            %>
            <div class="product-detail-container">
                <div class="product-images">
                    <div class="main-image" id="mainImage">
                        <%
                            if (!images.isEmpty()) {
                        %>
                        <img src="<%= images.get(0) %>" alt="<%= itemName %>" id="currentImage" 
                             onerror="this.onerror=null; this.src='https://via.placeholder.com/600x400/800000/ffffff?text=Image+Not+Found'">
                        <span class="image-counter"><%= images.size() %> image(s)</span>
                        <%
                            } else {
                        %>
                        <i class="fas fa-tag"></i>
                        <div class="no-image-text">No Image Available</div>
                        <%
                            }
                        %>
                    </div>
                    
                    <div class="image-thumbnails">
                        <%
                            if (!images.isEmpty()) {
                                for (int i = 0; i <images.size(); i++) {
                                    String img = images.get(i);
                        %>
                        <div class="thumbnail <%= i == 0 ? "active" : "" %>" onclick="changeImage('<%= img %>', this)">
                            <img src="<%= img %>" alt="Thumbnail <%= i + 1 %>" 
                                 onerror="this.onerror=null; this.src='https://via.placeholder.com/80/800000/ffffff?text=Img'">
                        </div>
                        <%
                                }
                            }
                            
                            // Show empty thumbnails for remaining slots
                            int totalSlots = 3;
                            int emptySlots = totalSlots - images.size();
                            for (int i = 0; i < emptySlots; i++) {
                        %>
                        <div class="thumbnail empty-thumbnail" style="cursor: default; opacity: 0.5;">
                            <i class="fas fa-image"></i>
                            <span>Empty</span>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
                
                <div class="product-info">
                    <div class="product-status product-status-<%= status.toLowerCase() %>">
                        <%= status %>
                    </div>
                    <h1 class="product-title"><%= itemName %></h1>
                    
                    <div class="product-price">RM<%= String.format("%.2f", price) %></div>
                    
                    <div class="seller-info">
                        <div class="seller-header">
                            <div class="seller-avatar">
                                <%
                                    if (sellerName != null && sellerName.length() >= 2) {
                                        out.print(sellerName.substring(0, 2).toUpperCase());
                                    } else {
                                        out.print("SU");
                                    }
                                %>
                            </div>
                            <div class="seller-details">
                                <h4><%= sellerName %></h4>
                                <div class="seller-meta">
                                    <span><i class="fas fa-envelope"></i> <%= sellerEmail %></span>
                                    <%
                                        if (sellerPhone != null && !sellerPhone.isEmpty() && !sellerPhone.equals("null")) {
                                    %>
                                    <span><i class="fas fa-phone"></i> <%= sellerPhone %></span>
                                    <%
                                        }
                                    %>
                                </div>
                            </div>
                        </div>
                        
                        <div class="seller-action-buttons">
                        <%
                            if (sellerPhone != null && !sellerPhone.isEmpty() && !sellerPhone.equals("null")) {
                                // Clean phone number for WhatsApp
                                String cleanPhone = sellerPhone.replaceAll("[^0-9+]", "");
                                String whatsappMessage = "Hi " + sellerName + ", I saw your " + itemName + " listing on Campus Marketplace";
                                String whatsappUrl = "https://wa.me/" + cleanPhone + "?text=" + java.net.URLEncoder.encode(whatsappMessage, "UTF-8");
                        %>
                        <a href="<%= whatsappUrl %>" class="btn btn-outline btn-small" style="flex: 1;" target="_blank">
                            <i class="fab fa-whatsapp"></i> WhatsApp Seller
                        </a>
                        <%
                            }
                        %>
                        <button class="btn btn-outline btn-small" style="flex: 1;" onclick="viewSellerProfile()">
                            <i class="fas fa-user"></i> View Profile
                        </button>
                        </div>
                    </div>
                    
                    <div class="product-description">
                        <h3 class="description-title">Item Description</h3>
                        <p><%= description != null && !description.equals("null") ? description.replace("\n", "<br>") : "No description provided." %></p>
                    </div>
                    
                    <div class="product-specs">
                        <h3 class="specs-title">Item Details</h3>
                        <div class="specs-grid">
                            <div class="spec-item">
                                <span class="spec-label">Condition</span>
                                <span class="spec-value"><%= condition %></span>
                            </div>
                            <div class="spec-item">
                                <span class="spec-label">Posted</span>
                                <span class="spec-value"><%= formattedDate %></span>
                            </div>
                            <div class="spec-item">
                                <span class="spec-label">Status</span>
                                <span class="spec-value"><%= status %></span>
                            </div>
                            <div class="spec-item">
                                <span class="spec-label">Brand</span>
                                <span class="spec-value"><%= brand != null && !brand.equals("null") ? brand : "Not specified" %></span>
                            </div>
                            <div class="spec-item">
                                <span class="spec-label">Negotiable</span>
                                <span class="spec-value"><%= "yes".equalsIgnoreCase(negotiable) ? "Yes" : "No" %></span>
                            </div>
                            <div class="spec-item">
                                <span class="spec-label">Meetup Location</span>
                                <span class="spec-value"><%= meetupLocation != null && !meetupLocation.equals("null") ? meetupLocation : "Not specified" %></span>
                            </div>
                        </div>
                    </div>
                    
                    <%
                        if ("APPROVED".equals(status) || "AVAILABLE".equals(status)) {
                    %>
                    <div class="action-buttons">
                        <%
                            if (userName != null && userId != null) {
                                if (userId == sellerId) {
                                    // Seller view - can edit
                        %>
                        <a href="edit-item.jsp?id=<%= itemId %>" class="btn btn-primary btn-large">
                            <i class="fas fa-edit"></i> Edit Listing
                        </a>
                        <a href="profile.jsp" class="btn btn-outline btn-large">
                            <i class="fas fa-user"></i> View My Listings
                        </a>
                        <%
                                } else {
                                    // Buyer view - can contact
                                    if (sellerPhone != null && !sellerPhone.isEmpty() && !sellerPhone.equals("null")) {
                                        String cleanPhone = sellerPhone.replaceAll("[^0-9+]", "");
                                        String buyerMessage = "I'm interested in your " + itemName + " listed on Campus Marketplace for RM" + String.format("%.2f", price);
                                        String buyerWhatsappUrl = "https://wa.me/" + cleanPhone + "?text=" + java.net.URLEncoder.encode(buyerMessage, "UTF-8");
                        %>
                        <a href="<%= buyerWhatsappUrl %>" class="btn btn-primary btn-large" target="_blank">
                            <i class="fab fa-whatsapp"></i> Contact via WhatsApp
                        </a>
                        <%
                                    }
                        %>
                        <a href="mailto:<%= sellerEmail %>?subject=Interested in <%= itemName %>&body=Hello <%= sellerName %>,%0D%0A%0D%0AI am interested in your <%= itemName %> listed on Campus Marketplace for RM<%= String.format("%.2f", price) %>.%0D%0A%0D%0ACould we discuss further?" 
                           class="btn btn-outline btn-large">
                            <i class="fas fa-envelope"></i> Send Email
                        </a>
                        <%
                                }
                            } else {
                                // Not logged in
                        %>
                        <a href="login.jsp" class="btn btn-primary btn-large">
                            <i class="fas fa-sign-in-alt"></i> Login to Contact Seller
                        </a>
                        <%
                            }
                        %>
                    </div>
                    <%
                        } else if ("SOLD".equals(status)) {
                    %>
                    <div class="message-error">
                        <i class="fas fa-exclamation-circle"></i> This item has been sold
                    </div>
                    <%
                        } else if ("PENDING".equals(status)) {
                    %>
                    <div class="message-info">
                        <i class="fas fa-info-circle"></i> This item is pending approval
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
            
            <!-- Hidden div with seller profile data for modal -->
            <div id="sellerProfileData" style="display: none;">
                <div class="seller-profile-card">
                    <div class="profile-header-modal">
                        <div class="seller-avatar-modal">
                            <%
                                if (sellerNameForModal != null && sellerNameForModal.length() >= 2) {
                                    out.print(sellerNameForModal.substring(0, 2).toUpperCase());
                                } else if (sellerNameForModal != null && !sellerNameForModal.isEmpty()) {
                                    out.print(sellerNameForModal.substring(0, 1).toUpperCase());
                                } else {
                                    out.print("SU");
                                }
                            %>
                        </div>
                        <div class="seller-info-modal">
                            <h4><%= sellerNameForModal %></h4>
                            <div class="seller-contact-modal">
                                <div><i class="fas fa-envelope"></i> <%= sellerEmailForModal %></div>
                                <%
                                    if (sellerPhoneForModal != null && !sellerPhoneForModal.isEmpty() && !sellerPhoneForModal.equals("null")) {
                                %>
                                <div><i class="fas fa-phone"></i> <%= sellerPhoneForModal %></div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                    </div>
                    
                    <div class="seller-stats">
                        <div class="stat-item">
                            <div class="stat-value"><%= totalItemsCount %></div>
                            <div class="stat-label">Total Items</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value"><%= activeItemsCount %></div>
                            <div class="stat-label">Active</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-value"><%= soldItemsCount %></div>
                            <div class="stat-label">Sold</div>
                        </div>
                    </div>
                    
                    <div class="other-listings">
                        <h4>Other Items from This Seller</h4>
                        <%
                            if (!otherListings.isEmpty()) {
                                for (String[] listing : otherListings) {
                                    String otherItemId = listing[0];
                                    String otherItemName = listing[1];
                                    String otherItemPrice = listing[2];
                                    String otherItemImage = listing[3];
                        %>
                        <a href="item-detail.jsp?id=<%= otherItemId %>" class="listing-item" onclick="window.location.href='item-detail.jsp?id=<%= otherItemId %>'; closeModal(); return false;">
                            <div class="listing-image">
                                <%
                                    if (otherItemImage != null && !otherItemImage.isEmpty() && !otherItemImage.equals("null")) {
                                %>
                                <img src="uploads/<%= otherItemImage %>" alt="<%= otherItemName %>" 
                                     onerror="this.onerror=null; this.src='https://via.placeholder.com/50/800000/ffffff?text=Img'">
                                <%
                                    } else {
                                %>
                                <i class="fas fa-tag" style="color: var(--dark-gray); font-size: 20px;"></i>
                                <%
                                    }
                                %>
                            </div>
                            <div class="listing-details">
                                <div class="listing-title"><%= otherItemName %></div>
                                <div class="listing-price">RM<%= otherItemPrice %></div>
                            </div>
                        </a>
                        <%
                                }
                            } else {
                        %>
                        <div class="no-listings">
                            <p>No other active listings from this seller.</p>
                        </div>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
            <%
                        } else {
            %>
            <div class="message-error">
                <i class="fas fa-exclamation-circle"></i> Item not found or not available
            </div>
            <%
                        }
                        conn.close();
                    } catch(Exception e) {
                        e.printStackTrace();
            %>
            <div class="message-error">
                <i class="fas fa-exclamation-circle"></i> Error loading item details: <%= e.getMessage() %>
            </div>
            <%
                    }
                }
            %>
        </div>
    </div>

    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Campus Marketplace</h3>
                    <p>A platform for students to buy and sell second-hand items within campus. Save money, reduce waste, and build a sustainable campus community.</p>
                </div>
                
                <div class="footer-section">
                    <h3>Quick Links</h3>
                    <ul>
                        <li><a href="homepage.jsp">Home</a></li>
                        <li><a href="browse-item.jsp">Browse Items</a></li>
                        <li><a href="sell-item.jsp">Sell an Item</a></li>
                        <li><a href="profile.jsp">My Account</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h3>Categories</h3>
                    <ul>
                        <li><a href="browse-item.jsp?category=textbooks">Textbooks</a></li>
                        <li><a href="browse-item.jsp?category=electronics">Electronics</a></li>
                        <li><a href="browse-item.jsp?category=uniforms">Uniforms</a></li>
                        <li><a href="browse-item.jsp?category=other">Other Items</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h3>Contact</h3>
                    <ul>
                        <li><i class="fas fa-envelope"></i> admin@edu.com </li>
                        <li><i class="fas fa-phone"></i> 609 345678 </li>
                        <li><i class="fas fa-map-marker-alt"></i> UiTM Kuala Terengganu, Kumpulan 7</li>
                    </ul>
                </div>
            </div>
            
            <div class="copyright">
                &copy; <%= java.time.Year.now().getValue() %> Campus Marketplace. Designed for students, by students.
            </div>
        </div>
    </footer>

    <script>
        function changeImage(imageUrl, element) {
            const mainImage = document.getElementById('currentImage');
            
            // Update main image
            if (mainImage) {
                mainImage.src = imageUrl;
            } else {
                const mainImageDiv = document.getElementById('mainImage');
                mainImageDiv.innerHTML = `<img src="${imageUrl}" alt="Item image" id="currentImage" onerror="this.onerror=null; this.src='https://via.placeholder.com/600x400/800000/ffffff?text=Image+Not+Found'">`;
            }
            
            // Update active thumbnail
            const thumbnails = document.querySelectorAll('.thumbnail');
            thumbnails.forEach(thumb => {
                thumb.classList.remove('active');
            });
            
            // Only set active if it's not an empty thumbnail
            if (!element.classList.contains('empty-thumbnail')) {
                element.classList.add('active');
            }
        }
        
        // Seller Profile Modal Functions
        function viewSellerProfile() {
            // Get the seller profile data from the hidden div
            const sellerProfileData = document.getElementById('sellerProfileData').innerHTML;
            document.getElementById('sellerProfileContent').innerHTML = sellerProfileData;
            document.getElementById('sellerProfileModal').style.display = 'block';
        }
        
        function closeModal() {
            document.getElementById('sellerProfileModal').style.display = 'none';
        }
        
        // Close modal when clicking X
        document.querySelector('.close-modal').addEventListener('click', function() {
            closeModal();
        });
        
        // Close modal when clicking outside
        window.addEventListener('click', function(event) {
            const modal = document.getElementById('sellerProfileModal');
            if (event.target === modal) {
                closeModal();
            }
        });
        
        // Close modal with Escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                closeModal();
            }
        });
    </script>
</body>
</html>