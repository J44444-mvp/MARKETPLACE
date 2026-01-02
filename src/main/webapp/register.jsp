<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Register - Campus Marketplace</title>
        <style>
            /* THEME: Maroon (#800000) & White */
            body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f0f0f0; margin: 0; padding: 0; }
            
            .navbar { background-color: #800000; padding: 15px 20px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
            .navbar a { float: left; color: white; text-align: center; padding: 10px 15px; text-decoration: none; font-weight: bold; font-size: 16px; }
            .navbar a:hover { background-color: #a00000; border-radius: 4px; }
            
            .container {
                width: 400px; /* Slightly wider for registration */
                margin: 50px auto;
                background-color: white;
                padding: 40px;
                border-radius: 8px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                border-top: 6px solid #800000;
                text-align: center;
            }
            
            h2 { color: #800000; margin-bottom: 20px; }
            
            input[type="text"], input[type="password"], input[type="email"] {
                width: 100%;
                padding: 12px;
                margin: 8px 0;
                border: 1px solid #ccc;
                border-radius: 4px;
                box-sizing: border-box;
            }
            
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
                margin-top: 15px;
            }
            .btn:hover { background-color: #5a0000; }
            
            .link { display: block; margin-top: 15px; color: #800000; text-decoration: none; font-size: 14px; }
            .error { color: red; margin-top: 10px; }
        </style>
    </head>
    <body>
        
        <div class="navbar">
            <a href="login.jsp">Back to Login</a>
        </div>

        <div class="container">
            <h2>Student Registration</h2>
            <form action="RegisterServlet" method="POST">
                <input type="text" name="fullname" placeholder="Full Name" required>
                <input type="text" name="username" placeholder="Username" required>
                <input type="email" name="email" placeholder="Student Email" required>
                <input type="password" name="password" placeholder="Password" required>
                
                <button type="submit" class="btn">Register Account</button>
            </form>
            
            <div class="error">${param.error}</div>
            
            <a href="login.jsp" class="link">Already have an account? Login</a>
        </div>
        
    </body>
</html>