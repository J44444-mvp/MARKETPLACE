<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.marketplace.model.User"%>
<%@page import="com.marketplace.model.Item"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campus Marketplace | My Profile</title>
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
            padding: 10px 20px;
            border-radius: 4px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
            text-decoration: none;
            display: inline-block;
            font-size: 14px;
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
        
        .btn-small {
            padding: 6px 12px;
            font-size: 12px;
        }
        
        .main-content {
            padding: 30px 0;
        }
        
        .profile-container {
            display: flex;
            gap: 30px;
        }
        
        .profile-sidebar {
            width: 300px;
            flex-shrink: 0;
        }
        
        .profile-card {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--medium-gray);
            text-align: center;
            margin-bottom: 20px;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background-color: var(--medium-gray);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-maroon);
            font-size: 48px;
            font-weight: 600;
            margin: 0 auto 20px;
        }
        
        .profile-name {
            font-size: 24px;
            font-weight: 700;
            margin-bottom: 5px;
            color: var(--text-dark);
        }
        
        .profile-major {
            color: var(--primary-maroon);
            font-size: 16px;
            margin-bottom: 15px;
        }
        
        .profile-stats {
            display: flex;
            justify-content: space-around;
            margin: 20px 0;
            padding: 15px 0;
            border-top: 1px solid var(--medium-gray);
            border-bottom: 1px solid var(--medium-gray);
        }
        
        .stat-item {
            text-align: center;
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
        
        .profile-actions {
            display: flex;
            flex-direction: column;
            gap: 10px;
            margin-top: 20px;
        }
        
        .sidebar-menu {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--medium-gray);
        }
        
        .menu-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 15px;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            color: var(--text-dark);
            margin-bottom: 5px;
        }
        
        .menu-item:hover, .menu-item.active {
            background-color: var(--primary-maroon);
            color: white;
        }
        
        .menu-item i {
            width: 20px;
        }
        
        .profile-main {
            flex: 1;
        }
        
        .profile-header {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--medium-gray);
            margin-bottom: 25px;
        }
        
        .profile-tabs {
            display: flex;
            border-bottom: 1px solid var(--medium-gray);
            margin-bottom: 20px;
        }
        
        .tab {
            padding: 12px 20px;
            cursor: pointer;
            font-weight: 500;
            border-bottom: 3px solid transparent;
            transition: all 0.3s ease;
        }
        
        .tab:hover, .tab.active {
            color: var(--primary-maroon);
            border-bottom-color: var(--primary-maroon);
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: var(--primary-maroon);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .listings-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .item-card {
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
            border: 1px solid var(--medium-gray);
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        .item-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .item-image {
            height: 180px;
            background-color: var(--medium-gray);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--dark-gray);
            position: relative;
        }
        
        .item-status {
            position: absolute;
            top: 15px;
            right: 15px;
            background-color: var(--primary-maroon);
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .item-details {
            padding: 20px;
        }
        
        .item-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 10px;
            color: var(--text-dark);
        }
        
        .item-price {
            font-size: 22px;
            font-weight: 700;
            color: var(--primary-maroon);
            margin-bottom: 15px;
        }
        
        .item-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
        }
        
        .no-items {
            text-align: center;
            padding: 50px 20px;
            color: var(--dark-gray);
            grid-column: 1 / -1;
        }
        
        .no-items i {
            font-size: 48px;
            margin-bottom: 20px;
            color: var(--medium-gray);
        }
        
        .activity-list {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .activity-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px;
            background-color: white;
            border-radius: 8px;
            border: 1px solid var(--medium-gray);
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: var(--medium-gray);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-maroon);
        }
        
        .activity-content {
            flex: 1;
        }
        
        .activity-title {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .activity-time {
            font-size: 12px;
            color: var(--dark-gray);
        }
        
        .settings-form {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            border: 1px solid var(--medium-gray);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--medium-gray);
            border-radius: 4px;
            font-size: 16px;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-row .form-group {
            flex: 1;
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
            
            .profile-container {
                flex-direction: column;
            }
            
            .profile-sidebar {
                width: 100%;
            }
            
            .profile-tabs {
                flex-wrap: wrap;
            }
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
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
            margin: 15% auto;
            padding: 25px;
            border-radius: 8px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        
        .delete-btn {
            background-color: #dc3545;
            color: white;
            border-color: #dc3545;
        }

        .delete-btn:hover {
            background-color: #c82333;
            border-color: #bd2130;
            color: white;
        }
        
        .alert {
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
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
                        // Get user from session like in item-detail.jsp
                        String userName = (String) session.getAttribute("user");
                        Integer userId = (Integer) session.getAttribute("user_id");
                        String userRole = (String) session.getAttribute("role");
                    %>
                    
                    <%
                        if (userName != null && !userName.isEmpty()) {
                    %>
                        <span style="color: var(--primary-maroon); font-weight: 500; margin-right: 10px;">Hello, <%= userName %>!</span>
                        <a href="profile.jsp" class="user-icon">
                            <i class="fas fa-user"></i>
                        </a>
                        <a href="LogoutServlet" class="btn btn-outline">Log Out</a>
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

    <div class="main-content">
        <div class="container">
            <!-- Success/Error Messages -->
            <% 
                if (session.getAttribute("successMessage") != null) { 
                    String successMsg = (String) session.getAttribute("successMessage");
            %>
                <div class="alert alert-success">
                    <%= successMsg %>
                </div>
            <% 
                    session.removeAttribute("successMessage");
                } 
            %>
            
            <% 
                if (session.getAttribute("errorMessage") != null) { 
                    String errorMsg = (String) session.getAttribute("errorMessage");
            %>
                <div class="alert alert-error">
                    <%= errorMsg %>
                </div>
            <% 
                    session.removeAttribute("errorMessage");
                } 
            %>
            
            <%
                // Check if user is logged in - using same method as item-detail.jsp
                String userNameSession = (String) session.getAttribute("user");
                Integer userIdSession = (Integer) session.getAttribute("user_id");
                
                if (userNameSession == null || userIdSession == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
                
                // Initialize lists
                List<Item> activeItems = new ArrayList<Item>();
                List<Item> soldItems = new ArrayList<Item>();
                int soldCount = 0;
                String fullName = "";
                String email = "";
                String phoneNumber = "";
                
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                    
                    // Get user details
                    String userQuery = "SELECT full_name, email, phone_number FROM USERS WHERE user_id = ?";
                    PreparedStatement userStmt = conn.prepareStatement(userQuery);
                    userStmt.setInt(1, userIdSession);
                    ResultSet userRs = userStmt.executeQuery();
                    
                    if (userRs.next()) {
                        fullName = userRs.getString("full_name");
                        email = userRs.getString("email");
                        phoneNumber = userRs.getString("phone_number");
                    }
                    userStmt.close();
                    
                    // 1. Get user's active listings (status = 'available' or 'APPROVED')
                    String activeQuery = "SELECT * FROM ITEMS WHERE USER_ID = ? AND (STATUS = 'available' OR STATUS = 'APPROVED') ORDER BY DATE_SUBMITTED DESC";
                    PreparedStatement activeStmt = conn.prepareStatement(activeQuery);
                    activeStmt.setInt(1, userIdSession);
                    ResultSet activeRs = activeStmt.executeQuery();
                    
                    while (activeRs.next()) {
                        Item item = new Item();
                        item.setItemId(activeRs.getInt("ITEM_ID"));
                        item.setItemName(activeRs.getString("ITEM_NAME"));
                        item.setDescription(activeRs.getString("DESCRIPTION"));
                        item.setPrice(activeRs.getDouble("PRICE"));
                        item.setStatus(activeRs.getString("STATUS"));
                        item.setUserId(activeRs.getInt("USER_ID"));
                        item.setCategoryId(activeRs.getInt("CATEGORY_ID"));
                        item.setDateSubmitted(activeRs.getTimestamp("DATE_SUBMITTED"));
                        item.setDateActioned(activeRs.getTimestamp("DATE_ACTIONED"));
                        item.setCondition(activeRs.getString("CONDITION"));
                        item.setBrand(activeRs.getString("BRAND"));
                        item.setNegotiable(activeRs.getString("NEGOTIABLE"));
                        item.setMeetupLocation(activeRs.getString("MEETUP_LOCATION"));
                        activeItems.add(item);
                    }
                    activeStmt.close();
                    
                    // 2. Get user's sold items (status = 'sold' or 'SOLD')
                    String soldQuery = "SELECT * FROM ITEMS WHERE USER_ID = ? AND (STATUS = 'sold' OR STATUS = 'SOLD') ORDER BY DATE_ACTIONED DESC";
                    PreparedStatement soldStmt = conn.prepareStatement(soldQuery);
                    soldStmt.setInt(1, userIdSession);
                    ResultSet soldRs = soldStmt.executeQuery();
                    
                    while (soldRs.next()) {
                        Item item = new Item();
                        item.setItemId(soldRs.getInt("ITEM_ID"));
                        item.setItemName(soldRs.getString("ITEM_NAME"));
                        item.setDescription(soldRs.getString("DESCRIPTION"));
                        item.setPrice(soldRs.getDouble("PRICE"));
                        item.setStatus(soldRs.getString("STATUS"));
                        item.setUserId(soldRs.getInt("USER_ID"));
                        item.setCategoryId(soldRs.getInt("CATEGORY_ID"));
                        item.setDateSubmitted(soldRs.getTimestamp("DATE_SUBMITTED"));
                        item.setDateActioned(soldRs.getTimestamp("DATE_ACTIONED"));
                        item.setCondition(soldRs.getString("CONDITION"));
                        item.setBrand(soldRs.getString("BRAND"));
                        item.setNegotiable(soldRs.getString("NEGOTIABLE"));
                        item.setMeetupLocation(soldRs.getString("MEETUP_LOCATION"));
                        soldItems.add(item);
                    }
                    soldStmt.close();
                    
                    // 3. Get sold count
                    String countQuery = "SELECT COUNT(*) FROM ITEMS WHERE USER_ID = ? AND (STATUS = 'sold' OR STATUS = 'SOLD')";
                    PreparedStatement countStmt = conn.prepareStatement(countQuery);
                    countStmt.setInt(1, userIdSession);
                    ResultSet countRs = countStmt.executeQuery();
                    if (countRs.next()) {
                        soldCount = countRs.getInt(1);
                    }
                    countStmt.close();
                    
                    conn.close();
                    
                } catch (Exception e) {
                    e.printStackTrace();
                    out.print("<div class='alert alert-error'>Database error: " + e.getMessage() + "</div>");
                }
            %>
            
            <div class="profile-container">
                <div class="profile-sidebar">
                    <div class="profile-card">
                        <div class="profile-avatar">
                            <% 
                                String initials = "U";
                                if (fullName != null && !fullName.isEmpty()) {
                                    initials = fullName.substring(0, 1).toUpperCase();
                                }
                            %>
                            <%= initials %>
                        </div>
                        <h2 class="profile-name">
                            <%= fullName != null ? fullName : userNameSession %>
                        </h2>
                        <div class="profile-major">
                            <% 
                                if (phoneNumber != null && !phoneNumber.isEmpty() && !phoneNumber.equals("null")) {
                                    out.print(phoneNumber);
                                } else {
                                    out.print("Phone not set");
                                }
                            %>
                        </div>
                        
                        <div class="profile-stats">
                            <div class="stat-item">
                                <div class="stat-value"><%= activeItems.size() %></div>
                                <div class="stat-label">Items Sell</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value"><%= soldCount %></div>
                                <div class="stat-label">Items Sold</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value">0</div>
                                <div class="stat-label">Items Bought</div>
                            </div>
                        </div>
                        
                        <div class="profile-actions">
                            <a href="sell-item.jsp" class="btn btn-primary">
                                <i class="fas fa-plus-circle"></i> Sell Item
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="profile-main">
                    <div class="profile-header">
                        <div class="profile-tabs">
                            <div class="tab active" data-tab="listings">My Listings</div>
                            <div class="tab" data-tab="sold">Sold Items</div>
                            <div class="tab" data-tab="purchases">My Purchases</div>
                            <div class="tab" data-tab="settings">Account Settings</div>
                        </div>
                        
                        <!-- MY LISTINGS TAB -->
                        <div id="listings" class="tab-content active">
                            <h3 class="section-title"><i class="fas fa-th-large"></i> Active Listings</h3>
                            
                            <div class="listings-grid">
                                <%
                                    if (!activeItems.isEmpty()) {
                                        for (Item item : activeItems) {
                                            String description = item.getDescription();
                                            if (description != null && description.length() > 100) {
                                                description = description.substring(0, 100) + "...";
                                            }
                                %>
                                <div class="item-card">
                                    <div class="item-image">
                                        <div class="item-status">Available</div>
                                        <i class="fas fa-box fa-3x" style="color: #800000;"></i>
                                    </div>
                                    <div class="item-details">
                                        <div class="item-title"><%= item.getItemName() %></div>
                                        <div class="item-price">RM<%= String.format("%.2f", item.getPrice()) %></div>
                                        <p><%= description != null ? description : "No description" %></p>
                                        <div class="item-actions">
                                            <a href="edit-item.jsp?id=<%= item.getItemId() %>" 
                                               class="btn btn-primary btn-small">Edit</a>
                                            
                                            <form action="DeleteItemServlet" method="POST" style="display: inline;">
                                                <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                                                <button type="submit" class="btn btn-outline btn-small delete-btn" 
                                                        onclick="return confirm('Are you sure you want to delete this item?')">
                                                    Delete
                                                </button>
                                            </form>
                                            
                                            <button type="button" class="btn btn-outline btn-small mark-sold-btn" 
                                                    data-item-id="<%= item.getItemId() %>"
                                                    data-item-name="<%= item.getItemName() %>">
                                                Mark Sold
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <%
                                        }
                                    } else {
                                %>
                                <div class="no-items" style="grid-column: 1 / -1;">
                                    <i class="fas fa-box-open"></i>
                                    <h3>No Active Listings</h3>
                                    <p>You haven't listed any items for sale yet.</p>
                                    <a href="sell-item.jsp" class="btn btn-primary">Sell Your First Item</a>
                                </div>
                                <%
                                    }
                                %>
                                
                                <!-- Add New Listing Card -->
                                <div class="item-card" style="border-style: dashed; border-color: var(--medium-gray); background-color: var(--light-gray); display: flex; align-items: center; justify-content: center;">
                                    <a href="sell-item.jsp" style="text-decoration: none; color: var(--dark-gray); text-align: center; padding: 40px;">
                                        <i class="fas fa-plus-circle fa-3x" style="color: var(--primary-maroon); margin-bottom: 15px;"></i>
                                        <div style="font-weight: 600; color: var(--primary-maroon);">Add New Listing</div>
                                    </a>
                                </div>
                            </div>
                        </div>
                        
                        <!-- SOLD ITEMS TAB -->
                        <div id="sold" class="tab-content">
                            <h3 class="section-title"><i class="fas fa-check-circle"></i> Sold Items</h3>
                            
                            <div class="listings-grid">
                                <%
                                    if (!soldItems.isEmpty()) {
                                        for (Item item : soldItems) {
                                %>
                                <div class="item-card">
                                    <div class="item-image">
                                        <div class="item-status" style="background-color: var(--dark-gray);">Sold</div>
                                        <i class="fas fa-box fa-3x" style="color: #800000;"></i>
                                    </div>
                                    <div class="item-details">
                                        <div class="item-title"><%= item.getItemName() %></div>
                                        <div class="item-price">RM<%= String.format("%.2f", item.getPrice()) %></div>
                                        <%
                                            String dateActioned = "N/A";
                                            if (item.getDateActioned() != null) {
                                                dateActioned = item.getDateActioned().toString();
                                            }
                                        %>
                                        <p>Sold on <%= dateActioned %></p>
                                        <div class="item-actions">
                                            <button class="btn btn-outline btn-small" disabled>Relist</button>
                                            <form action="DeleteItemServlet" method="POST" style="display: inline;">
                                                <input type="hidden" name="itemId" value="<%= item.getItemId() %>">
                                                <button type="submit" class="btn btn-outline btn-small delete-btn" 
                                                        onclick="return confirm('Are you sure you want to delete this sold item?')">
                                                    Delete
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                                <%
                                        }
                                    } else {
                                %>
                                <div class="no-items" style="grid-column: 1 / -1;">
                                    <i class="fas fa-dollar-sign"></i>
                                    <h3>No Sold Items</h3>
                                    <p>You haven't sold any items yet.</p>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                        
                        <!-- MY PURCHASES TAB -->
                        <div id="purchases" class="tab-content">
                            <h3 class="section-title"><i class="fas fa-shopping-bag"></i> My Purchases</h3>
                            
                            <div class="listings-grid">
                                <%
                                    try {
                                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                                        Connection conn2 = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                                        
                                        // Get purchased items
                                        List<Item> purchasedItemsList = new ArrayList<Item>();
                                        String purchaseQuery = "SELECT i.* FROM ITEMS i " +
                                                             "INNER JOIN TRANSACTIONS t ON i.ITEM_ID = t.ITEM_ID " +
                                                             "WHERE t.BUYER_ID = ? AND i.STATUS = 'sold' " +
                                                             "ORDER BY t.TRANSACTION_DATE DESC";
                                        
                                        try {
                                            PreparedStatement purchaseStmt = conn2.prepareStatement(purchaseQuery);
                                            purchaseStmt.setInt(1, userIdSession);
                                            ResultSet purchaseRs = purchaseStmt.executeQuery();
                                            
                                            while (purchaseRs.next()) {
                                                Item item = new Item();
                                                item.setItemId(purchaseRs.getInt("ITEM_ID"));
                                                item.setItemName(purchaseRs.getString("ITEM_NAME"));
                                                item.setDescription(purchaseRs.getString("DESCRIPTION"));
                                                item.setPrice(purchaseRs.getDouble("PRICE"));
                                                item.setStatus(purchaseRs.getString("STATUS"));
                                                item.setUserId(purchaseRs.getInt("USER_ID"));
                                                item.setCategoryId(purchaseRs.getInt("CATEGORY_ID"));
                                                item.setDateSubmitted(purchaseRs.getTimestamp("DATE_SUBMITTED"));
                                                item.setDateActioned(purchaseRs.getTimestamp("DATE_ACTIONED"));
                                                item.setCondition(purchaseRs.getString("CONDITION"));
                                                item.setBrand(purchaseRs.getString("BRAND"));
                                                item.setNegotiable(purchaseRs.getString("NEGOTIABLE"));
                                                item.setMeetupLocation(purchaseRs.getString("MEETUP_LOCATION"));
                                                purchasedItemsList.add(item);
                                            }
                                            purchaseStmt.close();
                                        } catch (SQLException e) {
                                            // TRANSACTIONS table might not exist, show empty state
                                        }
                                        
                                        conn2.close();
                                        
                                        if (!purchasedItemsList.isEmpty()) {
                                            for (Item item : purchasedItemsList) {
                                %>
                                <a href="item-detail.jsp?id=<%= item.getItemId() %>" class="item-card">
                                    <div class="item-image">
                                        <div class="item-status" style="background-color: #28a745;">Purchased</div>
                                        <i class="fas fa-box fa-3x" style="color: #800000;"></i>
                                    </div>
                                    <div class="item-details">
                                        <div class="item-title"><%= item.getItemName() %></div>
                                        <div class="item-price">RM<%= String.format("%.2f", item.getPrice()) %></div>
                                        <p>Purchased from Seller</p>
                                        <div class="item-actions">
                                            <button class="btn btn-outline btn-small">Contact Seller</button>
                                        </div>
                                    </div>
                                </a>
                                <%
                                            }
                                        } else {
                                %>
                                <div class="no-items" style="grid-column: 1 / -1;">
                                    <i class="fas fa-shopping-cart"></i>
                                    <h3>No Purchases</h3>
                                    <p>You haven't purchased any items yet.</p>
                                </div>
                                <%
                                        }
                                    } catch (Exception e) {
                                %>
                                <div class="no-items" style="grid-column: 1 / -1;">
                                    <i class="fas fa-shopping-cart"></i>
                                    <h3>No Purchases</h3>
                                    <p>You haven't purchased any items yet.</p>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                        
                        <!-- ACCOUNT SETTINGS TAB -->
                        <div id="settings" class="tab-content">
                            <h3 class="section-title"><i class="fas fa-cog"></i> Account Settings</h3>
                            
                            <form class="settings-form" action="UpdateProfileServlet" method="POST">
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="fullName">Full Name</label>
                                        <input type="text" id="fullName" name="fullName" 
                                               value="<%= fullName != null ? fullName : "" %>" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="email">Email Address</label>
                                        <input type="email" id="email" name="email" 
                                               value="<%= email != null ? email : "" %>" required>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="phoneNumber">Phone Number</label>
                                    <input type="tel" id="phoneNumber" name="phoneNumber" 
                                           value="<%= phoneNumber != null && !phoneNumber.equals("null") ? phoneNumber : "" %>">
                                </div>
                                
                                <div style="display: flex; justify-content: flex-end; gap: 15px; margin-top: 30px;">
                                    <button type="button" class="btn btn-outline" onclick="location.reload()">Cancel</button>
                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Mark Sold Modal -->
    <div id="markSoldModal" class="modal">
        <div class="modal-content">
            <h3 style="color: var(--primary-maroon); margin-bottom: 20px;">Mark Item as Sold</h3>
            
            <form id="markSoldForm" action="MarkSoldServlet" method="POST">
                <input type="hidden" id="modalItemId" name="itemId">
                
                <div class="form-group">
                    <label for="buyerUsername">Buyer's Username</label>
                    <input type="text" id="buyerUsername" name="buyerUsername" 
                           placeholder="Enter buyer's username" required>
                    <small style="color: var(--dark-gray); font-size: 12px;">
                        Enter the username of the person who bought this item.
                    </small>
                </div>
                
                <div class="form-group">
                    <label for="itemName">Item Name</label>
                    <input type="text" id="modalItemName" readonly 
                           style="background-color: var(--light-gray);">
                </div>
                
                <div style="display: flex; justify-content: flex-end; gap: 15px; margin-top: 25px;">
                    <button type="button" class="btn btn-outline" onclick="closeModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary">Confirm Sale</button>
                </div>
            </form>
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
                        <li><a href="categories.jsp#books">Textbooks</a></li>
                        <li><a href="categories.jsp#electronics">Electronics</a></li>
                        <li><a href="categories.jsp#uniforms">Uniforms</a></li>
                        <li><a href="categories.jsp#other">Other Items</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h3>Contact</h3>
                    <ul>
                        <li><i class="fas fa-envelope"></i> support@campusmarket.edu</li>
                        <li><i class="fas fa-phone"></i> (555) 123-4567</li>
                        <li><i class="fas fa-map-marker-alt"></i> Student Union Building, Room 205</li>
                    </ul>
                </div>
            </div>
            
            <div class="copyright">
                &copy; 2023 Campus Marketplace. Designed for students, by students.
            </div>
        </div>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Tab switching
            const tabs = document.querySelectorAll('.tab');
            const tabContents = document.querySelectorAll('.tab-content');
            
            tabs.forEach(tab => {
                tab.addEventListener('click', function() {
                    const tabId = this.getAttribute('data-tab');
                    
                    // Remove active class from all tabs and contents
                    tabs.forEach(t => t.classList.remove('active'));
                    tabContents.forEach(content => content.classList.remove('active'));
                    
                    // Add active class to clicked tab and corresponding content
                    this.classList.add('active');
                    document.getElementById(tabId).classList.add('active');
                });
            });
            
            // Add click handlers for mark sold buttons
            document.querySelectorAll('.mark-sold-btn').forEach(button => {
                button.addEventListener('click', function() {
                    const itemId = this.getAttribute('data-item-id');
                    const itemName = this.getAttribute('data-item-name');
                    showMarkSoldModal(itemId, itemName);
                });
            });
        });
        
        function showMarkSoldModal(itemId, itemName) {
            document.getElementById('modalItemId').value = itemId;
            document.getElementById('modalItemName').value = itemName;
            document.getElementById('markSoldModal').style.display = 'block';
        }
        
        function closeModal() {
            document.getElementById('markSoldModal').style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById('markSoldModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>