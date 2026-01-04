<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Pending Approvals</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- GENERAL STYLES --- */
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; margin: 0; }

        /* --- SIDEBAR --- */
        .sidebar { 
            width: 260px; 
            background-color: #800000; 
            color: white; 
            display: flex; 
            flex-direction: column; 
            padding: 20px; 
            position: fixed; 
            height: 100%; 
        }
        
        .sidebar-header { font-size: 22px; font-weight: bold; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 20px; }
        
        .sidebar a { 
            text-decoration: none; 
            color: rgba(255, 255, 255, 0.8); 
            padding: 15px; 
            margin-bottom: 10px; 
            display: block; 
            border-radius: 8px; 
            transition: 0.3s; 
        }
        
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.1); color: white; transform: translateX(5px); }
        .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }

        /* --- MAIN CONTENT --- */
        .main-content { margin-left: 260px; flex: 1; padding: 40px; }
        h2 { color: #800000; margin-bottom: 20px; border-bottom: 2px solid #ddd; padding-bottom: 10px; }

        /* Table Styles */
        .requests-table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .requests-table th { background-color: #800000; color: white; padding: 15px; text-align: left; }
        .requests-table td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; }
        
        .btn { padding: 8px 15px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; margin-right: 5px; color: white; }
        .btn-view { background-color: #555; }
        .btn-approve { background-color: green; }
        .btn-reject { background-color: #cc0000; }
        
        /* Expansion Panel */
        .details-row { display: none; background-color: #fafafa; }
        .details-content { padding: 20px; display: flex; gap: 30px; border-left: 5px solid #800000; }
        
        /* Image Slider Box */
        .image-box { width: 250px; height: 250px; background: #ddd; border-radius: 8px; overflow: hidden; position: relative; cursor: pointer; }
        .image-box img { width: 100%; height: 100%; object-fit: cover; }
        
        /* Modal for Lightbox */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.9); justify-content: center; align-items: center; }
        .modal img { max-width: 80%; max-height: 80%; border: 5px solid white; border-radius: 5px; }
        .close { position: absolute; top: 20px; right: 35px; color: #f1f1f1; font-size: 40px; font-weight: bold; cursor: pointer; }
        .arrow { position: absolute; top: 50%; color: white; font-size: 50px; cursor: pointer; user-select: none; padding: 10px; background: rgba(0,0,0,0.5); border-radius: 5px; }
        .prev { left: 20px; }
        .next { right: 20px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>
        
        <a href="admin_dashboard.jsp" class="<%= request.getRequestURI().contains("admin_dashboard.jsp") ? "active" : "" %>">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>

        <a href="manage_items.jsp" class="<%= request.getRequestURI().contains("manage_items.jsp") ? "active" : "" %>">
            <i class="fas fa-boxes"></i> Manage Items
        </a>

        <a href="manage_user.jsp" class="<%= request.getRequestURI().contains("manage_user.jsp") ? "active" : "" %>">
            <i class="fas fa-users"></i> Users
        </a>

        <a href="approvals.jsp" class="<%= request.getRequestURI().contains("approvals.jsp") ? "active" : "" %>">
            <i class="fas fa-check-circle"></i> Approvals
        </a>
        
        <a href="admin_report.jsp" class="<%= request.getRequestURI().contains("admin_report.jsp") ? "active" : "" %>">
            <i class="fas fa-chart-bar"></i> Reports
        </a>
        
        <a href="LogoutServlet" style="margin-top:auto;">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>

    <div class="main-content">
        <h2>Pending Approval Requests</h2>

        <table class="requests-table">
            <thead>
                <tr>
                    <th>Req ID</th>
                    <th>Student Name</th>
                    <th>Item Title</th>
                    <th>Date Submitted</th>
                    <th>Price</th>
                    <th style="text-align:right">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                        
                        String sql = "SELECT i.item_id, i.item_name, i.description, i.price, i.date_submitted, " +
                                     "i.image_url, i.image_url2, i.image_url3, u.username, u.phone " +
                                     "FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id " +
                                     "WHERE i.status = 'PENDING'";
                        
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);

                        boolean hasData = false;
                        SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");

                        while(rs.next()) {
                            hasData = true;
                            int id = rs.getInt("item_id");
                            String title = rs.getString("item_name");
                            String desc = rs.getString("description");
                            double price = rs.getDouble("price");
                            String student = rs.getString("username");
                            String phone = rs.getString("phone");
                            
                            String img1 = rs.getString("image_url");
                            String img2 = rs.getString("image_url2");
                            String img3 = rs.getString("image_url3");
                            
                            Timestamp ts = rs.getTimestamp("date_submitted");
                            String dateStr = (ts != null) ? sdf.format(ts) : "Unknown";
                %>

                <tr class="main-row">
                    <td><strong>#<%= id %></strong></td>
                    <td><%= student %></td>
                    <td><%= title %></td>
                    <td style="color:#666; font-size:14px;"><%= dateStr %></td>
                    <td>$<%= price %></td>
                    <td style="text-align:right">
                        <button class="btn btn-view" onclick="toggleDetails('<%= id %>')">View <i class="fas fa-eye"></i></button>
                    </td>
                </tr>

                <tr id="details-<%= id %>" class="details-row">
                    <td colspan="6">
                        <div class="details-content">
                            <div class="image-box" onclick="openModal('<%= img1 %>', '<%= img2 %>', '<%= img3 %>')">
                                <img src="uploads/<%= img1 %>" onerror="this.src='https://via.placeholder.com/250?text=No+Image'">
                                <div style="position:absolute; bottom:0; background:rgba(0,0,0,0.6); color:white; width:100%; text-align:center; padding:5px; font-size:12px;">
                                    <i class="fas fa-search-plus"></i> Click to Enlarge
                                </div>
                            </div>

                            <div class="info-box">
                                <h3 style="color:#800000; margin-top:0;"><%= title %></h3>
                                <p><strong>Student:</strong> <%= student %></p>
                                <p><strong>Contact:</strong> <i class="fas fa-phone"></i> <%= phone %></p>
                                <br>
                                <p><strong>Description:</strong></p>
                                <p style="color:#555; line-height:1.5;"><%= desc %></p>
                                <br>
                                <div style="display:flex; gap:10px;">
                                    <form action="ProcessItemServlet" method="POST">
                                        <input type="hidden" name="itemId" value="<%= id %>">
                                        <input type="hidden" name="action" value="approve">
                                        <button type="submit" class="btn btn-approve">Approve</button>
                                    </form>

                                    <form action="ProcessItemServlet" method="POST">
                                        <input type="hidden" name="itemId" value="<%= id %>">
                                        <input type="hidden" name="action" value="reject">
                                        <button type="submit" class="btn btn-reject">Reject</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </td>
                </tr>

                <% 
                        } 
                        if(!hasData) {
                %>
                    <tr><td colspan="6" style="text-align:center; padding:30px;">No pending approvals found.</td></tr>
                <%
                        }
                        conn.close();
                    } catch(Exception e) {
                        e.printStackTrace();
                    }
                %>
            </tbody>
        </table>
    </div>

    <div id="imageModal" class="modal">
        <span class="close" onclick="closeModal()">&times;</span>
        <span class="arrow prev" onclick="changeSlide(-1)">&#10094;</span>
        <img id="modalImg" src="">
        <span class="arrow next" onclick="changeSlide(1)">&#10095;</span>
    </div>

    <script>
        function toggleDetails(id) {
            var row = document.getElementById('details-' + id);
            row.style.display = (row.style.display === 'table-row') ? 'none' : 'table-row';
        }

        let currentImages = [];
        let currentIndex = 0;

        function openModal(img1, img2, img3) {
            currentImages = [];
            if(img1 && img1 !== 'null') currentImages.push('uploads/' + img1);
            if(img2 && img2 !== 'null') currentImages.push('uploads/' + img2);
            if(img3 && img3 !== 'null') currentImages.push('uploads/' + img3);

            if(currentImages.length > 0) {
                currentIndex = 0;
                document.getElementById('modalImg').src = currentImages[0];
                document.getElementById('imageModal').style.display = "flex";
            }
        }

        function closeModal() {
            document.getElementById('imageModal').style.display = "none";
        }

        function changeSlide(direction) {
            if(currentImages.length === 0) return;
            currentIndex += direction;
            if(currentIndex >= currentImages.length) currentIndex = 0;
            if(currentIndex < 0) currentIndex = currentImages.length - 1;
            document.getElementById('modalImg').src = currentImages[currentIndex];
        }
    </script>

</body>
</html>