
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campus Marketplace | Edit Listing</title>
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
        
        .btn-secondary {
            background-color: var(--dark-gray);
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: var(--text-dark);
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
            border: 2px solid #dc3545;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
        }
        
        .main-content {
            padding: 30px 0;
        }
        
        .page-header {
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid var(--medium-gray);
            display: flex;
            justify-content: space-between;
            align-items: center;
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
        
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: var(--primary-maroon);
            text-decoration: none;
            font-weight: 500;
            margin-bottom: 20px;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        .edit-listing-form {
            background-color: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--medium-gray);
        }
        
        .form-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid var(--medium-gray);
        }
        
        .form-section:last-child {
            border-bottom: none;
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
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }
        
        .form-group label .required {
            color: var(--light-maroon);
        }
        
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--medium-gray);
            border-radius: 4px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }
        
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-maroon);
        }
        
        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
        }
        
        .form-row .form-group {
            flex: 1;
        }
        
        .price-input {
            position: relative;
        }
        
        .price-input span {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--dark-gray);
        }
        
        .price-input input {
            padding-left: 35px;
        }
        
        .image-upload-area {
            border: 2px dashed var(--medium-gray);
            border-radius: 8px;
            padding: 40px 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .image-upload-area:hover {
            border-color: var(--primary-maroon);
            background-color: rgba(128, 0, 0, 0.02);
        }
        
        .upload-icon {
            font-size: 48px;
            color: var(--primary-maroon);
            margin-bottom: 15px;
        }
        
        .upload-text {
            font-size: 16px;
            margin-bottom: 10px;
        }
        
        .upload-subtext {
            color: var(--dark-gray);
            font-size: 14px;
        }
        
        .uploaded-images {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 20px;
        }
        
        .uploaded-image {
            width: 100px;
            height: 100px;
            border-radius: 4px;
            background-color: var(--medium-gray);
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        
        .uploaded-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .uploaded-image i {
            font-size: 36px;
            color: var(--primary-maroon);
        }
        
        .remove-image {
            position: absolute;
            top: 5px;
            right: 5px;
            background-color: rgba(0, 0, 0, 0.7);
            color: white;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            cursor: pointer;
        }
        
        .category-options {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 10px;
        }
        
        .category-option {
            border: 1px solid var(--medium-gray);
            border-radius: 4px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
        }
        
        .category-option:hover {
            border-color: var(--primary-maroon);
            background-color: rgba(128, 0, 0, 0.05);
        }
        
        .category-option.selected {
            border-color: var(--primary-maroon);
            background-color: rgba(128, 0, 0, 0.1);
        }
        
        .category-icon {
            font-size: 24px;
            color: var(--primary-maroon);
            margin-bottom: 10px;
        }
        
        .condition-options {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 10px;
        }
        
        .condition-option {
            flex: 1;
            min-width: 150px;
            border: 1px solid var(--medium-gray);
            border-radius: 4px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
        }
        
        .condition-option:hover {
            border-color: var(--primary-maroon);
            background-color: rgba(128, 0, 0, 0.05);
        }
        
        .condition-option.selected {
            border-color: var(--primary-maroon);
            background-color: rgba(128, 0, 0, 0.1);
        }
        
        .form-actions {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid var(--medium-gray);
        }
        
        .action-left, .action-right {
            display: flex;
            gap: 15px;
        }
        
        .tips-box {
            background-color: rgba(128, 0, 0, 0.05);
            border-left: 4px solid var(--primary-maroon);
            padding: 15px;
            margin-top: 15px;
            border-radius: 0 4px 4px 0;
        }
        
        .tips-box h4 {
            color: var(--primary-maroon);
            margin-bottom: 10px;
            font-size: 16px;
        }
        
        .tips-box ul {
            padding-left: 20px;
            font-size: 14px;
        }
        
        .tips-box li {
            margin-bottom: 5px;
        }
        
        .current-images {
            margin-top: 20px;
        }
        
        .current-images h4 {
            margin-bottom: 15px;
            color: var(--text-dark);
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
            
            .form-row {
                flex-direction: column;
                gap: 0;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .action-left, .action-right {
                width: 100%;
                flex-direction: column;
            }
            
            .condition-options {
                flex-direction: column;
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
            <a href="profile.html" class="back-link">
                <i class="fas fa-arrow-left"></i> Back to My Listings
            </a>
            
            <div class="page-header">
                <div>
                    <h1 class="page-title">Edit Listing</h1>
                    <p class="page-subtitle">Update your item details</p>
                </div>
                <div id="listing-id-display" style="color: var(--dark-gray); font-size: 14px;">
                    <!-- Listing ID will be displayed here -->
                </div>
            </div>
            
            <form class="edit-listing-form" id="editForm">
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-info-circle"></i> Basic Information</h3>
                    
                    <div class="form-group">
                        <label for="title">Item Title <span class="required">*</span></label>
                        <input type="text" id="title" placeholder="e.g., Introduction to Computer Science Textbook" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description <span class="required">*</span></label>
                        <textarea id="description" placeholder="Describe your item in detail. Include condition, specifications, reason for selling, etc." required></textarea>
                        <div class="tips-box">
                            <h4>Tips for a good description:</h4>
                            <ul>
                                <li>Mention the condition of the item</li>
                                <li>Include any defects or issues</li>
                                <li>State why you're selling it</li>
                                <li>Note if accessories are included</li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-images"></i> Photos</h3>
                    
                    <div class="current-images">
                        <h4>Current Photos</h4>
                        <div class="uploaded-images">
                            <div class="uploaded-image">
                                <i class="fas fa-laptop"></i>
                                <div class="remove-image">
                                    <i class="fas fa-times"></i>
                                </div>
                            </div>
                            <div class="uploaded-image">
                                <i class="fas fa-image"></i>
                                <div class="remove-image">
                                    <i class="fas fa-times"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Add More Photos</label>
                        <div class="image-upload-area" id="uploadArea">
                            <div class="upload-icon">
                                <i class="fas fa-cloud-upload-alt"></i>
                            </div>
                            <div class="upload-text">Drag & drop photos here or click to browse</div>
                            <div class="upload-subtext">Upload up to 5 photos (JPEG, PNG, max 5MB each)</div>
                        </div>
                    </div>
                </div>
                
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-tags"></i> Category & Details</h3>
                    
                    <div class="form-group">
                        <label>Select Category <span class="required">*</span></label>
                        <div class="category-options" id="categoryOptions">
                            <div class="category-option" data-category="books">
                                <div class="category-icon">
                                    <i class="fas fa-book"></i>
                                </div>
                                <div>Textbooks</div>
                            </div>
                            <div class="category-option" data-category="electronics">
                                <div class="category-icon">
                                    <i class="fas fa-laptop"></i>
                                </div>
                                <div>Electronics</div>
                            </div>
                            <div class="category-option" data-category="uniforms">
                                <div class="category-icon">
                                    <i class="fas fa-tshirt"></i>
                                </div>
                                <div>Uniforms</div>
                            </div>
                            <div class="category-option" data-category="furniture">
                                <div class="category-icon">
                                    <i class="fas fa-home"></i>
                                </div>
                                <div>Room Essentials</div>
                            </div>
                            <div class="category-option" data-category="sports">
                                <div class="category-icon">
                                    <i class="fas fa-basketball-ball"></i>
                                </div>
                                <div>Sports Equipment</div>
                            </div>
                            <div class="category-option" data-category="other">
                                <div class="category-icon">
                                    <i class="fas fa-ellipsis-h"></i>
                                </div>
                                <div>Other</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="condition">Condition <span class="required">*</span></label>
                            <div class="condition-options" id="conditionOptions">
                                <div class="condition-option" data-condition="new">
                                    New
                                </div>
                                <div class="condition-option" data-condition="like_new">
                                    Like New
                                </div>
                                <div class="condition-option" data-condition="good">
                                    Good
                                </div>
                                <div class="condition-option" data-condition="fair">
                                    Fair
                                </div>
                                <div class="condition-option" data-condition="poor">
                                    Poor
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="brand">Brand</label>
                            <input type="text" id="brand" placeholder="e.g., Texas Instruments, Nike, etc.">
                        </div>
                    </div>
                </div>
                
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-dollar-sign"></i> Pricing</h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="price">Price <span class="required">*</span></label>
                            <div class="price-input">
                                <span>$</span>
                                <input type="number" id="price" placeholder="0.00" min="0" step="0.01" required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="negotiable">Negotiable</label>
                            <select id="negotiable">
                                <option value="yes">Yes, price is negotiable</option>
                                <option value="no">No, fixed price</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="meetup">Meetup Location <span class="required">*</span></label>
                        <select id="meetup" required>
                            <option value="">Select preferred meetup location</option>
                            <option value="library">Main Library Entrance</option>
                            <option value="student-union">Student Union Building</option>
                            <option value="cafeteria">Central Cafeteria</option>
                            <option value="dorm-a">Dormitory A Lobby</option>
                            <option value="dorm-b">Dormitory B Lobby</option>
                            <option value="other">Other (specify in description)</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-actions">
                    <div class="action-left">
                        <button type="button" class="btn btn-outline" id="previewBtn">
                            <i class="fas fa-eye"></i> Preview
                        </button>
                    </div>
                    <div class="action-right">
                        <button type="button" class="btn btn-danger" id="deleteBtn">
                            <i class="fas fa-trash"></i> Delete Listing
                        </button>
                        <button type="submit" class="btn btn-primary" id="updateBtn">
                            <i class="fas fa-save"></i> Update Listing
                        </button>
                    </div>
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
                        <li><a href="browse-item.jsp">Browse</a></li>
                        <li><a href="sell-item.jsp">Sell Item</a></li>
                        <li><a href="categories.jsp" class="active">Categories</a></li>
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
</body>
</html>
