<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Login - Campus Marketplace</title>
        <style>
            /* THEME: Maroon (#800000) & White */
            body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f0f0f0; margin: 0; padding: 0; }
            
            /* Navbar */
            .navbar { background-color: #800000; padding: 15px 20px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
            .navbar a { float: left; color: white; text-align: center; padding: 10px 15px; text-decoration: none; font-weight: bold; font-size: 16px; }
            .navbar a:hover { background-color: #a00000; border-radius: 4px; }
            .navbar .right { float: right; }
            
            /* Login Box */
            .container {
                width: 350px;
                margin: 80px auto;
                background-color: white;
                padding: 40px;
                border-radius: 8px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                border-top: 6px solid #800000; /* Maroon Accent */
                text-align: center;
            }
            
            h2 { color: #800000; margin-bottom: 20px; }
            
            /* Inputs */
            input[type="text"], input[type="password"] {
                width: 100%;
                padding: 12px;
                margin: 10px 0;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box; /* Fixes padding width issues */
            }
            
            /* Button */
            .btn {
                width: 100%;
                background-color: #800000;
                color: white;
                padding: 12px;
                border: none;
                border-radius: 4px;
                font-size: 16px;
                cursor: pointer;
                transition: background 0.3s;
                margin-top: 10px;
            }
            .btn:hover { background-color: #5a0000; }
            
            /* Links */
            .link { display: block; margin-top: 15px; color: #800000; text-decoration: none; font-size: 14px; }
            .link:hover { text-decoration: underline; }
            
            /* Messages */
            .error { color: red; margin-top: 10px; font-size: 14px; }
            .success { color: green; margin-top: 10px; font-size: 14px; }
        </style>
    </head>
    <body>
        
        <div class="navbar">
            <a href="index.html">Campus Market</a>
            <div class="right">
                <a href="register.jsp">Sign Up</a>
            </div>
        </div>

        <div class="container">
            <h2>Login</h2>
            <form action="LoginServlet" method="POST">
                <input type="text" name="username" placeholder="Username" required>
                <input type="password" name="password" placeholder="Password" required>
                <button type="submit" class="btn">Login</button>
            </form>
            
            <div class="error">${param.error}</div>
            <div class="success">${param.success}</div>
            
            <a href="register.jsp" class="link">New student? Register here</a>
        </div>
        
    </body>
</html>