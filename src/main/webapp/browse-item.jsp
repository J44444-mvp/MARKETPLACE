<%@page import="java.sql.*"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campus Marketplace | Browse Items</title>
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
        
        .main-content {
            padding: 30px 0;
        }
        
        .page-header {
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--medium-gray);
        }
        
        .page-title {
            color: var(--primary-maroon);
            font-size: 28px;
            margin-bottom: 5px;
        }
        
        .page-subtitle {
            color: var(--dark-gray);
            font-size: 16px;
        }
        
        .search-bar-container {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--medium-gray);
            margin-bottom: 30px;
        }
        
        .search-bar {
            display: flex;
            width: 100%;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-radius: 50px;
            overflow: hidden;
        }
        
        .search-bar input {
            flex: 1;
            padding: 15px 25px;
            border: none;
            font-size: 16px;
            border: 1px solid var(--medium-gray);
        }
        
        .search-bar button {
            background-color: var(--primary-maroon);
            color: white;
            border: none;
            padding: 0 35px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
        }
        
        .listings-container {
            display: flex;
            gap: 30px;
        }
        
        .filters-sidebar {
            width: 250px;
            flex-shrink: 0;
        }
        
        .filters-card {
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--medium-gray);
            margin-bottom: 20px;
        }
        
        .filter-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--primary-maroon);
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid var(--medium-gray);
        }
        
        .filter-group {
            margin-bottom: 20px;
        }
        
        .filter-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .filter-group select, .filter-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--medium-gray);
            border-radius: 4px;
            font-size: 14px;
        }
        
        .filter-options {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .filter-option {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .filter-option input {
            width: auto;
        }
        
        .listings-main {
            flex: 1;
        }
        
        .listings-tools {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .sort-options select {
            padding: 10px;
            border: 1px solid var(--medium-gray);
            border-radius: 4px;
            background-color: white;
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
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .item-status-available {
            background-color: #28a745;
        }
        
        .item-status-sold {
            background-color: #dc3545;
        }
        
        .item-status-pending {
            background-color: #ffc107;
            color: #000;
        }
        
        .item-status-approved {
            background-color: #28a745;
        }
        
        .item-status-rejected {
            background-color: #dc3545;
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
        
        .item-seller {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
        }
        
        .seller-avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: var(--medium-gray);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-maroon);
            font-size: 14px;
        }
        
        .seller-name {
            font-size: 14px;
            color: var(--dark-gray);
        }
        
        .pagination {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 30px;
        }
        
        .pagination-btn {
            padding: 10px 15px;
            background-color: white;
            border: 1px solid var(--medium-gray);
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .pagination-btn:hover {
            background-color: var(--primary-maroon);
            color: white;
            border-color: var(--primary-maroon);
        }
        
        .pagination-btn.active {
            background-color: var(--primary-maroon);
            color: white;
            border-color: var(--primary-maroon);
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
        
        .no-items {
            text-align: center;
            padding: 50px;
            background-color: white;
            border-radius: 8px;
            border: 1px solid var(--medium-gray);
        }
        
        .no-items i {
            font-size: 48px;
            color: var(--medium-gray);
            margin-bottom: 20px;
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
            
            .search-bar {
                flex-direction: column;
                border-radius: 8px;
            }
            
            .search-bar input, .search-bar button {
                width: 100%;
                border-radius: 0;
                padding: 15px;
            }
            
            .listings-container {
                flex-direction: column;
            }
            
            .filters-sidebar {
                width: 100%;
            }
            
            .listings-tools {
                flex-direction: column;
                gap: 15px;
                align-items: flex-start;
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
                        <li><a href="browse-item.jsp" class="active">Browse</a></li>
                        <li><a href="sell-item.jsp">Sell Item</a></li>
                        <li><a href="categories.jsp">Categories</a></li>
                    </ul>
                </nav>
                
                <div class="user-actions">
                    <%
                        String userName = (String) session.getAttribute("user");
                    %>
                    <c:choose>
                        <c:when test="<%= userName != null && !userName.isEmpty() %>">
                            <span class="user-greeting">Hello, <%= userName %>!</span>
                            <a href="profile.jsp" class="user-icon">
                                <i class="fas fa-user"></i>
                            </a>
                            <a href="LogoutServlet" class="btn btn-outline logout-btn">Log Out</a>
                        </c:when>
                        <c:otherwise>
                            <a href="profile.jsp" class="user-icon">
                                <i class="fas fa-user"></i>
                            </a>
                            <a href="login.jsp" class="btn btn-outline">Log In</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </header>

    <div class="main-content">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Browse All Items</h1>
                <p class="page-subtitle">Find textbooks, gadgets, uniforms, and more from students on campus</p>
            </div>
            
            <!-- SEARCH BAR SECTION -->
            <div class="search-bar-container">
                <!-- FIXED: Use SearchServlet instead of ItemServlet -->
                <form action="SearchServlet" method="GET" class="search-bar">
                    <input type="text" name="query" placeholder="Search for books, electronics, uniforms..." 
                           value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
                    <button type="submit"><i class="fas fa-search"></i> Search</button>
                </form>
            </div>
            
            <div class="listings-container">
                <div class="filters-sidebar">
                    <form action="browse-item.jsp" method="GET" class="filters-card">
                        <h3 class="filter-title">Filters</h3>
                        
                        <div class="filter-group">
                            <label for="category">Category</label>
                            <select id="category" name="category">
                                <option value="">All Categories</option>
                                <option value="textbooks" <%= "textbooks".equals(request.getParameter("category")) ? "selected" : "" %>>Textbooks</option>
                                <option value="electronics" <%= "electronics".equals(request.getParameter("category")) ? "selected" : "" %>>Electronics</option>
                                <option value="uniforms" <%= "uniforms".equals(request.getParameter("category")) ? "selected" : "" %>>Uniforms</option>
                                <option value="other" <%= "other".equals(request.getParameter("category")) ? "selected" : "" %>>Other Items</option>
                            </select>
                        </div>
                        
                        <div class="filter-group">
                            <label for="price-range">Price Range</label>
                            <div style="display: flex; gap: 10px; align-items: center;">
                                <input type="number" name="minPrice" placeholder="Min" style="width: 45%;" 
                                       value="<%= request.getParameter("minPrice") != null ? request.getParameter("minPrice") : "" %>">
                                <span>to</span>
                                <input type="number" name="maxPrice" placeholder="Max" style="width: 45%;" 
                                       value="<%= request.getParameter("maxPrice") != null ? request.getParameter("maxPrice") : "" %>">
                            </div>
                        </div>
                        
                        <div class="filter-group">
                            <label>Status</label>
                            <div class="filter-options">
                                <div class="filter-option">
                                    <input type="checkbox" id="status-available" name="status" value="available" 
                                           <%= "available".equals(request.getParameter("status")) || request.getParameter("status") == null ? "checked" : "" %>>
                                    <label for="status-available">Available</label>
                                </div>
                                <div class="filter-option">
                                    <input type="checkbox" id="status-sold" name="status" value="sold"
                                           <%= "sold".equals(request.getParameter("status")) ? "checked" : "" %>>
                                    <label for="status-sold">Sold</label>
                                </div>
                            </div>
                        </div>
                        
                        <button class="btn btn-primary" type="submit" style="width: 100%;">Apply Filters</button>
                    </form>
                </div>
                
                <div class="listings-main">
                    <div class="listings-tools">
                        <%
                            int totalItems = 0;
                            try {
                                // Count total approved items
                                Class.forName("org.apache.derby.jdbc.ClientDriver");
                                Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                                PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM ITEMS WHERE status = 'APPROVED'");
                                ResultSet rs = ps.executeQuery();
                                if(rs.next()) {
                                    totalItems = rs.getInt(1);
                                }
                                conn.close();
                            } catch(Exception e) {
                                e.printStackTrace();
                            }
                        %>
                        <div>
                            <strong><%= totalItems %></strong> items found
                        </div>
                        <div class="sort-options">
                            <form action="browse-item.jsp" method="GET" style="display: inline;">
                                <input type="hidden" name="category" value="<%= request.getParameter("category") != null ? request.getParameter("category") : "" %>">
                                <input type="hidden" name="query" value="<%= request.getParameter("query") != null ? request.getParameter("query") : "" %>">
                                <label for="sort">Sort by: </label>
                                <select id="sort" name="sortBy" onchange="this.form.submit()">
                                    <option value="newest" <%= "newest".equals(request.getParameter("sortBy")) || request.getParameter("sortBy") == null ? "selected" : "" %>>Newest First</option>
                                    <option value="price-low" <%= "price-low".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Price: Low to High</option>
                                    <option value="price-high" <%= "price-high".equals(request.getParameter("sortBy")) ? "selected" : "" %>>Price: High to Low</option>
                                </select>
                            </form>
                        </div>
                    </div>
                    
                    <%
                        String category = request.getParameter("category");
                        String query = request.getParameter("query");
                        String minPrice = request.getParameter("minPrice");
                        String maxPrice = request.getParameter("maxPrice");
                        String status = request.getParameter("status");
                        String sortBy = request.getParameter("sortBy");
                        
                        boolean hasItems = false;
                        
                        try {
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                            
                            // Build SQL query based on filters
                            StringBuilder sql = new StringBuilder(
                                "SELECT i.item_id, i.item_name, i.description, i.price, i.status, " +
                                "i.image_url, u.full_name, u.username " +
                                "FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id " +
                                "WHERE i.status = 'APPROVED' "
                            );
                            
                            // Add category filter
                            if (category != null && !category.isEmpty()) {
                                sql.append("AND (LOWER(i.item_name) LIKE ? OR LOWER(i.description) LIKE ?) ");
                            }
                            
                            // Add price range filter
                            if (minPrice != null && !minPrice.isEmpty()) {
                                sql.append("AND i.price >= ? ");
                            }
                            if (maxPrice != null && !maxPrice.isEmpty()) {
                                sql.append("AND i.price <= ? ");
                            }
                            
                            // Add status filter
                            if (status != null && !status.isEmpty()) {
                                if ("sold".equals(status)) {
                                    sql.append("AND i.status = 'SOLD' ");
                                } else {
                                    sql.append("AND i.status = 'AVAILABLE' ");
                                }
                            } else {
                                sql.append("AND i.status = 'AVAILABLE' ");
                            }
                            
                            // Add sorting
                            if (sortBy != null) {
                                if ("price-low".equals(sortBy)) {
                                    sql.append("ORDER BY i.price ASC");
                                } else if ("price-high".equals(sortBy)) {
                                    sql.append("ORDER BY i.price DESC");
                                } else {
                                    sql.append("ORDER BY i.date_submitted DESC");
                                }
                            } else {
                                sql.append("ORDER BY i.date_submitted DESC");
                            }
                            
                            PreparedStatement ps = conn.prepareStatement(sql.toString());
                            int paramIndex = 1;
                            
                            // Set parameters
                            if (category != null && !category.isEmpty()) {
                                String categoryTerm = "%" + category.toLowerCase() + "%";
                                ps.setString(paramIndex++, categoryTerm);
                                ps.setString(paramIndex++, categoryTerm);
                            }
                            
                            if (minPrice != null && !minPrice.isEmpty()) {
                                ps.setDouble(paramIndex++, Double.parseDouble(minPrice));
                            }
                            
                            if (maxPrice != null && !maxPrice.isEmpty()) {
                                ps.setDouble(paramIndex++, Double.parseDouble(maxPrice));
                            }
                            
                            ResultSet rs = ps.executeQuery();
                            hasItems = rs.next();
                            
                            if (hasItems) {
                    %>
                    <div class="listings-grid">
                        <%
                            // Reset cursor and loop through results
                            rs = ps.executeQuery();
                            while(rs.next()) {
                                String itemStatus = rs.getString("status");
                                String statusClass = "item-status-" + itemStatus.toLowerCase();
                        %>
                        <a href="item-detail.jsp?id=<%= rs.getInt("item_id") %>" class="item-card">
                            <div class="item-image">
                                <%
                                    String imageUrl = rs.getString("image_url");
                                    if (imageUrl != null && !imageUrl.isEmpty()) {
                                %>
                                <img src="uploads/<%= imageUrl %>" alt="<%= rs.getString("item_name") %>" 
                                     style="width: 100%; height: 100%; object-fit: cover;">
                                <%
                                    } else {
                                %>
                                <i class="fas fa-tag fa-3x" style="color: #800000;"></i>
                                <%
                                    }
                                %>
                                <div class="item-status <%= statusClass %>">
                                    <%= itemStatus %>
                                </div>
                            </div>
                            <div class="item-details">
                                <div class="item-title"><%= rs.getString("item_name") %></div>
                                <div class="item-price">$<%= rs.getDouble("price") %></div>
                                <div class="item-seller">
                                    <div class="seller-avatar">
                                        <%
                                            String sellerName = rs.getString("full_name");
                                            if (sellerName != null && sellerName.length() >= 2) {
                                                out.print(sellerName.substring(0, 2).toUpperCase());
                                            } else {
                                                out.print("SU");
                                            }
                                        %>
                                    </div>
                                    <div class="seller-name">
                                        <%= sellerName != null ? sellerName : "Unknown Seller" %>
                                    </div>
                                </div>
                                <p>
                                    <%
                                        String description = rs.getString("description");
                                        if (description != null && description.length() > 100) {
                                            out.print(description.substring(0, 100) + "...");
                                        } else if (description != null) {
                                            out.print(description);
                                        } else {
                                            out.print("No description available.");
                                        }
                                    %>
                                </p>
                            </div>
                        </a>
                        <%
                            }
                        %>
                    </div>
                    <%
                            } else {
                    %>
                    <div class="no-items">
                        <i class="fas fa-search"></i>
                        <h3>No items found</h3>
                        <p>Try adjusting your search or filter criteria.</p>
                        <a href="browse-item.jsp" class="btn btn-primary">View All Items</a>
                    </div>
                    <%
                            }
                            conn.close();
                        } catch(Exception e) {
                            e.printStackTrace();
                    %>
                    <div class="no-items">
                        <i class="fas fa-exclamation-triangle"></i>
                        <h3>Error loading items</h3>
                        <p>Please try again later.</p>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
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
                        <li><i class="fas fa-envelope"></i> support@campusmarket.edu</li>
                        <li><i class="fas fa-phone"></i> (555) 123-4567</li>
                        <li><i class="fas fa-map-marker-alt"></i> Student Union Building, Room 205</li>
                    </ul>
                </div>
            </div>
            
            <div class="copyright">
                &copy; <%= java.time.Year.now().getValue() %> Campus Marketplace. Designed for students, by students.
            </div>
        </div>
    </footer>
    
    <script>
        // Auto-submit filter form when select changes
        document.getElementById('category').addEventListener('change', function() {
            this.form.submit();
        });
        
        // Auto-submit sort form when select changes
        document.getElementById('sort').addEventListener('change', function() {
            this.form.submit();
        });
        
        // Preserve filter values on page load
        document.addEventListener('DOMContentLoaded', function() {
            // Set active category in dropdown
            const category = "<%= request.getParameter("category") != null ? request.getParameter("category") : "" %>";
            if (category) {
                document.getElementById('category').value = category;
            }
            
            // Set active sort in dropdown
            const sortBy = "<%= request.getParameter("sortBy") != null ? request.getParameter("sortBy") : "" %>";
            if (sortBy) {
                document.getElementById('sort').value = sortBy;
            }
        });
    </script>
</body>
</html>