<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password - Campus Marketplace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* Reusing your Maroon Theme */
        body { background-color: #f8f9fa; display: flex; justify-content: center; align-items: center; min-height: 100vh; font-family: 'Segoe UI', sans-serif; }
        .card { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 400px; text-align: center; border-top: 5px solid #800000; }
        h2 { color: #800000; margin-bottom: 10px; }
        p { color: #666; font-size: 14px; margin-bottom: 30px; }
        
        .input-group { position: relative; margin-bottom: 20px; text-align: left; }
        .input-group i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #800000; }
        .input-group input { width: 100%; padding: 12px 12px 12px 40px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        
        .btn { background-color: #800000; color: white; border: none; padding: 12px; width: 100%; border-radius: 5px; font-weight: bold; cursor: pointer; }
        .btn:hover { background-color: #660000; }
        
        .links { margin-top: 20px; font-size: 14px; }
        .links a { color: #800000; text-decoration: none; }
        .links a:hover { text-decoration: underline; }
        
        .message { margin-top: 15px; padding: 10px; border-radius: 5px; font-size: 14px; }
        .error { background-color: #f8d7da; color: #721c24; }
        .success { background-color: #d4edda; color: #155724; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Reset Password</h2>
        <p>Enter your email to receive a reset link.</p>
        
        <form action="ForgotPasswordServlet" method="POST">
            <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input type="email" name="email" placeholder="example@campus.edu" required>
            </div>
            <button type="submit" class="btn">Send Reset Link</button>
        </form>

        <% if(request.getAttribute("error") != null) { %>
            <div class="message error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if(request.getAttribute("message") != null) { %>
            <div class="message success"><%= request.getAttribute("message") %></div>
        <% } %>

        <div class="links">
            <a href="login.jsp">Back to Login</a>
        </div>
    </div>
</body>
</html>