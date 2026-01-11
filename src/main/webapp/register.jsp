<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Registration</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { margin: 0; padding: 0; font-family: 'Segoe UI', sans-serif; display: flex; height: 100vh; background-color: #f4f6f9; align-items: center; justify-content: center; }
        
        .container { display: flex; width: 900px; height: 550px; background: white; border-radius: 15px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        
        /* Left Side (Red) */
        .left-panel { flex: 1; background-color: #800000; color: white; padding: 40px; display: flex; flex-direction: column; justify-content: center; }
        .logo { font-size: 28px; font-weight: bold; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .description { font-size: 14px; line-height: 1.6; opacity: 0.9; }

        /* Right Side (Form) */
        .right-panel { flex: 1.2; padding: 50px; display: flex; flex-direction: column; justify-content: center; }
        h2 { color: #800000; margin-bottom: 10px; }
        .subtitle { color: #777; font-size: 14px; margin-bottom: 30px; }
        
        /* Form Inputs */
        .input-group { position: relative; margin-bottom: 15px; }
        .input-group i { position: absolute; left: 15px; top: 12px; color: #800000; }
        .input-group input { width: 100%; padding: 10px 10px 10px 40px; border: 1px solid #ddd; border-radius: 5px; outline: none; box-sizing: border-box; }
        .input-group input:focus { border-color: #800000; }

        /* Button */
        .btn-register { background-color: #800000; color: white; border: none; padding: 12px; width: 100%; border-radius: 5px; font-size: 16px; cursor: pointer; margin-top: 10px; font-weight: bold; }
        .btn-register:hover { background-color: #600000; }
        
        .login-link { text-align: center; margin-top: 20px; font-size: 13px; }
        .login-link a { color: #800000; text-decoration: none; font-weight: bold; }
    </style>
</head>
<body>

    <div class="container">
        <div class="left-panel">
            <div class="logo"><i class="fas fa-store"></i> Campus Marketplace</div>
            <p class="description">
                Join our campus community! Create an account to start buying, selling, and trading with fellow students in a secure, campus-only marketplace.
            </p>
        </div>

        <div class="right-panel">
            <h2>Student Registration</h2>
            <p class="subtitle">Create your Campus Marketplace account</p>
            
            <form action="RegisterServlet" method="POST">
                
                <div class="input-group">
                    <i class="fas fa-user"></i>
                    <input type="text" name="fullName" placeholder="Full Name" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-user-tag"></i>
                    <input type="text" name="username" placeholder="Username" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-envelope"></i>
                    <input type="email" name="email" placeholder="Student Email" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-phone"></i>
                    <input type="tel" name="phoneNumber" placeholder="Phone Number" required>
                </div>

                <div class="input-group">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" placeholder="Password" required>
                </div>

                <button type="submit" class="btn-register">Register Account</button>
                
                <div class="login-link">
                    Already have an account? <a href="login.jsp">Login</a>
                </div>
            </form>
        </div>
    </div>

</body>
</html>