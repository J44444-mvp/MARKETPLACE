<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // --- 1. CLEAN THE TOKEN AUTOMATICALLY ---
    // This removes the "|" or any bad symbols before the page even shows up.
    String token = request.getParameter("token");
    if (token != null) {
        token = token.replaceAll("[^0-9]", ""); // Keep only numbers
    } else {
        token = "";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Set New Password</title>
    <style>
        /* --- PAGE STYLING (To match your image) --- */
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f9; /* Light grey background */
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        /* --- THE CARD BOX --- */
        .container {
            background-color: white;
            width: 400px;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0px 4px 15px rgba(0,0,0,0.1); /* Soft shadow */
            text-align: center;
            position: relative; /* For the red top border */
            overflow: hidden; /* Keeps the red border inside rounded corners */
        }

        /* --- RED TOP BORDER --- */
        .top-line {
            background-color: #8B0000; /* Dark Red */
            height: 5px;
            width: 100%;
            position: absolute;
            top: 0;
            left: 0;
        }

        h2 {
            color: #8B0000; /* Dark Red Title */
            margin-bottom: 30px;
            font-weight: bold;
        }

        /* --- INPUT FIELDS --- */
        label {
            display: block;
            text-align: left;
            margin-bottom: 5px;
            color: #555;
            font-size: 14px;
        }

        input[type="text"], 
        input[type="password"] {
            width: 100%;
            padding: 12px;
            margin-bottom: 20px;
            border: 1px solid #ddd; /* Light grey border */
            border-radius: 5px;
            box-sizing: border-box; /* Ensures padding doesn't break width */
            font-size: 14px;
            color: #333;
        }
        
        /* Highlight the token box slightly so they know it's auto-filled */
        input[name="token"] {
            background-color: #fafafa; 
        }

        /* --- RED BUTTON --- */
        button {
            width: 100%;
            background-color: #8B0000;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }

        button:hover {
            background-color: #a00000; /* Slightly lighter red on hover */
        }

        /* --- ERROR MESSAGE --- */
        .error-msg {
            color: red;
            margin-top: 15px;
            font-size: 14px;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="top-line"></div>

        <h2>Set New Password</h2>

        <form action="ResetPasswordServlet" method="post">
            
            <label>Secret PIN:</label>
            <input type="text" name="token" value="<%= token %>" readonly required>

            <input type="password" name="password" placeholder="Enter New Password" required>
            <input type="password" name="confirm_password" placeholder="Confirm New Password" required>

            <button type="submit">Update Password</button>
        </form>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-msg"><%= request.getAttribute("error") %></div>
        <% } %>
    </div>

</body>
</html>