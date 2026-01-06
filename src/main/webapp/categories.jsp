
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    </style>
</head>
<body>
    <header>
        <div class="container">
            <div class="nav-container">
                <a href="index.html" class="logo">
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
                    <a href="profile.jsp" class="user-icon">
                        <i class="fas fa-user"></i>
                    </a>
                    <a href="login.html" class="btn btn-outline">Log In</a>
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
                <a href="listings.html?category=books" class="category-card-large" id="books">
                    <div class="category-header">
                        <div class="category-icon-large">
                            <i class="fas fa-book"></i>
                        </div>
                        <div class="category-info-large">
                            <h3>Textbooks & Academic Materials</h3>
                            <div class="category-count">245 items available</div>
                        </div>
                    </div>
                    <div class="category-body">
                        <p class="category-description">Find required textbooks, study guides, lab manuals, and other academic materials for your courses. Save up to 70% compared to bookstore prices.</p>
                        
                        <div class="subcategories">
                            <span class="subcategory-tag">Computer Science</span>
                            <span class="subcategory-tag">Engineering</span>
                            <span class="subcategory-tag">Business</span>
                            <span class="subcategory-tag">Biology</span>
                            <span class="subcategory-tag">Chemistry</span>
                            <span class="subcategory-tag">Mathematics</span>
                            <span class="subcategory-tag">Humanities</span>
                        </div>
                        
                        <div class="category-footer">
                            <div>
                                <div style="font-size: 14px; color: var(--dark-gray);">Average price: $28.50</div>
                            </div>
                            <div>
                                <span class="view-all-link">
                                    View all textbooks
                                    <i class="fas fa-arrow-right"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </a>
                
                <a href="listings.html?category=electronics" class="category-card-large" id="electronics">
                    <div class="category-header">
                        <div class="category-icon-large">
                            <i class="fas fa-laptop"></i>
                        </div>
                        <div class="category-info-large">
                            <h3>Electronics & Gadgets</h3>
                            <div class="category-count">189 items available</div>
                        </div>
                    </div>
                    <div class="category-body">
                        <p class="category-description">Laptops, tablets, calculators, headphones, phones, and other tech essentials for your studies and daily campus life.</p>
                        
                        <div class="subcategories">
                            <span class="subcategory-tag">Laptops</span>
                            <span class="subcategory-tag">Calculators</span>
                            <span class="subcategory-tag">Tablets</span>
                            <span class="subcategory-tag">Headphones</span>
                            <span class="subcategory-tag">Chargers</span>
                            <span class="subcategory-tag">Speakers</span>
                        </div>
                        
                        <div class="category-footer">
                            <div>
                                <div style="font-size: 14px; color: var(--dark-gray);">Average price: $85.20</div>
                            </div>
                            <div>
                                <span class="view-all-link">
                                    View all electronics
                                    <i class="fas fa-arrow-right"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </a>
                
                <a href="listings.html?category=uniforms" class="category-card-large" id="uniforms">
                    <div class="category-header">
                        <div class="category-icon-large">
                            <i class="fas fa-tshirt"></i>
                        </div>
                        <div class="category-info-large">
                            <h3>Uniforms & Clothing</h3>
                            <div class="category-count">132 items available</div>
                        </div>
                    </div>
                    <div class="category-body">
                        <p class="category-description">Campus uniforms, lab coats, sports uniforms, formal wear, and casual clothing items. Find items that fit your campus style.</p>
                        
                        <div class="subcategories">
                            <span class="subcategory-tag">Lab Coats</span>
                            <span class="subcategory-tag">Sports Uniforms</span>
                            <span class="subcategory-tag">Formal Wear</span>
                            <span class="subcategory-tag">Casual Clothing</span>
                            <span class="subcategory-tag">Footwear</span>
                        </div>
                        
                        <div class="category-footer">
                            <div>
                                <div style="font-size: 14px; color: var(--dark-gray);">Average price: $18.75</div>
                            </div>
                            <div>
                                <span class="view-all-link">
                                    View all clothing
                                    <i class="fas fa-arrow-right"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </a>
                
                <a href="listings.html?category=other" class="category-card-large" id="other">
                    <div class="category-header">
                        <div class="category-icon-large">
                            <i class="fas fa-ellipsis-h"></i>
                        </div>
                        <div class="category-info-large">
                            <h3>Other Items</h3>
                            <div class="category-count">89 items available</div>
                        </div>
                    </div>
                    <div class="category-body">
                        <p class="category-description">Miscellaneous items that don't fit into other categories. From art supplies to musical instruments, find unique items from campus community.</p>
                        
                        <div class="subcategories">
                            <span class="subcategory-tag">Art Supplies</span>
                            <span class="subcategory-tag">Musical Instruments</span>
                            <span class="subcategory-tag">Stationery</span>
                            <span class="subcategory-tag">Miscellaneous</span>
                        </div>
                        
                        <div class="category-footer">
                            <div>
                                <div style="font-size: 14px; color: var(--dark-gray);">Average price: $24.50</div>
                            </div>
                            <div>
                                <span class="view-all-link">
                                    View all other items
                                    <i class="fas fa-arrow-right"></i>
                                </span>
                            </div>
                        </div>
                    </div>
                </a>
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
                <a href="listings.html" class="btn btn-primary" style="padding: 15px 40px; font-size: 16px;">
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
                        <li><a href="index.html">Home</a></li>
                        <li><a href="listings.html">Browse Items</a></li>
                        <li><a href="create-listing.html">Sell an Item</a></li>
                        <li><a href="profile.html">My Account</a></li>
                    </ul>
                </div>
                
                <div class="footer-section">
                    <h3>Categories</h3>
                    <ul>
                        <li><a href="categories.html#books">Textbooks</a></li>
                        <li><a href="categories.html#electronics">Electronics</a></li>
                        <li><a href="categories.html#uniforms">Uniforms</a></li>
                        <li><a href="categories.html#other">Other Items</a></li>
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
            // Smooth scroll to category when URL has hash
            if (window.location.hash) {
                const targetCategory = document.querySelector(window.location.hash);
                if (targetCategory) {
                    setTimeout(() => {
                        targetCategory.scrollIntoView({ behavior: 'smooth' });
                        // Add a highlight effect
                        targetCategory.style.boxShadow = '0 0 0 3px rgba(128, 0, 0, 0.3)';
                        setTimeout(() => {
                            targetCategory.style.boxShadow = '';
                        }, 2000);
                    }, 100);
                }
            }
            
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