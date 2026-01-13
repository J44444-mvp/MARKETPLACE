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
        
        /* Success Modal Styles */
        .modal { 
            display: none; 
            position: fixed; 
            top: 0; 
            left: 0; 
            width: 100%; 
            height: 100%; 
            background-color: rgba(0,0,0,0.5); 
            z-index: 1000; 
            align-items: center; 
            justify-content: center; 
        }
        
        .modal-content { 
            background: white; 
            padding: 40px; 
            border-radius: 10px; 
            text-align: center; 
            max-width: 400px; 
            width: 90%; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.2); 
            animation: modalFadeIn 0.5s; 
        }
        
        .success-icon { 
            font-size: 60px; 
            color: #28a745; 
            margin-bottom: 20px; 
            animation: successIcon 0.5s ease-in-out; 
        }
        
        .modal h3 { 
            color: #800000; 
            margin-bottom: 10px; 
        }
        
        .modal p { 
            color: #666; 
            margin-bottom: 25px; 
        }
        
        .modal-btn { 
            background-color: #800000; 
            color: white; 
            border: none; 
            padding: 12px 25px; 
            border-radius: 5px; 
            cursor: pointer; 
            font-size: 16px; 
        }
        
        .modal-btn:hover { 
            background-color: #600000; 
        }
        
        /* Error Message Style */
        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #f5c6cb;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
        }
        
        .error-message i {
            color: #dc3545;
        }
        
        /* Animations */
        @keyframes modalFadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes successIcon {
            0% { transform: scale(0); }
            70% { transform: scale(1.2); }
            100% { transform: scale(1); }
        }
    </style>
</head>
<body>

    <!-- Success Modal -->
    <div class="modal" id="successModal">
        <div class="modal-content">
            <div class="success-icon">
                <i class="fas fa-check-circle"></i>
            </div>
            <h3>Registration Successful!</h3>
            <p>Your account has been created successfully. You can now login to your account.</p>
            <button class="modal-btn" onclick="closeSuccessModal()">OK</button>
        </div>
    </div>

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
            
            <%-- Check for error messages --%>
            <%
                String status = request.getParameter("status");
                String message = request.getParameter("message");
                
                if ("error".equals(status) && message != null) {
            %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i> <%= message %>
            </div>
            <script>
                // Auto-hide error after 5 seconds
                setTimeout(function() {
                    var errorDiv = document.querySelector('.error-message');
                    if (errorDiv) {
                        errorDiv.style.opacity = '0';
                        setTimeout(function() {
                            errorDiv.style.display = 'none';
                        }, 300);
                    }
                }, 5000);
            </script>
            <% } %>
            
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

    <script>
        // Check URL parameters for success
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');
            
            if (status === 'success') {
                document.getElementById('successModal').style.display = 'flex';
                
                // Clean the URL
                const url = new URL(window.location.href);
                url.searchParams.delete('status');
                url.searchParams.delete('message');
                window.history.replaceState({}, document.title, url);
            }
        };
        
        function closeSuccessModal() {
            document.getElementById('successModal').style.display = 'none';
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('successModal');
            if (event.target === modal) {
                closeSuccessModal();
            }
        }
    </script>

</body>
</html>