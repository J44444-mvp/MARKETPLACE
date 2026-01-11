<%@page import="java.sql.*"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
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
        
        .item-category {
            font-size: 12px;
            color: #666;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 5px;
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
        
        .debug-info {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
            font-size: 14px;
            color: #6c757d;
        }
        
        .debug-info h4 {
            color: #800000;
            margin-bottom: 10px;
            font-size: 16px;
        }
        
        .search-info {
            background-color: #e7f3ff;
            border: 1px solid #b3d7ff;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
            color: #0066cc;
        }
        
        .search-info i {
            margin-right: 8px;
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
            
            <!-- Search Info Banner -->
            <%
                String searchQuery = request.getParameter("query");
                String searchCategory = request.getParameter("category");
                String searchQueryFromServlet = (String) request.getAttribute("searchQuery");
                String searchCategoryFromServlet = (String) request.getAttribute("searchCategory");
                
                // Use servlet data if available
                if (searchQueryFromServlet != null) {
                    searchQuery = searchQueryFromServlet;
                }
                if (searchCategoryFromServlet != null) {
                    searchCategory = searchCategoryFromServlet;
                }
                
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            %>
            <div class="search-info">
                <i class="fas fa-search"></i>
                <strong>Search Results for:</strong> "<%= searchQuery %>"
                <% if (searchCategory != null && !searchCategory.trim().isEmpty()) { %>
                in <strong><%= searchCategory %></strong> category
                <% } %>
                <a href="browse-item.jsp" style="float: right; font-size: 14px; color: #800000; text-decoration: none;">
                    <i class="fas fa-times"></i> Clear Search
                </a>
            </div>
            <% } %>
            
            <!-- DEBUG INFO SECTION (You can remove this after testing) -->
            <%
                try {
                    Class.forName("org.apache.derby.jdbc.ClientDriver");
                    Connection debugConn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                    Statement debugStmt = debugConn.createStatement();
                    
                    ResultSet debugRs = debugStmt.executeQuery(
                        "SELECT status, COUNT(*) as count FROM ITEMS GROUP BY status"
                    );
            %>
            <div class="debug-info">
                <h4><i class="fas fa-info-circle"></i> Database Status Report</h4>
                <%
                    while(debugRs.next()) {
                        String statusName = debugRs.getString("status");
                        int count = debugRs.getInt("count");
                %>
                <p><strong><%= statusName %>:</strong> <%= count %> items</p>
                <%
                    }
                    
                    // Count items that should show
                    ResultSet showRs = debugStmt.executeQuery(
                        "SELECT COUNT(*) as showable FROM ITEMS WHERE status IN ('APPROVED', 'AVAILABLE')"
                    );
                    if(showRs.next()) {
                %>
                <p style="margin-top: 10px; padding-top: 10px; border-top: 1px solid #ddd;">
                    <strong>Items visible in browse:</strong> <%= showRs.getInt("showable") %>
                </p>
                <%
                    }
                    showRs.close();
                    debugRs.close();
                    debugStmt.close();
                    debugConn.close();
                } catch(Exception e) {
                    // Silently continue if debug fails
                }
            %>
            </div>
            
            <!-- SEARCH BAR SECTION -->
            <div class="search-bar-container">
                <form action="browse-item.jsp" method="GET" class="search-bar">
                    <input type="text" name="query" placeholder="Search for books, electronics, uniforms..." 
                           value="<%= searchQuery != null ? searchQuery : "" %>">
                    <button type="submit"><i class="fas fa-search"></i> Search</button>
                </form>
            </div>
            
            <div class="listings-container">
                <div class="filters-sidebar">
                    <form action="browse-item.jsp" method="GET" class="filters-card">
                        <h3 class="filter-title">Filters</h3>
                        
                        <input type="hidden" name="query" value="<%= searchQuery != null ? searchQuery : "" %>">
                        
                        <div class="filter-group">
                            <label for="category">Category</label>
                            <select id="category" name="category">
                                <option value="">All Categories</option>
                                <option value="textbooks" <%= "textbooks".equals(searchCategory) ? "selected" : "" %>>Textbooks</option>
                                <option value="electronics" <%= "electronics".equals(searchCategory) ? "selected" : "" %>>Electronics</option>
                                <option value="uniforms" <%= "uniforms".equals(searchCategory) ? "selected" : "" %>>Uniforms</option>
                                <option value="other" <%= "other".equals(searchCategory) ? "selected" : "" %>>Other Items</option>
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
                            <label>Status Filter</label>
                            <div class="filter-options">
                                <div class="filter-option">
                                    <input type="checkbox" id="status-available" name="status" value="available" 
                                           <%= "available".equals(request.getParameter("status")) || request.getParameter("status") == null ? "checked" : "" %>>
                                    <label for="status-available">Available Items</label>
                                </div>
                                <div class="filter-option">
                                    <input type="checkbox" id="status-sold" name="status" value="sold"
                                           <%= "sold".equals(request.getParameter("status")) ? "checked" : "" %>>
                                    <label for="status-sold">Sold Items</label>
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
                                // Count total approved AND available items
                                Class.forName("org.apache.derby.jdbc.ClientDriver");
                                Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                                PreparedStatement ps = conn.prepareStatement(
                                    "SELECT COUNT(*) FROM ITEMS WHERE status IN ('APPROVED', 'AVAILABLE')"
                                );
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
                            <strong><%= totalItems %></strong> items available
                        </div>
                        <div class="sort-options">
                            <form action="browse-item.jsp" method="GET" style="display: inline;">
                                <input type="hidden" name="category" value="<%= searchCategory != null ? searchCategory : "" %>">
                                <input type="hidden" name="query" value="<%= searchQuery != null ? searchQuery : "" %>">
                                <input type="hidden" name="minPrice" value="<%= request.getParameter("minPrice") != null ? request.getParameter("minPrice") : "" %>">
                                <input type="hidden" name="maxPrice" value="<%= request.getParameter("maxPrice") != null ? request.getParameter("maxPrice") : "" %>">
                                <input type="hidden" name="status" value="<%= request.getParameter("status") != null ? request.getParameter("status") : "" %>">
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
                        String minPrice = request.getParameter("minPrice");
                        String maxPrice = request.getParameter("maxPrice");
                        String statusFilter = request.getParameter("status");
                        String sortBy = request.getParameter("sortBy");
                        
                        boolean hasItems = false;
                        int itemsDisplayed = 0;
                        
                        // Check if we have search results from SearchServlet
                        List<?> searchResults = (List<?>) request.getAttribute("searchResults");
                        boolean fromServlet = searchResults != null && !searchResults.isEmpty();
                        
                        if (fromServlet) {
                            // Display search results from SearchServlet
                            hasItems = true;
                            itemsDisplayed = searchResults.size();
                    %>
                    <div class="listings-grid">
                        <%
                            for (Object obj : searchResults) {
                                try {
                                    // Using reflection to access Item class from SearchServlet
                                    Class<?> itemClass = obj.getClass();
                                    java.lang.reflect.Method getId = itemClass.getMethod("getId");
                                    java.lang.reflect.Method getName = itemClass.getMethod("getName");
                                    java.lang.reflect.Method getDescription = itemClass.getMethod("getDescription");
                                    java.lang.reflect.Method getPrice = itemClass.getMethod("getPrice");
                                    java.lang.reflect.Method getStatus = itemClass.getMethod("getStatus");
                                    java.lang.reflect.Method getImageUrl = itemClass.getMethod("getImageUrl");
                                    java.lang.reflect.Method getSellerName = itemClass.getMethod("getSellerName");
                                    
                                    int itemId = (Integer) getId.invoke(obj);
                                    String itemName = (String) getName.invoke(obj);
                                    String description = (String) getDescription.invoke(obj);
                                    double price = (Double) getPrice.invoke(obj);
                                    String itemStatus = (String) getStatus.invoke(obj);
                                    String imageUrl = (String) getImageUrl.invoke(obj);
                                    String sellerName = (String) getSellerName.invoke(obj);
                                    
                                    String statusClass = "item-status-" + itemStatus.toLowerCase();
                        %>
                        <a href="item-detail.jsp?id=<%= itemId %>" class="item-card">
                            <div class="item-image">
                                <%
                                    if (imageUrl != null && !imageUrl.isEmpty()) {
                                %>
                                <img src="uploads/<%= imageUrl %>" alt="<%= itemName %>" 
                                     style="width: 100%; height: 100%; object-fit: cover;"
                                     onerror="this.onerror=null; this.src='https://via.placeholder.com/280x180/800000/ffffff?text=No+Image'">
                                <%
                                    } else {
                                %>
                                <i class="fas fa-tag fa-3x" style="color: #800000;"></i>
                                <%
                                    }
                                %>
                                <div class="item-status <%= statusClass %>">
                                    <%= "APPROVED".equals(itemStatus) ? "Available" : itemStatus %>
                                </div>
                            </div>
                            <div class="item-details">
                                <div class="item-title"><%= itemName %></div>
                                <div class="item-price">RM <%= String.format("%.2f", price) %></div>
                                <div class="item-seller">
                                    <div class="seller-avatar">
                                        <%
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
                                <p style="font-size: 14px; color: #666; line-height: 1.4;">
                                    <%
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
                                } catch (Exception e) {
                                    e.printStackTrace();
                                }
                            }
                        %>
                    </div>
                    <div style="margin-top: 20px; padding: 10px; background: #f8f9fa; border-radius: 5px; text-align: center;">
                        <p style="color: #666; font-size: 14px;">
                            Showing <strong><%= itemsDisplayed %></strong> search results
                        </p>
                    </div>
                    <%
                        } else {
                            // Original database query for when page loads directly
                            try {
                                Class.forName("org.apache.derby.jdbc.ClientDriver");
                                Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                                
                                // Build SQL query with proper category joining
                                StringBuilder sql = new StringBuilder(
                                    "SELECT i.item_id, i.item_name, i.description, i.price, i.status, " +
                                    "i.image_url, u.full_name, u.username, i.date_submitted, c.category_name " +
                                    "FROM ITEMS i " +
                                    "JOIN USERS u ON i.user_id = u.user_id " +
                                    "LEFT JOIN CATEGORIES c ON i.category_id = c.category_id " +
                                    "WHERE (i.status = 'APPROVED' OR i.status = 'AVAILABLE') "
                                );
                                
                                // Add search query if present
                                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                                    sql.append("AND (LOWER(i.item_name) LIKE ? OR LOWER(i.description) LIKE ?) ");
                                }
                                
                                // Add category filter - FIXED
                                if (searchCategory != null && !searchCategory.trim().isEmpty()) {
                                    // Map category name to category_id
                                    sql.append("AND i.category_id = ? ");
                                }
                                
                                // Add price range filter
                                if (minPrice != null && !minPrice.trim().isEmpty()) {
                                    sql.append("AND i.price >= ? ");
                                }
                                if (maxPrice != null && !maxPrice.trim().isEmpty()) {
                                    sql.append("AND i.price <= ? ");
                                }
                                
                                // Add status filter from checkbox
                                if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                                    if ("sold".equals(statusFilter)) {
                                        sql.append("AND i.status = 'SOLD' ");
                                    }
                                    // "available" is already covered by the default WHERE clause
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
                                
                                // Set search query parameter
                                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                                    String searchTerm = "%" + searchQuery.toLowerCase() + "%";
                                    ps.setString(paramIndex++, searchTerm);
                                    ps.setString(paramIndex++, searchTerm);
                                }
                                
                                // Set category parameter - FIXED
                                if (searchCategory != null && !searchCategory.trim().isEmpty()) {
                                    // Map form values to category_id
                                    int categoryId = 0;
                                    switch(searchCategory.toLowerCase()) {
                                        case "textbooks":
                                            categoryId = 1;
                                            break;
                                        case "electronics":
                                            categoryId = 2;
                                            break;
                                        case "uniforms":
                                            categoryId = 3;
                                            break;
                                        case "other":
                                            categoryId = 4;
                                            break;
                                    }
                                    ps.setInt(paramIndex++, categoryId);
                                }
                                
                                // Set price parameters
                                if (minPrice != null && !minPrice.trim().isEmpty()) {
                                    ps.setDouble(paramIndex++, Double.parseDouble(minPrice));
                                }
                                if (maxPrice != null && !maxPrice.trim().isEmpty()) {
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
                                itemsDisplayed++;
                                String itemStatus = rs.getString("status");
                                String statusClass = "item-status-" + itemStatus.toLowerCase();
                                String categoryName = rs.getString("category_name");
                        %>
                        <a href="item-detail.jsp?id=<%= rs.getInt("item_id") %>" class="item-card">
                            <div class="item-image">
                                <%
                                    String imageUrl = rs.getString("image_url");
                                    if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                                %>
                                <img src="uploads/<%= imageUrl %>" alt="<%= rs.getString("item_name") %>" 
                                     style="width: 100%; height: 100%; object-fit: cover;"
                                     onerror="this.onerror=null; this.src='https://via.placeholder.com/280x180/800000/ffffff?text=No+Image'">
                                <%
                                    } else {
                                %>
                                <i class="fas fa-tag fa-3x" style="color: #800000;"></i>
                                <%
                                    }
                                %>
                                <div class="item-status <%= statusClass %>">
                                    <%= "APPROVED".equals(itemStatus) ? "Available" : itemStatus %>
                                </div>
                            </div>
                            <div class="item-details">
                                <div class="item-title"><%= rs.getString("item_name") %></div>
                                <div class="item-price">RM <%= String.format("%.2f", rs.getDouble("price")) %></div>
                                <div class="item-category">
                                    <i class="fas fa-tag"></i> <%= categoryName != null ? categoryName : "Uncategorized" %>
                                </div>
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
                                <p style="font-size: 14px; color: #666; line-height: 1.4;">
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
                    <div style="margin-top: 20px; padding: 10px; background: #f8f9fa; border-radius: 5px; text-align: center;">
                        <p style="color: #666; font-size: 14px;">
                            Showing <strong><%= itemsDisplayed %></strong> of <strong><%= totalItems %></strong> available items
                        </p>
                    </div>
                    <%
                                } else {
                    %>
                    <div class="no-items">
                        <i class="fas fa-search"></i>
                        <h3>No items found</h3>
                        <p>Try adjusting your search or filter criteria.</p>
                        <%
                            // Check if there are items but filtered out
                            Statement checkStmt = conn.createStatement();
                            ResultSet checkRs = checkStmt.executeQuery(
                                "SELECT COUNT(*) as total FROM ITEMS WHERE status IN ('APPROVED', 'AVAILABLE')"
                            );
                            if(checkRs.next() && checkRs.getInt("total") > 0) {
                        %>
                        <p style="color: #666; margin: 10px 0; font-size: 14px;">
                            <i class="fas fa-info-circle"></i> 
                            There are <%= checkRs.getInt("total") %> available items, but none match your filters.
                        </p>
                        <%
                            }
                            checkRs.close();
                            checkStmt.close();
                        %>
                        <a href="browse-item.jsp" class="btn btn-primary">Clear Filters</a>
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
                        <p style="color: #666; font-size: 12px; margin-top: 10px;">
                            Error: <%= e.getMessage() %>
                        </p>
                    </div>
                    <%
                            }
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
        document.addEventListener('DOMContentLoaded', function() {
            const categorySelect = document.getElementById('category');
            const sortSelect = document.getElementById('sort');
            
            if (categorySelect) {
                categorySelect.addEventListener('change', function() {
                    this.form.submit();
                });
            }
            
            if (sortSelect) {
                sortSelect.addEventListener('change', function() {
                    this.form.submit();
                });
            }
            
            // Preserve filter values on page load
            const category = "<%= searchCategory != null ? searchCategory : "" %>";
            if (category && categorySelect) {
                categorySelect.value = category;
            }
            
            const sortBy = "<%= request.getParameter("sortBy") != null ? request.getParameter("sortBy") : "" %>";
            if (sortBy && sortSelect) {
                sortSelect.value = sortBy;
            }
            
            // Set checkbox status
            const statusFilter = "<%= request.getParameter("status") != null ? request.getParameter("status") : "" %>";
            const availableCheckbox = document.getElementById('status-available');
            const soldCheckbox = document.getElementById('status-sold');
            
            if (availableCheckbox && soldCheckbox) {
                if (statusFilter === 'available') {
                    availableCheckbox.checked = true;
                    soldCheckbox.checked = false;
                } else if (statusFilter === 'sold') {
                    availableCheckbox.checked = false;
                    soldCheckbox.checked = true;
                } else if (statusFilter === '') {
                    availableCheckbox.checked = true;
                    soldCheckbox.checked = false;
                }
                
                // Handle checkbox behavior (mutually exclusive)
                availableCheckbox.addEventListener('change', function() {
                    if (this.checked) {
                        soldCheckbox.checked = false;
                    }
                });
                
                soldCheckbox.addEventListener('change', function() {
                    if (this.checked) {
                        availableCheckbox.checked = false;
                    }
                });
            }
        });
    </script>
</body>
</html>