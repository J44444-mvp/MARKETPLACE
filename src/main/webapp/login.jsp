<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login - Campus Marketplace</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* YOUR ORIGINAL STYLES */
            * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
            body { background-color: #f8f9fa; display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px; }
            .container { display: flex; max-width: 900px; width: 100%; height: 550px; background-color: white; border-radius: 15px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); overflow: hidden; }
            
            /* LEFT PANEL */
            .left-panel { flex: 1; background-color: #800000; color: white; padding: 40px; display: flex; flex-direction: column; justify-content: center; }
            .logo { display: flex; align-items: center; margin-bottom: 30px; }
            .logo i { font-size: 36px; margin-right: 15px; }
            .logo h1 { font-size: 28px; font-weight: 700; }
            .tagline { font-size: 18px; line-height: 1.6; opacity: 0.9; }
            
            /* RIGHT PANEL */
            .right-panel { flex: 1; padding: 50px; display: flex; flex-direction: column; justify-content: center; background-color: white; }
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
            }
        </style>
    </head>
    <body>

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
                    <div class="alert-error">
                        <i class="fas fa-exclamation-circle"></i> <%= error %>
                    </div>
                <% 
                    } 
                %>

                <form action="LoginServlet" method="POST">
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
                    
                    <button type="submit" class="login-button">Login</button>   
                </form>
                
                <div class="links">
                    <a href="register.jsp">New student? Register</a>
                    <a href="forgot_password.jsp">Forgot Password?</a>
                </div>
            </div>
        </div>

    </body>
</html>