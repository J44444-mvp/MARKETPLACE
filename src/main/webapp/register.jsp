<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Register - Campus Marketplace</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            
            body {
                background-color: #f8f9fa;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                padding: 20px;
            }
            
            .container {
                display: flex;
                max-width: 1000px;
                width: 100%;
                background-color: white;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                overflow: hidden;
            }
            
            .left-panel {
                flex: 1;
                background-color: #800000; /* Maroon */
                color: white;
                padding: 60px 40px;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }
            
            .logo {
                display: flex;
                align-items: center;
                margin-bottom: 30px;
            }
            
            .logo i {
                font-size: 36px;
                margin-right: 15px;
            }
            
            .logo h1 {
                font-size: 28px;
                font-weight: 700;
            }
            
            .tagline {
                font-size: 18px;
                line-height: 1.6;
                margin-bottom: 40px;
                opacity: 0.9;
            }
            
            .right-panel {
                flex: 1;
                padding: 60px 40px;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }
            
            .login-header {
                margin-bottom: 40px;
            }
            
            .login-header h2 {
                color: #800000;
                font-size: 32px;
                margin-bottom: 10px;
            }
            
            .login-header p {
                color: #666;
                font-size: 16px;
            }
            
            .form-group {
                margin-bottom: 25px;
            }
            
            .input-with-icon {
                position: relative;
            }
            
            .input-with-icon i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #800000;
            }
            
            .input-with-icon input {
                width: 100%;
                padding: 15px 15px 15px 45px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 16px;
                transition: border 0.3s;
            }
            
            .input-with-icon input:focus {
                border-color: #800000;
                outline: none;
                box-shadow: 0 0 0 2px rgba(128, 0, 0, 0.1);
            }
            
            .login-button {
                background-color: #800000;
                color: white;
                border: none;
                padding: 16px;
                border-radius: 8px;
                font-size: 18px;
                font-weight: 600;
                cursor: pointer;
                width: 100%;
                transition: background-color 0.3s;
                margin-top: 10px;
            }
            
            .login-button:hover {
                background-color: #660000;
            }
            
            .login-button:active {
                transform: translateY(1px);
            }
            
            .links {
                display: flex;
                justify-content: space-between;
                margin-top: 25px;
            }
            
            .links a {
                color: #800000;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s;
                font-size: 15px;
                flex: 1;
                text-align: center;
                padding: 0 10px;
            }
            
            .links a:hover {
                color: #660000;
                text-decoration: underline;
            }
            
            /* Hidden by default, shown only when needed */
            .error {
                background-color: rgba(220, 53, 69, 0.1);
                color: #dc3545;
                padding: 12px;
                border-radius: 8px;
                margin-top: 15px;
                text-align: center;
                font-size: 14px;
                font-weight: 500;
                border: 1px solid rgba(220, 53, 69, 0.2);
                display: none; /* Hidden by default */
                animation: fadeIn 0.5s ease-out;
            }
            
            .success {
                background-color: rgba(40, 167, 69, 0.1);
                color: #28a745;
                padding: 12px;
                border-radius: 8px;
                margin-top: 15px;
                text-align: center;
                font-size: 14px;
                font-weight: 500;
                border: 1px solid rgba(40, 167, 69, 0.2);
                display: none; /* Hidden by default */
                animation: fadeIn 0.5s ease-out;
            }
            
            /* Show when they have content */
            .error:not(:empty) {
                display: block;
            }
            
            .success:not(:empty) {
                display: block;
            }
            
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            
            @media (max-width: 768px) {
                .container {
                    flex-direction: column;
                    max-width: 500px;
                }
                
                .left-panel {
                    padding: 40px 30px;
                }
                
                .right-panel {
                    padding: 40px 30px;
                }
            }
            
            @media (max-width: 480px) {
                .links {
                    flex-direction: column;
                    gap: 15px;
                    align-items: center;
                }
                
                .links a {
                    width: 100%;
                    padding: 10px 0;
                }
                
                .left-panel, .right-panel {
                    padding: 30px 20px;
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Left Panel with branding -->
            <div class="left-panel">
                <div class="logo">
                    <i class="fas fa-store"></i>
                    <h1>Campus Marketplace</h1>
                </div>
                
                <p class="tagline">
                    Join our campus community! Create an account to start buying, selling, and trading with fellow students in a secure, campus-only marketplace.
                </p>
            </div>
            
            <!-- Right Panel with registration form -->
            <div class="right-panel">
                <div class="login-header">
                    <h2>Student Registration</h2>
                    <p>Create your Campus Marketplace account</p>
                </div>
                
                <form action="RegisterServlet" method="POST">
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-user-circle"></i>
                            <input type="text" name="fullname" placeholder="Full Name" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" name="username" placeholder="Username" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-envelope"></i>
                            <input type="email" name="email" placeholder="Student Email" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" name="password" placeholder="Password" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="login-button">Register Account</button>
                </form>
                
                <!-- These will only show when they have content -->
                <div class="error">${param.error}</div>
                <div class="success">${param.success}</div>
                
                <div class="links">
                    <a href="login.jsp">Already have an account? Login</a>
                </div>
            </div>
        </div>
        
        <script>
            // Hide the mathematical equation if it appears
            document.addEventListener('DOMContentLoaded', function() {
                // Check if error/success divs contain mathematical equations and hide them
                const errorDiv = document.querySelector('.error');
                const successDiv = document.querySelector('.success');
                
                // Function to check if text contains LaTeX/math equations
                function containsMath(text) {
                    return text.includes('\\frac') || text.includes('\\boxed') || text.includes('\\[');
                }
                
                // Clean error div if it contains math
                if (errorDiv && containsMath(errorDiv.textContent)) {
                    // Check for common registration errors
                    const errorText = errorDiv.textContent.toLowerCase();
                    if (errorText.includes('username') || errorText.includes('exists')) {
                        errorDiv.textContent = 'Username already exists. Please choose another.';
                    } else if (errorText.includes('email') || errorText.includes('invalid')) {
                        errorDiv.textContent = 'Invalid or duplicate email address.';
                    } else {
                        errorDiv.textContent = 'Registration failed. Please check your information.';
                    }
                    errorDiv.style.display = 'block';
                }
                
                // Clean success div if it contains math
                if (successDiv && containsMath(successDiv.textContent)) {
                    successDiv.textContent = 'Registration Successful! You can now login.';
                    successDiv.style.display = 'block';
                    
                    // Optionally redirect to login page after 3 seconds
                    setTimeout(() => {
                        window.location.href = 'login.jsp';
                    }, 3000);
                }
                
                // Auto-hide messages after 5 seconds
                setTimeout(() => {
                    if (errorDiv && errorDiv.textContent.trim()) {
                        errorDiv.style.display = 'none';
                    }
                    if (successDiv && successDiv.textContent.trim()) {
                        successDiv.style.display = 'none';
                    }
                }, 5000);
                
                // Add client-side validation
                const form = document.querySelector('form');
                if (form) {
                    form.addEventListener('submit', function(e) {
                        const fullname = this.querySelector('[name="fullname"]').value.trim();
                        const username = this.querySelector('[name="username"]').value.trim();
                        const email = this.querySelector('[name="email"]').value.trim();
                        const password = this.querySelector('[name="password"]').value.trim();
                        
                        // Client-side validation
                        if (!fullname || !username || !email || !password) {
                            e.preventDefault();
                            const errorDiv = document.querySelector('.error');
                            if (errorDiv) {
                                errorDiv.textContent = 'Please fill in all fields.';
                                errorDiv.style.display = 'block';
                            }
                            return false;
                        }
                        
                        // Email validation
                        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                        if (!emailRegex.test(email)) {
                            e.preventDefault();
                            const errorDiv = document.querySelector('.error');
                            if (errorDiv) {
                                errorDiv.textContent = 'Please enter a valid email address.';
                                errorDiv.style.display = 'block';
                            }
                            return false;
                        }
                        
                        // Add loading state to button
                        const submitBtn = this.querySelector('.login-button');
                        const originalText = submitBtn.innerHTML;
                        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Creating Account...';
                        submitBtn.disabled = true;
                        
                        // Re-enable button if form doesn't submit (fallback)
                        setTimeout(() => {
                            submitBtn.innerHTML = originalText;
                            submitBtn.disabled = false;
                        }, 3000);
                    });
                }
            });
        </script>
    </body>
</html>