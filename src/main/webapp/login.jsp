<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login - Campus Marketplace</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            /* 1. RESET & BODY */
            * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
            
            body {
                background-color: #f8f9fa;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                padding: 20px;
            }
            
            /* 2. MAIN CARD CONTAINER */
            .container {
                display: flex;
                max-width: 900px;
                width: 100%;
                height: 550px;
                background-color: white;
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
                overflow: hidden;
            }
            
            /* 3. LEFT PANEL (Maroon) */
            .left-panel {
                flex: 1;
                background-color: #800000;
                color: white;
                padding: 40px;
                display: flex;
                flex-direction: column;
                justify-content: center;
            }
            
            .logo { display: flex; align-items: center; margin-bottom: 30px; }
            .logo i { font-size: 36px; margin-right: 15px; }
            .logo h1 { font-size: 28px; font-weight: 700; }
            
            .tagline {
                font-size: 18px;
                line-height: 1.6;
                opacity: 0.9;
            }
            
            /* 4. RIGHT PANEL (Login Form) */
            .right-panel {
                flex: 1;
                padding: 50px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                background-color: white;
            }
            
            .login-header { margin-bottom: 30px; }
            .login-header h2 { color: #800000; font-size: 32px; margin-bottom: 10px; }
            .login-header p { color: #666; font-size: 16px; }
            
            /* 5. INPUTS */
            .form-group { margin-bottom: 25px; }
            .input-with-icon { position: relative; }
            
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
                outline: none;
            }
            
            .input-with-icon input:focus {
                border-color: #800000;
                box-shadow: 0 0 0 2px rgba(128, 0, 0, 0.1);
            }
            
            /* 6. LOGIN BUTTON */
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
            
            .login-button:hover { background-color: #660000; }
            
            /* 7. LINKS SECTION - SWAPPED ORDER */
            .links {
                display: flex;
                justify-content: space-between; /* Pushes first item left, second item right */
                align-items: center;
                margin-top: 25px;
                font-size: 14px;
                font-weight: 600;
            }
            
            .links a {
                color: #800000;
                text-decoration: none;
                transition: color 0.3s;
            }
            
            .links a:hover {
                color: #660000;
                text-decoration: underline;
            }
            
            /* MESSAGES */
            .error { color: #dc3545; background: rgba(220,53,69,0.1); padding: 10px; border-radius: 5px; margin-top: 15px; text-align: center; display: none; }
            .success { color: #28a745; background: rgba(40,167,69,0.1); padding: 10px; border-radius: 5px; margin-top: 15px; text-align: center; display: none; }
            .error:not(:empty), .success:not(:empty) { display: block; }
            
            /* RESPONSIVE */
            @media (max-width: 768px) {
                .container { flex-direction: column; max-width: 500px; height: auto; }
                .left-panel, .right-panel { padding: 30px; }
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
                
                <div class="error">${param.error}</div>
                <div class="success">${param.success}</div>
                
                <div class="links">
                    <a href="register.jsp">New student? Register here</a>
                    <a href="forgot_password.jsp">Forgot Password?</a>
                </div>
            </div>
        </div>

        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const errorDiv = document.querySelector('.error');
                const successDiv = document.querySelector('.success');
                
                function containsMath(text) {
                    return text.includes('\\frac') || text.includes('\\boxed') || text.includes('\\[');
                }
                
                if (errorDiv && containsMath(errorDiv.textContent)) {
                    errorDiv.textContent = 'Invalid Username or Password';
                }
                if (successDiv && containsMath(successDiv.textContent)) {
                    successDiv.textContent = 'Login Successful!';
                }
                
                setTimeout(() => {
                    if (errorDiv) errorDiv.style.display = 'none';
                    if (successDiv) successDiv.style.display = 'none';
                }, 5000);
            });
        </script>
    </body>
</html>