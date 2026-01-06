
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        
        .profile-rating {
            color: #ffc107;
            margin-bottom: 15px;
            font-size: 18px;
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
        
        /* Add this to your existing CSS */
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
                    <a href="login.html" class="btn btn-outline">Log Out</a>
                </div>
            </div>
        </div>
    </header>

    <div class="main-content">
        <div class="container">
            <div class="profile-container">
                <div class="profile-sidebar">
                    <div class="profile-card">
                        <div class="profile-avatar">MA</div>
                        <h2 class="profile-name">Maria Alvarez</h2>
                        <div class="profile-major">Engineering Department</div>
                        <div class="profile-rating">
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star"></i>
                            <i class="fas fa-star-half-alt"></i>
                            <span style="font-size: 14px; color: var(--dark-gray); margin-left: 5px;">4.5</span>
                        </div>
                        
                        <div class="profile-stats">
                            <div class="stat-item">
                                <div class="stat-value">12</div>
                                <div class="stat-label">Listings</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value">8</div>
                                <div class="stat-label">Sold</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value">23</div>
                                <div class="stat-label">Reviews</div>
                            </div>
                        </div>
                        
                        <div class="profile-actions">
                            <a href="create-listing.html" class="btn btn-primary">
                                <i class="fas fa-plus-circle"></i> New Listing
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
                        
<div id="listings" class="tab-content active">
    <h3 class="section-title"><i class="fas fa-th-large"></i> Active Listings</h3>
    
    <div class="listings-grid">
        <div class="item-card">
            <div class="item-image">
                <div class="item-status">Available</div>
                <i class="fas fa-laptop fa-3x" style="color: #800000;"></i>
            </div>
            <div class="item-details">
                <div class="item-title">Graphing Calculator TI-84 Plus</div>
                <div class="item-price">$65.00</div>
                <p>Used for one semester, works perfectly. Includes case and charging cable.</p>
                <div class="item-actions">
                    <a href="edit-item.jsp?id=1&title=Graphing+Calculator+TI-84+Plus&price=65.00&category=electronics&condition=like_new" 
                       class="btn btn-primary btn-small">Edit</a>
                    <button class="btn btn-outline btn-small delete-btn">Delete</button>
                    <button class="btn btn-outline btn-small">Mark Sold</button>
                </div>
            </div>
        </div>
        
        <div class="item-card">
            <div class="item-image">
                <div class="item-status">Available</div>
                <i class="fas fa-book-open fa-3x" style="color: #800000;"></i>
            </div>
            <div class="item-details">
                <div class="item-title">Calculus Textbook 3rd Edition</div>
                <div class="item-price">$35.00</div>
                <p>Like new condition, minimal highlighting. Includes practice problem solutions.</p>
                <div class="item-actions">
                    <button class="btn btn-primary btn-small">Edit</button>
                    <button class="btn btn-outline btn-small delete-btn">Delete</button>
                    <button class="btn btn-outline btn-small">Mark Sold</button>
                </div>
            </div>
        </div>
        
        <div class="item-card">
            <div class="item-image">
                <div class="item-status">Available</div>
                <i class="fas fa-headphones fa-3x" style="color: #800000;"></i>
            </div>
            <div class="item-details">
                <div class="item-title">Wireless Headphones</div>
                <div class="item-price">$40.00</div>
                <p>Excellent sound quality, 20-hour battery life. Includes original box.</p>
                <div class="item-actions">
                    <button class="btn btn-primary btn-small">Edit</button>
                    <button class="btn btn-outline btn-small delete-btn">Delete</button>
                    <button class="btn btn-outline btn-small">Mark Sold</button>
                </div>
            </div>
        </div>
        
        <div class="item-card" style="border-style: dashed; border-color: var(--medium-gray); background-color: var(--light-gray); display: flex; align-items: center; justify-content: center;">
            <a href="create-listing.html" style="text-decoration: none; color: var(--dark-gray); text-align: center; padding: 40px;">
                <i class="fas fa-plus-circle fa-3x" style="color: var(--primary-maroon); margin-bottom: 15px;"></i>
                <div style="font-weight: 600; color: var(--primary-maroon);">Add New Listing</div>
            </a>
        </div>
    </div>
</div>
                        
                        <div id="sold" class="tab-content">
    <h3 class="section-title"><i class="fas fa-check-circle"></i> Sold Items</h3>
    
    <div class="listings-grid">
        <div class="item-card">
            <div class="item-image">
                <div class="item-status" style="background-color: var(--dark-gray);">Sold</div>
                <i class="fas fa-tshirt fa-3x" style="color: #800000;"></i>
            </div>
            <div class="item-details">
                <div class="item-title">Engineering Lab Coat</div>
                <div class="item-price">$25.00</div>
                <p>Sold to Alex Johnson on Oct 15, 2023</p>
                <div class="item-actions">
                    <button class="btn btn-outline btn-small">Relist</button>
                    <button class="btn btn-outline btn-small delete-btn">Delete</button>
                </div>
            </div>
        </div>
        
        <div class="item-card">
            <div class="item-image">
                <div class="item-status" style="background-color: var(--dark-gray);">Sold</div>
                <i class="fas fa-tablet-alt fa-3x" style="color: #800000;"></i>
            </div>
            <div class="item-details">
                <div class="item-title">iPad Mini</div>
                <div class="item-price">$180.00</div>
                <p>Sold to Sarah Kim on Sep 28, 2023</p>
                <div class="item-actions">
                    <button class="btn btn-outline btn-small">Relist</button>
                    <button class="btn btn-outline btn-small delete-btn">Delete</button>
                </div>
            </div>
        </div>
    </div>
</div>
                        
                        <div id="purchases" class="tab-content">
                            <h3 class="section-title"><i class="fas fa-shopping-bag"></i> My Purchases</h3>
                            
                            <div class="listings-grid">
                                <a href="product-detail.html" class="item-card">
                                    <div class="item-image">
                                        <div class="item-status" style="background-color: #28a745;">Purchased</div>
                                        <i class="fas fa-bicycle fa-3x" style="color: #800000;"></i>
                                    </div>
                                    <div class="item-details">
                                        <div class="item-title">Mountain Bike</div>
                                        <div class="item-price">$120.00</div>
                                        <p>Purchased from Tom Wilson on Nov 5, 2023</p>
                                        <div class="item-actions">
                                            <button class="btn btn-outline btn-small">Contact Seller</button>
                                        </div>
                                    </div>
                                </a>
                                
                                <a href="product-detail.html" class="item-card">
                                    <div class="item-image">
                                        <div class="item-status" style="background-color: #28a745;">Purchased</div>
                                        <i class="fas fa-chair fa-3x" style="color: #800000;"></i>
                                    </div>
                                    <div class="item-details">
                                        <div class="item-title">Desk Chair</div>
                                        <div class="item-price">$45.00</div>
                                        <p>Purchased from Robert Chen on Oct 20, 2023</p>
                                        <div class="item-actions">
                                            <button class="btn btn-outline btn-small">Contact Seller</button>
                                        </div>
                                    </div>
                                </a>
                            </div>
                        </div>
                        
                        <div id="settings" class="tab-content">
                            <h3 class="section-title"><i class="fas fa-cog"></i> Account Settings</h3>
                            
                            <form class="settings-form">
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="first-name">First Name</label>
                                        <input type="text" id="first-name" value="Maria">
                                    </div>
                                    <div class="form-group">
                                        <label for="last-name">Last Name</label>
                                        <input type="text" id="last-name" value="Alvarez">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="email">Email Address</label>
                                    <input type="email" id="email" value="maria.alvarez@campus.edu">
                                </div>
                                
                                <div class="form-group">
                                    <label for="major">Major/Department</label>
                                    <input type="text" id="major" value="Engineering">
                                </div>
                                
                                <div class="form-group">
                                    <label for="phone">Phone Number</label>
                                    <input type="tel" id="phone" value="(555) 123-4567">
                                </div>
                                
                                <div class="form-group">
                                    <label for="location">Preferred Meetup Location</label>
                                    <select id="location">
                                        <option>Student Union Building</option>
                                        <option>Main Library Entrance</option>
                                        <option>Central Cafeteria</option>
                                        <option>Dormitory A Lobby</option>
                                        <option>Dormitory B Lobby</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="bio">Bio/Description</label>
                                    <textarea id="bio" rows="4">Engineering student specializing in mechanical systems. I'm selling items I no longer need as I graduate this semester. Always happy to negotiate prices!</textarea>
                                </div>
                                
                                <div style="display: flex; justify-content: flex-end; gap: 15px; margin-top: 30px;">
                                    <button type="button" class="btn btn-outline">Cancel</button>
                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                </div>
                            </form>
                        </div>
                    </div>
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
            
            // Sidebar menu
            const menuItems = document.querySelectorAll('.menu-item');
            menuItems.forEach(item => {
                item.addEventListener('click', function(e) {
                    if (this.getAttribute('href') && this.getAttribute('href').includes('#')) {
                        e.preventDefault();
                        const tabId = this.getAttribute('href').split('#')[1];
                        
                        // Switch to corresponding tab
                        tabs.forEach(t => t.classList.remove('active'));
                        tabContents.forEach(content => content.classList.remove('active'));
                        
                        const targetTab = document.querySelector(`.tab[data-tab="${tabId}"]`);
                        if (targetTab) {
                            targetTab.classList.add('active');
                            document.getElementById(tabId).classList.add('active');
                        }
                    }
                });
            });
            
            // Settings form submission
            const settingsForm = document.querySelector('.settings-form');
            if (settingsForm) {
                settingsForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    alert('Settings saved successfully!');
                });
            }
        });
    </script>
</body>
</html>