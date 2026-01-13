<%@page import="java.sql.*"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Campus Marketplace | Create Listing</title>
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
        
        .create-listing-form {
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
        
        /* UPDATED: Textarea with proper text wrapping */
        .form-group textarea {
            min-height: 120px;
            resize: vertical;
            white-space: pre-wrap;       /* Preserve whitespace and wrap text */
            word-wrap: break-word;       /* Break long words */
            overflow-wrap: break-word;   /* Modern word breaking */
            line-height: 1.5;            /* Better line spacing */
        }
        
        /* Auto-expanding textarea */
        .auto-expand {
            resize: none !important;
            overflow-y: hidden !important;
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
        
        .image-upload-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .single-upload-box {
            display: flex;
            flex-direction: column;
            gap: 10px;
            min-height: 200px;
        }
        
        .image-upload-area {
            border: 2px dashed var(--medium-gray);
            border-radius: 8px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            height: 180px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
        }
        
        .image-upload-area:hover {
            border-color: var(--primary-maroon);
            background-color: rgba(128, 0, 0, 0.02);
        }
        
        .upload-icon {
            font-size: 36px;
            color: var(--primary-maroon);
            margin-bottom: 10px;
        }
        
        .upload-text {
            font-size: 16px;
            margin-bottom: 5px;
            font-weight: 500;
        }
        
        .upload-subtext {
            color: var(--dark-gray);
            font-size: 12px;
        }
        
        .image-preview {
            width: 100%;
            height: 180px;
            border-radius: 8px;
            background-color: var(--medium-gray);
            position: relative;
            overflow: hidden;
            border: 2px solid var(--medium-gray);
        }
        
        .image-preview img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .remove-image {
            position: absolute;
            top: 8px;
            right: 8px;
            background-color: rgba(220, 53, 69, 0.9);
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            cursor: pointer;
            z-index: 10;
            transition: all 0.3s ease;
            border: none;
        }
        
        .remove-image:hover {
            background-color: #dc3545;
            transform: scale(1.1);
        }
        
        .preview-image {
            position: absolute;
            bottom: 8px;
            left: 8px;
            background-color: rgba(0, 123, 255, 0.9);
            color: white;
            width: 28px;
            height: 28px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            cursor: pointer;
            z-index: 10;
            transition: all 0.3s ease;
            border: none;
        }
        
        .preview-image:hover {
            background-color: #007bff;
            transform: scale(1.1);
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
            justify-content: flex-end;
            gap: 15px;
            margin-top: 30px;
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
        
        /* Full-size image preview modal */
        .image-modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.9);
            animation: fadeIn 0.3s;
        }
        
        .modal-content {
            margin: auto;
            display: block;
            max-width: 90%;
            max-height: 90%;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            animation: zoomIn 0.3s;
        }
        
        .modal-close {
            position: absolute;
            top: 20px;
            right: 30px;
            color: white;
            font-size: 40px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            z-index: 1001;
        }
        
        .modal-close:hover {
            color: #bbb;
        }
        
        .modal-nav {
            position: absolute;
            top: 50%;
            width: 100%;
            display: flex;
            justify-content: space-between;
            padding: 0 20px;
            transform: translateY(-50%);
            z-index: 1001;
        }
        
        .modal-nav-btn {
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            border: none;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            font-size: 24px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .modal-nav-btn:hover {
            background-color: rgba(255, 255, 255, 0.4);
        }
        
        .modal-caption {
            position: absolute;
            bottom: 20px;
            width: 100%;
            text-align: center;
            color: white;
            font-size: 16px;
            padding: 10px;
            background-color: rgba(0, 0, 0, 0.5);
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes zoomIn {
            from { transform: translate(-50%, -50%) scale(0.9); }
            to { transform: translate(-50%, -50%) scale(1); }
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
            
            .condition-options {
                flex-direction: column;
            }
            
            .image-upload-container {
                grid-template-columns: 1fr;
            }
            
            .modal-content {
                max-width: 95%;
                max-height: 80%;
            }
            
            .modal-nav {
                padding: 0 10px;
            }
            
            .modal-nav-btn {
                width: 40px;
                height: 40px;
                font-size: 20px;
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
        
        .error-message {
            color: #dc3545;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 4px;
            padding: 10px 15px;
            margin-bottom: 20px;
        }
        
        .success-message {
            color: #28a745;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            border-radius: 4px;
            padding: 10px 15px;
            margin-bottom: 20px;
        }
        
        .login-required {
            text-align: center;
            padding: 50px;
            background-color: white;
            border-radius: 8px;
            border: 1px solid var(--medium-gray);
        }
        
        .login-required i {
            font-size: 48px;
            color: var(--primary-maroon);
            margin-bottom: 20px;
        }
        
        .image-counter {
            position: absolute;
            bottom: 8px;
            right: 8px;
            background-color: rgba(0, 0, 0, 0.7);
            color: white;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
        }
        
        .hidden {
            display: none !important;
        }
    </style>
</head>
<body>
    <%
        String userName = (String) session.getAttribute("user");
        Integer userId = (Integer) session.getAttribute("user_id");
        String userRole = (String) session.getAttribute("role");
        
        // Redirect if not logged in
        if (userName == null || userId == null) {
            response.sendRedirect("login.jsp?message=Please login to sell items");
            return;
        }
        
        // Only students can sell items (not admins)
        if ("ADMIN".equalsIgnoreCase(userRole)) {
            response.sendRedirect("admin_dashboard.jsp?message=Admins cannot sell items");
            return;
        }
        
        String error = request.getParameter("error");
        String success = request.getParameter("success");
    %>
    
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
                        <li><a href="sell-item.jsp" class="active">Sell Item</a></li>
                        <li><a href="categories.jsp">Categories</a></li>
                    </ul>
                </nav>
                
                <div class="user-actions">
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

    <div class="main-content">
        <div class="container">
            <div class="page-header">
                <h1 class="page-title">Sell Your Item</h1>
                <p class="page-subtitle">List your textbook, gadget, uniform, or other item for sale to campus students</p>
            </div>
            
            <%
                if (error != null) {
            %>
                <div class="error-message">
                    <i class="fas fa-exclamation-circle"></i> <%= error %>
                </div>
            <%
                }
                
                if (success != null) {
            %>
                <div class="success-message">
                    <i class="fas fa-check-circle"></i> <%= success %>
                </div>
            <%
                }
            %>
            
            <!-- CREATE LISTING FORM -->
            <form action="SellItemServlet" method="POST" class="create-listing-form" enctype="multipart/form-data" id="sellForm">
                <input type="hidden" name="user_id" value="<%= userId %>">
                
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-info-circle"></i> Basic Information</h3>
                    
                    <div class="form-group">
                        <label for="item_name">Item Title <span class="required">*</span></label>
                        <input type="text" id="item_name" name="item_name" 
                               placeholder="e.g., Introduction to Computer Science Textbook" 
                               value="<%= request.getParameter("item_name") != null ? request.getParameter("item_name") : "" %>" 
                               required maxlength="100">
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Description <span class="required">*</span></label>
                        <textarea id="description" name="description" 
                                  placeholder="Describe your item in detail. Include condition, specifications, reason for selling, etc." 
                                  required 
                                  class="auto-expand"><%= request.getParameter("description") != null ? request.getParameter("description") : "" %></textarea>
                        <div class="tips-box">
                            <h4>Tips for a good description:</h4>
                            <ul>
                                <li>Mention the condition of the item</li>
                                <li>Include any defects or issues</li>
                                <li>State why you're selling it</li>
                                <li>Note if accessories are included</li>
                                <li>Items will be reviewed by admin before appearing in listings</li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-images"></i> Photos</h3>
                    
                    <div class="form-group">
                        <label>Upload Photos (Optional, up to 3)</label>
                        <p class="upload-subtext" style="margin-bottom: 15px; font-size: 14px; color: var(--dark-maroon); font-weight: 500;">First image will be the main thumbnail</p>
                        
                        <!-- Image upload containers -->
                        <div class="image-upload-container">
                            <!-- Image 1 -->
                            <div class="single-upload-box">
                                <div class="image-upload-area" id="uploadArea1">
                                    <div class="upload-icon">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                    </div>
                                    <div class="upload-text">Click to upload photo 1</div>
                                    <div class="upload-subtext">Main photo (required)</div>
                                    <input type="file" id="imageUpload1" name="image1" accept="image/*" class="hidden">
                                </div>
                                <div class="image-preview hidden" id="imagePreview1">
                                    <!-- Preview will be inserted here by JavaScript -->
                                </div>
                            </div>
                            
                            <!-- Image 2 -->
                            <div class="single-upload-box">
                                <div class="image-upload-area" id="uploadArea2">
                                    <div class="upload-icon">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                    </div>
                                    <div class="upload-text">Click to upload photo 2</div>
                                    <div class="upload-subtext">Optional additional photo</div>
                                    <input type="file" id="imageUpload2" name="image2" accept="image/*" class="hidden">
                                </div>
                                <div class="image-preview hidden" id="imagePreview2">
                                    <!-- Preview will be inserted here by JavaScript -->
                                </div>
                            </div>
                            
                            <!-- Image 3 -->
                            <div class="single-upload-box">
                                <div class="image-upload-area" id="uploadArea3">
                                    <div class="upload-icon">
                                        <i class="fas fa-cloud-upload-alt"></i>
                                    </div>
                                    <div class="upload-text">Click to upload photo 3</div>
                                    <div class="upload-subtext">Optional additional photo</div>
                                    <input type="file" id="imageUpload3" name="image3" accept="image/*" class="hidden">
                                </div>
                                <div class="image-preview hidden" id="imagePreview3">
                                    <!-- Preview will be inserted here by JavaScript -->
                                </div>
                            </div>
                        </div>
                        
                        <div class="tips-box">
                            <h4>Photo tips:</h4>
                            <ul>
                                <li>Upload at least one clear photo of your item</li>
                                <li>Take photos in good lighting</li>
                                <li>Show any defects clearly</li>
                                <li>Include photos from multiple angles</li>
                                <li>First photo will be the thumbnail in listings</li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-tags"></i> Category & Details</h3>
                    
                    <div class="form-group">
                        <label for="category">Select Category</label>
                        <select id="category" name="category" class="form-control">
                            <option value="">Select a category</option>
                            <option value="textbooks" <%= "textbooks".equals(request.getParameter("category")) ? "selected" : "" %>>Textbooks</option>
                            <option value="electronics" <%= "electronics".equals(request.getParameter("category")) ? "selected" : "" %>>Electronics & Gadgets</option>
                            <option value="uniforms" <%= "uniforms".equals(request.getParameter("category")) ? "selected" : "" %>>Uniforms & Clothing</option>
                            <option value="other" <%= "other".equals(request.getParameter("category")) ? "selected" : "" %>>Other Items</option>
                        </select>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="condition">Condition <span class="required">*</span></label>
                            <select id="condition" name="condition" required>
                                <option value="">Select condition</option>
                                <option value="new" <%= "new".equals(request.getParameter("condition")) ? "selected" : "" %>>New</option>
                                <option value="like-new" <%= "like-new".equals(request.getParameter("condition")) ? "selected" : "" %>>Like New</option>
                                <option value="good" <%= "good".equals(request.getParameter("condition")) ? "selected" : "" %>>Good</option>
                                <option value="fair" <%= "fair".equals(request.getParameter("condition")) ? "selected" : "" %>>Fair</option>
                                <option value="poor" <%= "poor".equals(request.getParameter("condition")) ? "selected" : "" %>>Poor</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="brand">Brand (Optional)</label>
                            <input type="text" id="brand" name="brand" placeholder="e.g., Texas Instruments, Nike, etc." 
                                   value="<%= request.getParameter("brand") != null ? request.getParameter("brand") : "" %>">
                        </div>
                    </div>
                </div>
                
                <div class="form-section">
                    <h3 class="section-title"><i class="fas fa-dollar-sign"></i> Pricing</h3>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="price">Price <span class="required">*</span></label>
                            <div class="price-input">
                                <span>RM</span>
                                <input type="number" id="price" name="price" placeholder="0.00" min="0" step="0.01" 
                                       value="<%= request.getParameter("price") != null ? request.getParameter("price") : "" %>" required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="negotiable">Negotiable</label>
                            <select id="negotiable" name="negotiable">
                                <option value="yes" <%= "yes".equals(request.getParameter("negotiable")) || request.getParameter("negotiable") == null ? "selected" : "" %>>Yes, price is negotiable</option>
                                <option value="no" <%= "no".equals(request.getParameter("negotiable")) ? "selected" : "" %>>No, fixed price</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="meetup">Meetup Location <span class="required">*</span></label>
                        <select id="meetup" name="meetup_location" required>
                            <option value="">Select preferred meetup location</option>
                            <option value="library" <%= "library".equals(request.getParameter("meetup_location")) ? "selected" : "" %>>Main Library Entrance</option>
                            <option value="student-union" <%= "student-union".equals(request.getParameter("meetup_location")) ? "selected" : "" %>>Student Union Building</option>
                            <option value="cafeteria" <%= "cafeteria".equals(request.getParameter("meetup_location")) ? "selected" : "" %>>Central Cafeteria</option>
                            <option value="dorm-lobby" <%= "dorm-lobby".equals(request.getParameter("meetup_location")) ? "selected" : "" %>>Dormitory Lobby</option>
                            <option value="campus-gate" <%= "campus-gate".equals(request.getParameter("meetup_location")) ? "selected" : "" %>>Main Campus Gate</option>
                            <option value="other" <%= "other".equals(request.getParameter("meetup_location")) ? "selected" : "" %>>Other (specify in description)</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-actions">
                    <a href="browse-item.jsp" class="btn btn-secondary">Cancel</a>
                    <button type="submit" class="btn btn-primary" id="submitBtn">Submit for Approval</button>
                </div>
                
                <div class="tips-box">
                    <h4>Important:</h4>
                    <ul>
                        <li>All items require admin approval before appearing in listings</li>
                        <li>Please provide accurate information</li>
                        <li>Be responsive to buyer inquiries</li>
                        <li>Meet in safe, public locations on campus</li>
                        <li>Item will be marked as "PENDING" until approved by admin</li>
                    </ul>
                </div>
            </form>
        </div>
    </div>

    <!-- Full-size Image Preview Modal -->
    <div id="imageModal" class="image-modal">
        <span class="modal-close" id="modalClose">&times;</span>
        <div class="modal-nav">
            <button class="modal-nav-btn" id="prevBtn">
                <i class="fas fa-chevron-left"></i>
            </button>
            <button class="modal-nav-btn" id="nextBtn">
                <i class="fas fa-chevron-right"></i>
            </button>
        </div>
        <img class="modal-content" id="modalImage">
        <div class="modal-caption" id="modalCaption"></div>
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
        // Global variables for image modal
        let currentImages = [];
        let currentImageIndex = 0;
        
        // Initialize when DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            initializeImageUpload();
            initializeFormValidation();
            initializeAutoExpandingTextarea();
            initializeImageModal();
        });
        
        // Auto-expanding textarea with proper text wrapping
        function initializeAutoExpandingTextarea() {
            const descriptionTextarea = document.getElementById('description');
            
            if (!descriptionTextarea) return;
            
            // Force proper text wrapping
            descriptionTextarea.style.whiteSpace = 'pre-wrap';
            descriptionTextarea.style.wordWrap = 'break-word';
            descriptionTextarea.style.overflowWrap = 'break-word';
            
            // Function to adjust textarea height automatically
            function adjustTextareaHeight() {
                // Reset height to auto to get correct scrollHeight
                descriptionTextarea.style.height = 'auto';
                
                // Set new height based on content (with minimum height)
                const newHeight = Math.max(120, descriptionTextarea.scrollHeight);
                descriptionTextarea.style.height = newHeight + 'px';
            }
            
            // Adjust height on input
            descriptionTextarea.addEventListener('input', adjustTextareaHeight);
            
            // Adjust height on page load (if there's pre-filled text)
            setTimeout(adjustTextareaHeight, 100);
            
            // Also adjust when window resizes
            window.addEventListener('resize', adjustTextareaHeight);
            
            // Ensure proper word breaking
            descriptionTextarea.addEventListener('keydown', function(e) {
                // Allow all keys - text will wrap automatically
            });
        }
        
        // Image upload functionality
        function initializeImageUpload() {
            // Set up for each image upload area (1-3)
            for (let i = 1; i <= 3; i++) {
                const uploadArea = document.getElementById('uploadArea' + i);
                const fileInput = document.getElementById('imageUpload' + i);
                const preview = document.getElementById('imagePreview' + i);
                
                if (uploadArea && fileInput && preview) {
                    // Make upload area clickable
                    uploadArea.addEventListener('click', function() {
                        fileInput.click();
                    });
                    
                    // Handle file selection
                    fileInput.addEventListener('change', function(event) {
                        handleImageUpload(event, i);
                    });
                    
                    // Add drag and drop
                    uploadArea.addEventListener('dragover', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        this.style.borderColor = 'var(--primary-maroon)';
                        this.style.backgroundColor = 'rgba(128, 0, 0, 0.05)';
                    });
                    
                    uploadArea.addEventListener('dragleave', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        this.style.borderColor = '';
                        this.style.backgroundColor = '';
                    });
                    
                    uploadArea.addEventListener('drop', function(e) {
                        e.preventDefault();
                        e.stopPropagation();
                        this.style.borderColor = '';
                        this.style.backgroundColor = '';
                        
                        if (e.dataTransfer.files.length) {
                            const file = e.dataTransfer.files[0];
                            if (file.type.match('image.*')) {
                                // Create a new FileList
                                const dataTransfer = new DataTransfer();
                                dataTransfer.items.add(file);
                                fileInput.files = dataTransfer.files;
                                
                                // Trigger change event
                                const changeEvent = new Event('change');
                                fileInput.dispatchEvent(changeEvent);
                            } else {
                                alert('Please drop an image file (JPEG, PNG, etc.)');
                            }
                        }
                    });
                }
            }
        }
        
        // Handle image upload and preview
        function handleImageUpload(event, imageNumber) {
            const file = event.target.files[0];
            const uploadArea = document.getElementById('uploadArea' + imageNumber);
            const preview = document.getElementById('imagePreview' + imageNumber);
            
            if (!file) {
                return;
            }
            
            // Validate file type
            if (!file.type.match('image.*')) {
                alert('Please select an image file (JPEG, PNG, GIF, etc.)');
                event.target.value = '';
                return;
            }
            
            // Validate file size (5MB max)
            if (file.size > 5 * 1024 * 1024) {
                alert('File size must be less than 5MB');
                event.target.value = '';
                return;
            }
            
            // Create preview
            const reader = new FileReader();
            reader.onload = function(e) {
                // Create image preview container
                const img = document.createElement('img');
                img.src = e.target.result;
                img.alt = 'Preview ' + imageNumber;
                img.style.width = '100%';
                img.style.height = '100%';
                img.style.objectFit = 'cover';
                
                // Create remove button
                const removeBtn = document.createElement('button');
                removeBtn.type = 'button';
                removeBtn.className = 'remove-image';
                removeBtn.innerHTML = '<i class="fas fa-times"></i>';
                removeBtn.title = 'Remove this image';
                
                // Add click event to remove button
                removeBtn.addEventListener('click', function() {
                    removeImage(imageNumber);
                });
                
                // Create preview button
                const previewBtn = document.createElement('button');
                previewBtn.type = 'button';
                previewBtn.className = 'preview-image';
                previewBtn.innerHTML = '<i class="fas fa-search-plus"></i>';
                previewBtn.title = 'Preview full size';
                
                // Add click event to preview button
                previewBtn.addEventListener('click', function() {
                    openImageModal(e.target.result, 'Image ' + imageNumber, imageNumber);
                });
                
                // Clear and update preview container
                preview.innerHTML = '';
                preview.appendChild(img);
                preview.appendChild(removeBtn);
                preview.appendChild(previewBtn);
                
                // Show preview and hide upload area
                preview.classList.remove('hidden');
                uploadArea.classList.add('hidden');
                
                // Update current images array for modal navigation
                updateCurrentImages();
            };
            
            reader.onerror = function() {
                alert('Error reading file. Please try another image.');
                event.target.value = '';
            };
            
            reader.readAsDataURL(file);
        }
        
        // Remove image and reset upload area
        function removeImage(imageNumber) {
            const uploadArea = document.getElementById('uploadArea' + imageNumber);
            const preview = document.getElementById('imagePreview' + imageNumber);
            const fileInput = document.getElementById('imageUpload' + imageNumber);
            
            if (uploadArea && preview && fileInput) {
                // Clear preview
                preview.innerHTML = '';
                preview.classList.add('hidden');
                
                // Show upload area
                uploadArea.classList.remove('hidden');
                
                // Reset file input
                fileInput.value = '';
                
                // Update current images array for modal navigation
                updateCurrentImages();
            }
        }
        
        // Initialize image modal
        function initializeImageModal() {
            const modal = document.getElementById('imageModal');
            const modalClose = document.getElementById('modalClose');
            const modalImage = document.getElementById('modalImage');
            const modalCaption = document.getElementById('modalCaption');
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            
            // Close modal when clicking X
            modalClose.addEventListener('click', function() {
                closeImageModal();
            });
            
            // Close modal when clicking outside the image
            modal.addEventListener('click', function(event) {
                if (event.target === modal) {
                    closeImageModal();
                }
            });
            
            // Close modal with Escape key
            document.addEventListener('keydown', function(event) {
                if (event.key === 'Escape') {
                    closeImageModal();
                }
                if (event.key === 'ArrowLeft') {
                    showPrevImage();
                }
                if (event.key === 'ArrowRight') {
                    showNextImage();
                }
            });
            
            // Navigation buttons
            prevBtn.addEventListener('click', showPrevImage);
            nextBtn.addEventListener('click', showNextImage);
        }
        
        // Open image modal
        function openImageModal(imageSrc, caption, imageIndex) {
            const modal = document.getElementById('imageModal');
            const modalImage = document.getElementById('modalImage');
            const modalCaption = document.getElementById('modalCaption');
            
            // Update current image index
            currentImageIndex = imageIndex - 1;
            
            // Set modal content
            modalImage.src = imageSrc;
            modalCaption.textContent = caption;
            
            // Show modal
            modal.style.display = 'block';
            document.body.style.overflow = 'hidden'; // Prevent scrolling
            
            // Update navigation buttons
            updateModalNavigation();
        }
        
        // Close image modal
        function closeImageModal() {
            const modal = document.getElementById('imageModal');
            modal.style.display = 'none';
            document.body.style.overflow = 'auto'; // Restore scrolling
        }
        
        // Show previous image in modal
        function showPrevImage() {
            if (currentImages.length > 0) {
                currentImageIndex = (currentImageIndex - 1 + currentImages.length) % currentImages.length;
                const modalImage = document.getElementById('modalImage');
                const modalCaption = document.getElementById('modalCaption');
                
                modalImage.src = currentImages[currentImageIndex].src;
                modalCaption.textContent = currentImages[currentImageIndex].caption;
                updateModalNavigation();
            }
        }
        
        // Show next image in modal
        function showNextImage() {
            if (currentImages.length > 0) {
                currentImageIndex = (currentImageIndex + 1) % currentImages.length;
                const modalImage = document.getElementById('modalImage');
                const modalCaption = document.getElementById('modalCaption');
                
                modalImage.src = currentImages[currentImageIndex].src;
                modalCaption.textContent = currentImages[currentImageIndex].caption;
                updateModalNavigation();
            }
        }
        
        // Update current images array for modal navigation
        function updateCurrentImages() {
            currentImages = [];
            
            for (let i = 1; i <= 3; i++) {
                const preview = document.getElementById('imagePreview' + i);
                if (preview && !preview.classList.contains('hidden')) {
                    const img = preview.querySelector('img');
                    if (img && img.src) {
                        currentImages.push({
                            src: img.src,
                            caption: 'Image ' + i
                        });
                    }
                }
            }
        }
        
        // Update modal navigation buttons
        function updateModalNavigation() {
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            
            if (currentImages.length <= 1) {
                prevBtn.style.display = 'none';
                nextBtn.style.display = 'none';
            } else {
                prevBtn.style.display = 'flex';
                nextBtn.style.display = 'flex';
            }
        }
        
        // Form validation
        function initializeFormValidation() {
            const form = document.getElementById('sellForm');
            const submitBtn = document.getElementById('submitBtn');
            
            if (form && submitBtn) {
                form.addEventListener('submit', function(e) {
                    e.preventDefault();
                    
                    if (validateForm()) {
                        // Show loading state
                        const originalText = submitBtn.innerHTML;
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Submitting...';
                        submitBtn.disabled = true;
                        
                        // Submit the form after a short delay to show loading state
                        setTimeout(() => {
                            form.submit();
                        }, 1000);
                    }
                });
            }
        }
        
        // Validate form
        function validateForm() {
            let isValid = true;
            
            // Check item name
            const itemName = document.getElementById('item_name');
            if (!itemName.value.trim()) {
                alert('Item title is required');
                itemName.focus();
                isValid = false;
            } else if (itemName.value.trim().length < 3) {
                alert('Item title must be at least 3 characters');
                itemName.focus();
                isValid = false;
            }
            
            // Check description
            const description = document.getElementById('description');
            if (!description.value.trim()) {
                alert('Description is required');
                description.focus();
                isValid = false;
            } else if (description.value.trim().length < 20) {
                alert('Description must be at least 20 characters');
                description.focus();
                isValid = false;
            }
            
            // Check at least one image is uploaded
            const hasImage1 = document.getElementById('imagePreview1') && !document.getElementById('imagePreview1').classList.contains('hidden');
            const hasImage2 = document.getElementById('imagePreview2') && !document.getElementById('imagePreview2').classList.contains('hidden');
            const hasImage3 = document.getElementById('imagePreview3') && !document.getElementById('imagePreview3').classList.contains('hidden');
            const fileInput1 = document.getElementById('imageUpload1');
            
            if (!hasImage1 && !hasImage2 && !hasImage3 && (!fileInput1.files || fileInput1.files.length === 0)) {
                alert('Please upload at least one photo of your item (Photo 1 is required)');
                const uploadArea1 = document.getElementById('uploadArea1');
                if (uploadArea1) {
                    uploadArea1.scrollIntoView({ 
                        behavior: 'smooth',
                        block: 'center'
                    });
                }
                isValid = false;
            }
            
            // Check price
            const price = document.getElementById('price');
            const priceValue = parseFloat(price.value);
            if (!price.value || isNaN(priceValue) || priceValue <= 0) {
                alert('Please enter a valid price greater than 0');
                price.focus();
                isValid = false;
            }
            
            // Check category
            const category = document.getElementById('category');
            if (!category.value) {
                alert('Please select a category');
                category.focus();
                isValid = false;
            }
            
            // Check condition
            const condition = document.getElementById('condition');
            if (!condition.value) {
                alert('Please select item condition');
                condition.focus();
                isValid = false;
            }
            
            // Check meetup location
            const meetup = document.getElementById('meetup');
            if (!meetup.value) {
                alert('Please select a meetup location');
                meetup.focus();
                isValid = false;
            }
            
            return isValid;
        }
    </script>
</body>
</html>