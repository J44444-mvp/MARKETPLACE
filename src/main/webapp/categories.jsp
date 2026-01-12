<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campus Marketplace | Categories</title>
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
        
        .main-content {
            padding: 30px 0;
        }
        
        .page-header {
            margin-bottom: 40px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--medium-gray);
        }
        
        .page-title {
            color: var(--primary-maroon);
            font-size: 32px;
            margin-bottom: 10px;
        }
        
        .page-subtitle {
            color: var(--dark-gray);
            font-size: 16px;
            max-width: 800px;
        }
        
        .categories-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }
        
        .category-card-large {
            background-color: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--medium-gray);
            transition: transform 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            display: block;
        }
        
        .category-card-large:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }
        
        .category-header {
            background-color: var(--primary-maroon);
            color: white;
            padding: 25px;
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .category-icon-large {
            font-size: 48px;
            background-color: rgba(255, 255, 255, 0.2);
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .category-info-large h3 {
            font-size: 24px;
            margin-bottom: 5px;
        }
        
        .category-count {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .category-body {
            padding: 25px;
        }
        
        .category-description {
            color: var(--dark-gray);
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        .subcategories {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .subcategory-tag {
            background-color: var(--light-gray);
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            color: var(--text-dark);
        }
        
        .category-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 20px;
            border-top: 1px solid var(--medium-gray);
        }
        
        .view-all-link {
            color: var(--primary-maroon);
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .view-all-link:hover {
            text-decoration: underline;
        }
        
        .category-highlight {
            background-color: rgba(128, 0, 0, 0.05);
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 40px;
            border-left: 5px solid var(--primary-maroon);
        }
        
        .highlight-title {
            font-size: 20px;
            color: var(--primary-maroon);
            margin-bottom: 15px;
        }
        
        .highlight-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .highlight-item {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .highlight-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-maroon);
            font-size: 20px;
            border: 2px solid var(--primary-maroon);
        }
        
        .highlight-text h4 {
            font-size: 16px;
            margin-bottom: 5px;
        }
        
        .highlight-text p {
            font-size: 14px;
            color: var(--dark-gray);
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
            
            .categories-grid {
                grid-template-columns: 1fr;
            }
            
            .category-header {
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }
            
            .category-footer {
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
                        <li><a href="browse-item.jsp">Browse</a></li>
                        <li><a href="sell-item.jsp">Sell Item</a></li>
                        <li><a href="categories.jsp" class="active">Categories</a></li>
                    </ul>
                </nav>
                
                <div class="user-actions">
                    <%
                        String userName = (String) session.getAttribute("user");
                    %>
                    <% if (userName != null && !userName.isEmpty()) { %>
                        <span class="user-greeting">Hello, <%= userName %>!</span>
                        <a href="profile.jsp" class="user-icon">
                            <i class="fas fa-user"></i>
                        </a>
                        <a href="LogoutServlet" class="btn btn-outline logout-btn">Log Out</a>
                    <% } else { %>
                        <a href="profile.jsp" class="user-icon">
                            <i class="fas fa-user"></i>
                        </a>
                        <a href="login.jsp" class="btn btn-outline">Log In</a>
                    <% } %>
                </div>
            </div>
        </div>
    </header>

    <div class="main-content">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Browse by Category</h1>
                <p class="page-subtitle">Find exactly what you're looking for by exploring our organized categories. From textbooks to electronics, uniforms to other items - discover items from fellow students.</p>
            </div>
            
            <div class="categories-grid">
                <%
                    // Database connection to fetch categories
                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                        
                        // Get all categories with item counts
                        String query = "SELECT c.category_id, c.category_name, COUNT(i.item_id) as item_count " +
                                       "FROM CATEGORIES c " +
                                       "LEFT JOIN ITEMS i ON c.category_id = i.category_id " +
                                       "AND i.status IN ('APPROVED', 'AVAILABLE') " +
                                       "GROUP BY c.category_id, c.category_name " +
                                       "ORDER BY c.category_id";
                        
                        PreparedStatement ps = conn.prepareStatement(query);
                        ResultSet rs = ps.executeQuery();
                        
                        while(rs.next()) {
                            int categoryId = rs.getInt("category_id");
                            String categoryName = rs.getString("category_name");
                            int itemCount = rs.getInt("item_count");
                            
                            // Set icon and description based on category
                            String iconClass = "";
                            String description = "";
                            String[] subcategories = {};
                            String browseParam = "";
                            
                            switch(categoryId) {
                                case 1:
                                    iconClass = "fas fa-book";
                                    description = "Find required textbooks, study guides, lab manuals, and other academic materials for your courses. Save up to 70% compared to bookstore prices.";
                                    subcategories = new String[]{"Computer Science", "Engineering", "Business", "Biology", "Chemistry", "Mathematics", "Humanities"};
                                    browseParam = "textbooks";
                                    break;
                                case 2:
                                    iconClass = "fas fa-laptop";
                                    description = "Laptops, tablets, calculators, headphones, phones, and other tech essentials for your studies and daily campus life.";
                                    subcategories = new String[]{"Laptops", "Calculators", "Tablets", "Headphones", "Chargers", "Speakers"};
                                    browseParam = "electronics";
                                    break;
                                case 3:
                                    iconClass = "fas fa-tshirt";
                                    description = "Campus uniforms, lab coats, sports uniforms, formal wear, and casual clothing items. Find items that fit your campus style.";
                                    subcategories = new String[]{"Lab Coats", "Sports Uniforms", "Formal Wear", "Casual Clothing", "Footwear"};
                                    browseParam = "uniforms";
                                    break;
                                case 4:
                                    iconClass = "fas fa-ellipsis-h";
                                    description = "Miscellaneous items that don't fit into other categories. From art supplies to musical instruments, find unique items from campus community.";
                                    subcategories = new String[]{"Art Supplies", "Musical Instruments", "Stationery", "Miscellaneous"};
                                    browseParam = "other";
                                    break;
                                default:
                                    iconClass = "fas fa-tag";
                                    description = "Browse items in this category.";
                                    subcategories = new String[]{categoryName};
                                    browseParam = "category=" + categoryId;
                            }
                            
                            // Calculate average price for the category
                            double avgPrice = 0;
                            try {
                                PreparedStatement avgPs = conn.prepareStatement(
                                    "SELECT COALESCE(AVG(price), 0) as avg_price FROM ITEMS " +
                                    "WHERE category_id = ? AND status IN ('APPROVED', 'AVAILABLE')"
                                );
                                avgPs.setInt(1, categoryId);
                                ResultSet avgRs = avgPs.executeQuery();
                                if(avgRs.next()) {
                                    avgPrice = avgRs.getDouble("avg_price");
                                }
                                avgRs.close();
                                avgPs.close();
                            } catch(Exception e) {
                                e.printStackTrace();
                            }
                %>
                
                <a href="browse-item.jsp?category=<%= browseParam %>" class="category-card-large">
                    <div class="category-header">
                        <div class="category-icon-large">
                            <i class="<%= iconClass %>"></i>
                        </div>
                        <div class="category-info-large">
                            <h3><%= categoryName %></h3>
                            <div class="category-count"><%= itemCount %> item<%= itemCount != 1 ? "s" : "" %> available</div>
                        </div>
                    </div>
                    <div class="category-body">
                        <p class="category-description"><%= description %></p>
                        
                        <div class="subcategories">
                            <% for(String subcat : subcategories) { %>
                            <span class="subcategory-tag"><%= subcat %></span>
                            <% } %>
                        </div>
                        
                        <div class="category-footer">
                            <div>
                                <div style="font-size: 14px; color: var(--dark-gray);">
                                    <% if(avgPrice > 0) { %>
                                        Average price: RM <%= String.format("%.2f", avgPrice) %>
                                    <% } else { %>
                                        No items with price yet
                                    <% } %>
                                </div>
                            </div>
                            <div>
                                <span class="view-all-link">
                                    View all <%= categoryName.toLowerCase() %>
                                    <i class="fas fa-arrow-right"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </a>
                
                <%
                        }
                        
                        rs.close();
                        ps.close();
                        conn.close();
                    } catch(Exception e) {
                        e.printStackTrace();
                %>
                
                <!-- Fallback if database fails -->
                <div style="grid-column: 1 / -1; text-align: center; padding: 40px;">
                    <i class="fas fa-exclamation-triangle fa-3x" style="color: #dc3545; margin-bottom: 20px;"></i>
                    <h3 style="color: var(--dark-gray); margin-bottom: 15px;">Unable to load categories</h3>
                    <p style="color: var(--dark-gray); margin-bottom: 20px;">Please try again later.</p>
                    <a href="homepage.jsp" class="btn btn-primary">Return to Home</a>
                </div>
                <%
                    }
                %>
            </div>
            
            <div class="category-highlight">
                <h3 class="highlight-title">Why Buy Second-Hand on Campus?</h3>
                <div class="highlight-content">
                    <div class="highlight-item">
                        <div class="highlight-icon">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="highlight-text">
                            <h4>Save Money</h4>
                            <p>Buy items at 50-80% less than retail prices</p>
                        </div>
                    </div>
                    
                    <div class="highlight-item">
                        <div class="highlight-icon">
                            <i class="fas fa-leaf"></i>
                        </div>
                        <div class="highlight-text">
                            <h4>Reduce Waste</h4>
                            <p>Give items a second life and help the environment</p>
                        </div>
                    </div>
                    
                    <div class="highlight-item">
                        <div class="highlight-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="highlight-text">
                            <h4>Build Community</h4>
                            <p>Connect with fellow students on campus</p>
                        </div>
                    </div>
                    
                    <div class="highlight-item">
                        <div class="highlight-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <div class="highlight-text">
                            <h4>Safe & Verified</h4>
                            <p>All users are verified campus students</p>
                        </div>
                    </div>
                </div>
            </div>
            
            <div style="text-align: center; margin-top: 40px;">
                <a href="browse-item.jsp" class="btn btn-primary" style="padding: 15px 40px; font-size: 16px;">
                    <i class="fas fa-search"></i> Browse All Items
                </a>
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
        document.addEventListener('DOMContentLoaded', function() {
            // Add click animation to category cards
            const categoryCards = document.querySelectorAll('.category-card-large');
            categoryCards.forEach(card => {
                card.addEventListener('click', function(e) {
                    // Add a quick click animation
                    this.style.transform = 'translateY(-5px) scale(0.99)';
                    setTimeout(() => {
                        this.style.transform = '';
                    }, 150);
                });
            });
        });
    </script>
</body>
</html>