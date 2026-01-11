<%@page import="java.sql.*"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campus Marketplace | Home</title>
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
        
        .hero {
            background: linear-gradient(rgba(255, 255, 255, 0.95), rgba(255, 255, 255, 0.95));
            padding: 60px 30px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 40px;
            border: 1px solid var(--medium-gray);
        }
        
        .hero h1 {
            font-size: 36px;
            color: var(--primary-maroon);
            margin-bottom: 15px;
        }
        
        .hero p {
            font-size: 18px;
            max-width: 700px;
            margin: 0 auto 25px;
            color: var(--text-dark);
        }
        
        .search-bar {
            display: flex;
            max-width: 600px;
            margin: 30px auto;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            border-radius: 50px;
            overflow: hidden;
        }
        
        .search-bar input {
            flex: 1;
            padding: 18px 25px;
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
        
        .categories {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        
        .category-card {
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s ease;
            cursor: pointer;
            border: 1px solid var(--medium-gray);
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .category-icon {
            background-color: var(--primary-maroon);
            color: white;
            height: 100px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
        }
        
        .category-info {
            padding: 20px;
        }
        
        .category-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 10px;
            color: var(--primary-maroon);
        }
        
        .category-count {
            color: var(--dark-gray);
            font-size: 14px;
        }
        
        .section-title {
            font-size: 24px;
            color: var(--primary-maroon);
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--medium-gray);
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
            
            .hero h1 {
                font-size: 28px;
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
            
            .categories {
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
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
        
        .recent-items {
            margin-bottom: 50px;
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
                        <li><a href="homepage.jsp" class="active">Home</a></li>
                        <li><a href="browse-item.jsp">Browse</a></li>
                        <li><a href="sell-item.jsp">Sell Item</a></li>
                        <li><a href="categories.jsp">Categories</a></li>
                    </ul>
                </nav>
                
                <div class="user-actions">
                    <%
                        String userName = (String) session.getAttribute("user");
                        String userRole = (String) session.getAttribute("role");
                    %>
                    <c:choose>
                        <c:when test="<%= userName != null && !userName.isEmpty() %>">
                            <span class="user-greeting">Hello, <%= userName %>!</span>
                            <a href="profile.jsp" class="user-icon">
                                <i class="fas fa-user"></i>
                            </a>
                            <!-- FIXED: Changed to LogoutServlet (existing servlet) -->
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
            <section class="hero">
                <h1>Buy & Sell Within Your Campus</h1>
                <p>Connect with fellow students to buy and sell textbooks, electronics, uniforms, and more. Save money and reduce waste by trading second-hand items on campus.</p>
                
                <div class="search-bar">
                    <!-- FIXED: Simple search form that redirects to browse with query -->
                    <form action="browse-item.jsp" method="GET" style="display: flex; width: 100%;">
                        <input type="text" name="query" placeholder="Search for books, gadgets, uniforms...">
                        <button type="submit"><i class="fas fa-search"></i> Search</button>
                    </form>
                </div>
                
                <%
                    if (userName != null && !userName.isEmpty()) {
                %>
                    <a href="sell-item.jsp" class="btn btn-primary"><i class="fas fa-plus-circle"></i> Sell Your Item</a>
                <%
                    } else {
                %>
                    <a href="login.jsp" class="btn btn-primary"><i class="fas fa-plus-circle"></i> Login to Sell Your Item</a>
                <%
                    }
                %>
            </section>
            
            <h2 class="section-title">Browse Categories</h2>
            <div class="categories">
                <%
                    // Get category counts from database
                    int textbooksCount = 0;
                    int electronicsCount = 0;
                    int uniformsCount = 0;
                    int otherCount = 0;
                    
                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                        
                        // Count textbooks (category_id = 1)
                        PreparedStatement psTextbooks = conn.prepareStatement(
                            "SELECT COUNT(*) FROM ITEMS i WHERE i.status IN ('APPROVED', 'AVAILABLE') AND i.category_id = 1"
                        );
                        ResultSet rsTextbooks = psTextbooks.executeQuery();
                        if(rsTextbooks.next()) {
                            textbooksCount = rsTextbooks.getInt(1);
                        }
                        rsTextbooks.close();
                        psTextbooks.close();
                        
                        // Count electronics (category_id = 2)
                        PreparedStatement psElectronics = conn.prepareStatement(
                            "SELECT COUNT(*) FROM ITEMS i WHERE i.status IN ('APPROVED', 'AVAILABLE') AND i.category_id = 2"
                        );
                        ResultSet rsElectronics = psElectronics.executeQuery();
                        if(rsElectronics.next()) {
                            electronicsCount = rsElectronics.getInt(1);
                        }
                        rsElectronics.close();
                        psElectronics.close();
                        
                        // Count uniforms (category_id = 3)
                        PreparedStatement psUniforms = conn.prepareStatement(
                            "SELECT COUNT(*) FROM ITEMS i WHERE i.status IN ('APPROVED', 'AVAILABLE') AND i.category_id = 3"
                        );
                        ResultSet rsUniforms = psUniforms.executeQuery();
                        if(rsUniforms.next()) {
                            uniformsCount = rsUniforms.getInt(1);
                        }
                        rsUniforms.close();
                        psUniforms.close();
                        
                        // Count other items (category_id = 4)
                        PreparedStatement psOther = conn.prepareStatement(
                            "SELECT COUNT(*) FROM ITEMS i WHERE i.status IN ('APPROVED', 'AVAILABLE') AND i.category_id = 4"
                        );
                        ResultSet rsOther = psOther.executeQuery();
                        if(rsOther.next()) {
                            otherCount = rsOther.getInt(1);
                        }
                        rsOther.close();
                        psOther.close();
                        
                        conn.close();
                    } catch(Exception e) {
                        e.printStackTrace();
                    }
                %>
                
                <!-- Textbooks Category -->
                <a href="browse-item.jsp?category=textbooks" class="category-card">
                    <div class="category-icon">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="category-info">
                        <div class="category-title">Textbooks</div>
                        <div class="category-count">
                            <%= textbooksCount %> item<%= textbooksCount != 1 ? "s" : "" %> available
                        </div>
                    </div>
                </a>
                
                <!-- Electronics Category -->
                <a href="browse-item.jsp?category=electronics" class="category-card">
                    <div class="category-icon">
                        <i class="fas fa-laptop"></i>
                    </div>
                    <div class="category-info">
                        <div class="category-title">Electronics & Gadgets</div>
                        <div class="category-count">
                            <%= electronicsCount %> item<%= electronicsCount != 1 ? "s" : "" %> available
                        </div>
                    </div>
                </a>
                
                <!-- Uniforms Category -->
                <a href="browse-item.jsp?category=uniforms" class="category-card">
                    <div class="category-icon">
                        <i class="fas fa-tshirt"></i>
                    </div>
                    <div class="category-info">
                        <div class="category-title">Uniforms & Clothing</div>
                        <div class="category-count">
                            <%= uniformsCount %> item<%= uniformsCount != 1 ? "s" : "" %> available
                        </div>
                    </div>
                </a>
                
                <!-- Other Items Category -->
                <a href="browse-item.jsp?category=other" class="category-card">
                    <div class="category-icon">
                        <i class="fas fa-ellipsis-h"></i>
                    </div>
                    <div class="category-info">
                        <div class="category-title">Other Items</div>
                        <div class="category-count">
                            <%= otherCount %> item<%= otherCount != 1 ? "s" : "" %> available
                        </div>
                    </div>
                </a>
            </div>
            
            <!-- Recent Items Section -->
            <div class="recent-items">
                <h2 class="section-title">Recently Added Items</h2>
                <div class="categories">
                    <%
                        try {
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                            PreparedStatement ps = conn.prepareStatement(
                                "SELECT i.item_id, i.item_name, i.price, u.full_name, c.category_name " +
                                "FROM ITEMS i " +
                                "JOIN USERS u ON i.user_id = u.user_id " +
                                "JOIN CATEGORIES c ON i.category_id = c.category_id " +
                                "WHERE i.status IN ('APPROVED', 'AVAILABLE') " +
                                "ORDER BY i.date_submitted DESC FETCH FIRST 4 ROWS ONLY"
                            );
                            ResultSet rs = ps.executeQuery();
                            boolean hasItems = false;
                            
                            while(rs.next()) {
                                hasItems = true;
                    %>
                    <a href="item-detail.jsp?id=<%= rs.getInt("item_id") %>" class="category-card">
                        <div class="category-icon" style="background-color: #4a6fa5;">
                            <i class="fas fa-tag"></i>
                        </div>
                        <div class="category-info">
                            <div class="category-title"><%= rs.getString("item_name") %></div>
                            <div class="category-count">$<%= String.format("%.2f", rs.getDouble("price")) %></div>
                            <small style="display: block; margin-top: 5px;">
                                <i class="fas fa-user"></i> <%= rs.getString("full_name") %><br>
                                <i class="fas fa-tag"></i> <%= rs.getString("category_name") %>
                            </small>
                        </div>
                    </a>
                    <%
                            }
                            
                            if(!hasItems) {
                    %>
                    <div style="grid-column: 1 / -1; text-align: center; padding: 20px;">
                        <p>No items available yet. Be the first to list an item!</p>
                        <%
                            if (userName != null && !userName.isEmpty()) {
                        %>
                            <a href="sell-item.jsp" class="btn btn-primary">Sell Item</a>
                        <%
                            } else {
                        %>
                            <a href="login.jsp" class="btn btn-primary">Login to Sell</a>
                        <%
                            }
                        %>
                    </div>
                    <%
                            }
                            conn.close();
                        } catch(Exception e) {
                            e.printStackTrace();
                    %>
                    <div style="grid-column: 1 / -1; text-align: center; padding: 20px;">
                        <p>Unable to load items. Please try again later.</p>
                    </div>
                    <%
                        }
                    %>
                </div>
            </div>
            
            <!-- Removed the "Find what you need, sell your items, manage profile" section -->
            
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
</body>
</html>