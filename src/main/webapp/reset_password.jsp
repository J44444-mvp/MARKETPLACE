<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Set New Password - Campus Marketplace</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; display: flex; justify-content: center; align-items: center; min-height: 100vh; font-family: 'Segoe UI', sans-serif; }
        .card { background: white; padding: 40px; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); width: 100%; max-width: 400px; text-align: center; border-top: 5px solid #800000; }
        h2 { color: #800000; margin-bottom: 20px; }
        
        .input-group { position: relative; margin-bottom: 15px; text-align: left; }
        .input-group label { display: block; font-size: 12px; color: #666; margin-bottom: 5px; }
        .input-group i { position: absolute; left: 15px; top: 38px; color: #800000; }
        /* Adjusted padding for input with label */
        .input-group input { width: 100%; padding: 12px 12px 12px 40px; border: 1px solid #ddd; border-radius: 5px; box-sizing: border-box; }
        
        /* Token field specific style */
        .token-field input { background-color: #e9ecef; color: #666; cursor: not-allowed; }
        
        .btn { background-color: #800000; color: white; border: none; padding: 12px; width: 100%; border-radius: 5px; font-weight: bold; cursor: pointer; margin-top: 10px; }
        .btn:hover { background-color: #660000; }
        
        .error { color: #dc3545; background: rgba(220,53,69,0.1); padding: 10px; border-radius: 5px; margin-top: 15px; }
        .message { color: #28a745; background: rgba(40,167,69,0.1); padding: 10px; border-radius: 5px; margin-top: 15px; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Set New Password</h2>
        
        <form action="ResetPasswordServlet" method="POST">
            
            <div class="input-group token-field">
                <label>Security Token (Do not edit)</label>
                <i class="fas fa-key"></i>
                <input type="text" name="token" value="${param.token}" readonly required>
            </div>
            
            <div class="input-group">
                <label>New Password</label>
                <i class="fas fa-lock"></i>
                <input type="password" name="password" placeholder="Enter new password" required>
            </div>
            
            <div class="input-group">
                <label>Confirm Password</label>
                <i class="fas fa-check-circle"></i>
                <input type="password" name="confirm_password" placeholder="Repeat password" required>
            </div>
            
            <button type="submit" class="btn">Update Password</button>
        </form>
        
        <% if(request.getAttribute("error") != null) { %>
            <div class="error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if(request.getAttribute("message") != null) { %>
            <div class="message"><%= request.getAttribute("message") %></div>
        <% } %>
    </div>
</body>
</html>