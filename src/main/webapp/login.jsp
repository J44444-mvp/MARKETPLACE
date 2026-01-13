<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login - Campus Marketplace</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
            body { background-color: #f8f9fa; display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px; }
            .container { display: flex; max-width: 900px; width: 100%; height: 550px; background-color: white; border-radius: 15px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); overflow: hidden; position: relative; }
            
            /* LEFT PANEL */
            .left-panel { flex: 1; background-color: #800000; color: white; padding: 40px; display: flex; flex-direction: column; justify-content: center; z-index: 2; }
            .logo { display: flex; align-items: center; margin-bottom: 30px; }
            .logo i { font-size: 36px; margin-right: 15px; }
            .logo h1 { font-size: 28px; font-weight: 700; }
            .tagline { font-size: 18px; line-height: 1.6; opacity: 0.9; }
            
            /* RIGHT PANEL */
            .right-panel { flex: 1; padding: 50px; display: flex; flex-direction: column; justify-content: center; background-color: white; z-index: 2; }
            .login-header { margin-bottom: 30px; }
            .login-header h2 { color: #800000; font-size: 32px; margin-bottom: 10px; }
            .login-header p { color: #666; font-size: 16px; }
            
            /* FORM ELEMENTS */
            .form-group { margin-bottom: 25px; }
            .input-with-icon { position: relative; }
            .input-with-icon i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #800000; }
            .input-with-icon input { width: 100%; padding: 15px 15px 15px 45px; border: 1px solid #ddd; border-radius: 8px; font-size: 16px; transition: border 0.3s; outline: none; }
            .input-with-icon input:focus { border-color: #800000; box-shadow: 0 0 0 2px rgba(128, 0, 0, 0.1); }
            
            .login-button { background-color: #800000; color: white; border: none; padding: 16px; border-radius: 8px; font-size: 18px; font-weight: 600; cursor: pointer; width: 100%; transition: background-color 0.3s; margin-top: 10px; }
            .login-button:hover { background-color: #660000; }
            .login-button:disabled { background-color: #cccccc; cursor: not-allowed; }
            
            .links { display: flex; justify-content: space-between; align-items: center; margin-top: 25px; font-size: 14px; font-weight: 600; }
            .links a { color: #800000; text-decoration: none; transition: color 0.3s; }
            .links a:hover { color: #660000; text-decoration: underline; }

            /* ALERT BOX FOR ERRORS */
            .alert-error {
                background-color: #ffe6e6;
                color: #d63031;
                border: 1px solid #fab1a0;
                padding: 12px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-size: 14px;
                text-align: center;
                font-weight: 500;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
                animation: slideDown 0.5s ease-out;
            }
            
            /* MARKETPLACE THEME ANIMATION OVERLAY */
            .marketplace-animation-overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, #800000 0%, #660000 50%, #4d0000 100%);
                z-index: 3000;
                align-items: center;
                justify-content: center;
                flex-direction: column;
                animation: fadeIn 0.5s ease-out;
            }
            
            .marketplace-animation-container {
                text-align: center;
                color: white;
                max-width: 500px;
                padding: 40px;
                background: rgba(255, 255, 255, 0.1);
                border-radius: 20px;
                backdrop-filter: blur(10px);
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
            }
            
            .marketplace-animation-title {
                font-size: 32px;
                font-weight: 700;
                margin-bottom: 30px;
                color: white;
                text-shadow: 0 2px 4px rgba(0,0,0,0.2);
            }
            
            .marketplace-icons-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
                margin: 40px 0;
            }
            
            .marketplace-icon {
                font-size: 40px;
                color: white;
                animation: floatIcon 3s ease-in-out infinite;
                text-shadow: 0 4px 8px rgba(0,0,0,0.3);
            }
            
            .marketplace-icon:nth-child(1) { animation-delay: 0s; color: #ffd700; } /* Gold for money */
            .marketplace-icon:nth-child(2) { animation-delay: 0.5s; color: #32cd32; } /* Green for success */
            .marketplace-icon:nth-child(3) { animation-delay: 1s; color: #ff6b6b; } /* Red for heart */
            .marketplace-icon:nth-child(4) { animation-delay: 0.2s; color: #4ecdc4; } /* Teal for tag */
            .marketplace-icon:nth-child(5) { animation-delay: 0.7s; color: #ffd166; } /* Yellow for star */
            .marketplace-icon:nth-child(6) { animation-delay: 1.2s; color: #06d6a0; } /* Emerald for check */
            
            .marketplace-message {
                font-size: 20px;
                margin: 30px 0;
                font-weight: 600;
                color: white;
                opacity: 0.9;
            }
            
            .loading-progress {
                width: 100%;
                height: 6px;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 3px;
                overflow: hidden;
                margin: 30px 0;
            }
            
            .loading-progress-bar {
                width: 0%;
                height: 100%;
                background: linear-gradient(90deg, #ffd700, #ff6b6b, #32cd32);
                border-radius: 3px;
                animation: loadingBar 2s linear forwards;
            }
            
            .processing-text {
                font-size: 18px;
                color: rgba(255, 255, 255, 0.8);
                margin-top: 20px;
                font-weight: 500;
            }
            
            /* ANIMATIONS */
            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }
            
            @keyframes slideDown {
                from { opacity: 0; transform: translateY(-20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            
            @keyframes floatIcon {
                0%, 100% { transform: translateY(0) scale(1); }
                50% { transform: translateY(-15px) scale(1.1); }
            }
            
            @keyframes loadingBar {
                0% { width: 0%; }
                100% { width: 100%; }
            }
            
            @keyframes bounce {
                0%, 100% { transform: translateY(0); }
                50% { transform: translateY(-20px); }
            }
            
            @keyframes pulse {
                0%, 100% { opacity: 0.5; transform: scale(1); }
                50% { opacity: 1; transform: scale(1.2); }
            }
            
            @keyframes shimmer {
                0% { background-position: -200% center; }
                100% { background-position: 200% center; }
            }
        </style>
    </head>
    <body>

        <!-- Marketplace Theme Animation Overlay -->
        <div class="marketplace-animation-overlay" id="marketplaceAnimation">
            <div class="marketplace-animation-container">
                <div class="marketplace-animation-title">
                    <i class="fas fa-store"></i> Campus Marketplace
                </div>
                
                <div class="marketplace-icons-grid">
                    <div class="marketplace-icon"><i class="fas fa-money-bill-wave"></i></div>
                    <div class="marketplace-icon"><i class="fas fa-handshake"></i></div>
                    <div class="marketplace-icon"><i class="fas fa-heart"></i></div>
                    <div class="marketplace-icon"><i class="fas fa-tags"></i></div>
                    <div class="marketplace-icon"><i class="fas fa-star"></i></div>
                    <div class="marketplace-icon"><i class="fas fa-check-circle"></i></div>
                </div>
                
                <div class="marketplace-message" id="animationMessage">
                    Accessing Campus Marketplace...
                </div>
                
                <div class="loading-progress">
                    <div class="loading-progress-bar" id="progressBar"></div>
                </div>
                
                <div class="processing-text">
                    <i class="fas fa-cog fa-spin"></i> Verifying your credentials...
                </div>
            </div>
        </div>

        <div class="container">
            <div class="left-panel">
                <div class="logo">
                    <i class="fas fa-store"></i>
                    <h1>Campus Marketplace</h1>
                </div>
                <p class="tagline">
                    Buy, sell, and trade with fellow students in a secure, campus-only marketplace. Connect with your campus community today!
                </p>
            </div>
            
            <div class="right-panel">
                <div class="login-header">
                    <h2>Login</h2>
                    <p>Sign in to your Campus Marketplace account</p>
                </div>
                
                <% 
                    String error = (String) request.getAttribute("errorMessage");
                    if (error != null) {
                %>
                    <div class="alert-error" id="errorMessage">
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                    </div>
                <% 
                    } 
                %>

                <form id="loginForm" action="LoginServlet" method="POST">
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-user"></i>
                            <input type="text" name="username" placeholder="Username" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <div class="input-with-icon">
                            <i class="fas fa-lock"></i>
                            <input type="password" name="password" placeholder="Password" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="login-button" id="loginBtn">Login</button>   
                </form>
                
                <div class="links">
                    <a href="register.jsp">New student? Register</a>
                    <a href="forgot_password.jsp">Forgot Password?</a>
                </div>
            </div>
        </div>

        <script>
            // Handle form submission with marketplace theme animation
            document.getElementById('loginForm').addEventListener('submit', function(e) {
                // Prevent normal form submission temporarily
                e.preventDefault();
                
                // Get form values
                const username = document.querySelector('input[name="username"]').value;
                const password = document.querySelector('input[name="password"]').value;
                
                // Validate inputs
                if (!username || !password) {
                    alert('Please enter both username and password');
                    return;
                }
                
                // Disable button and show animation
                const loginBtn = document.getElementById('loginBtn');
                loginBtn.disabled = true;
                loginBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                
                // Show marketplace theme animation
                const animationOverlay = document.getElementById('marketplaceAnimation');
                const animationMessage = document.getElementById('animationMessage');
                const progressBar = document.getElementById('progressBar');
                
                // Set personalized message
                animationMessage.textContent = `Welcome back, ${username}! Accessing Campus Marketplace...`;
                
                // Reset progress bar animation
                progressBar.style.animation = 'none';
                void progressBar.offsetWidth; // Trigger reflow
                progressBar.style.animation = 'loadingBar 2s linear forwards';
                
                // Show animation
                animationOverlay.style.display = 'flex';
                
                // Simulate processing for 2 seconds
                setTimeout(() => {
                    // After 2 seconds, submit the form normally
                    this.submit();
                }, 2000);
            });
            
            // Auto-hide error messages after 5 seconds
            window.onload = function() {
                const errorDiv = document.getElementById('errorMessage');
                if (errorDiv) {
                    setTimeout(function() {
                        errorDiv.style.opacity = '0';
                        setTimeout(function() {
                            errorDiv.style.display = 'none';
                        }, 300);
                    }, 5000);
                }
            };
        </script>

    </body>
</html>