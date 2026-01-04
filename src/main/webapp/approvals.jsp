<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Pending Approvals</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        /* --- GENERAL STYLES --- */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; }

        /* SIDEBAR */
        .sidebar { width: 260px; background-color: #800000; color: white; display: flex; flex-direction: column; padding: 20px; position: fixed; height: 100%; }
        .sidebar-header { font-size: 22px; font-weight: bold; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 20px; }
        .sidebar a { text-decoration: none; color: rgba(255, 255, 255, 0.8); padding: 15px; margin-bottom: 10px; display: block; border-radius: 8px; transition: 0.3s; }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.1); color: white; transform: translateX(5px); }
        .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }

        /* MAIN CONTENT */
        .main-content { margin-left: 260px; flex: 1; padding: 40px; }
        .page-title { color: #800000; font-size: 28px; font-weight: bold; margin-bottom: 20px; border-bottom: 2px solid #ddd; padding-bottom: 10px; }

        /* TABLE STYLES */
        .approval-table { width: 100%; border-collapse: separate; border-spacing: 0; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .approval-table thead { background-color: #800000; color: white; }
        .approval-table th { padding: 15px; text-align: left; }
        .main-row { cursor: pointer; transition: background 0.2s; }
        .main-row:hover { background-color: #f9f9f9; }
        .main-row td { padding: 15px; border-bottom: 1px solid #eee; }

        /* HIDDEN DETAILS ROW */
        .details-row { display: none; background-color: #fff; border-bottom: 1px solid #eee; }
        .detail-flex-container { display: flex; padding: 20px; gap: 30px; align-items: flex-start; }
        
        /* IMAGE THUMBNAIL (Clickable) */
        .detail-image-box {
            width: 250px; height: 250px; border: 1px solid #ddd; border-radius: 8px; overflow: hidden;
            position: relative; cursor: pointer; box-shadow: 0 4px 8px rgba(0,0,0,0.1); flex-shrink: 0;
        }
        .detail-image-box img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
        .detail-image-box:hover img { transform: scale(1.05); }
        
        .click-hint {
            position: absolute; bottom: 0; width: 100%; background: rgba(0,0,0,0.6); color: white;
            text-align: center; font-size: 12px; padding: 8px; opacity: 0; transition: 0.3s;
        }
        .detail-image-box:hover .click-hint { opacity: 1; }

        /* INFO RIGHT SIDE */
        .detail-info-box { flex: 1; }
        .detail-title { color: #800000; font-size: 22px; font-weight: bold; margin-bottom: 5px; }
        .detail-meta { color: #555; font-size: 14px; margin-bottom: 15px; display: flex; flex-direction: column; gap: 5px; }
        .btn { padding: 8px 20px; border: none; border-radius: 4px; color: white; font-weight: bold; cursor: pointer; margin-right: 10px; }
        .btn-view { background-color: #555; }
        .btn-approve { background-color: #008000; }
        .btn-reject { background-color: #cc0000; }

        /* LIGHTBOX (POPUP GALLERY) */
        .lightbox {
            display: none; position: fixed; z-index: 2000; left: 0; top: 0; width: 100%; height: 100%;
            background-color: rgba(0, 0, 0, 0.9); justify-content: center; align-items: center; flex-direction: column;
        }
        .lightbox-content { 
            max-width: 85%; max-height: 85%; border-radius: 4px; box-shadow: 0 0 20px rgba(255,255,255,0.2); 
            object-fit: contain; /* Ensures the whole image is seen */
        }
        .close-lb { position: absolute; top: 20px; right: 40px; color: white; font-size: 40px; cursor: pointer; transition: 0.2s; }
        .close-lb:hover { color: #ccc; }
        
        .lb-nav {
            cursor: pointer; position: absolute; top: 50%; transform: translateY(-50%);
            color: white; font-weight: bold; font-size: 40px; padding: 20px; user-select: none; transition: 0.3s;
        }
        .lb-prev { left: 20px; }
        .lb-next { right: 20px; }
        .lb-nav:hover { background-color: rgba(255,255,255,0.1); border-radius: 5px; }
        
        /* Hide nav arrows if only 1 image */
        .hidden-arrow { display: none !important; }
        
        .image-counter { color: white; margin-top: 15px; font-size: 16px; letter-spacing: 1px; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manage_items.jsp"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp" class="active"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="LogoutServlet" style="margin-top:auto;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        <div class="page-title">Pending Approval Requests</div>

        <table class="approval-table">
            <thead>
                <tr>
                    <th>Req ID</th>
                    <th>Student Name</th>
                    <th>Item Title</th>
                    <th>Price</th>
                    <th style="text-align:right">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        Class.forName("org.apache.derby.jdbc.ClientDriver");
                        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                        
                        // FETCH 3 IMAGES NOW
                        String sql = "SELECT i.item_id, i.item_name, i.description, i.price, i.image_url, i.image_url2, i.image_url3, " +
                                     "u.username, u.phone " +
                                     "FROM ITEMS i JOIN USERS u ON i.user_id = u.user_id " +
                                     "WHERE i.status = 'PENDING'";
                        
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        
                        boolean hasData = false;
                        while(rs.next()) {
                            hasData = true;
                            int id = rs.getInt("item_id");
                            String title = rs.getString("item_name");
                            String student = rs.getString("username");
                            String phone = rs.getString("phone"); if(phone==null) phone="No phone provided";
                            String desc = rs.getString("description");
                            double price = rs.getDouble("price");
                            
                            // Get all 3 images
                            String img1 = rs.getString("image_url");
                            String img2 = rs.getString("image_url2");
                            String img3 = rs.getString("image_url3");
                            
                            // Prepare Javascript Array string: ['img1.png', 'img2.png', 'img3.png']
                            // We filter out nulls so empty slots don't break the slider
                            ArrayList<String> imgList = new ArrayList<>();
                            if(img1 != null && !img1.isEmpty()) imgList.add("'uploads/" + img1 + "'");
                            if(img2 != null && !img2.isEmpty()) imgList.add("'uploads/" + img2 + "'");
                            if(img3 != null && !img3.isEmpty()) imgList.add("'uploads/" + img3 + "'");
                            
                            String jsArray = imgList.toString(); // Produces ['...','...']
                            String mainThumb = (img1 != null) ? "uploads/" + img1 : "https://via.placeholder.com/150";
                %>

                <tr class="main-row">
                    <td><strong>#<%= id %></strong></td>
                    <td><%= student %></td>
                    <td><%= title %></td>
                    <td>$<%= price %></td>
                    <td style="text-align:right">
                        <button class="btn btn-view" onclick="toggleDetails('<%= id %>')">View <i class="fas fa-eye"></i></button>
                    </td>
                </tr>

                <tr id="details-<%= id %>" class="details-row">
                    <td colspan="5">
                        <div class="detail-flex-container">
                            
                            <div class="detail-image-box" onclick="openLightbox(<%= jsArray %>)">
                                <img src="<%= mainThumb %>" onerror="this.src='https://via.placeholder.com/300?text=No+Image'">
                                <div class="click-hint"><i class="fas fa-search-plus"></i> Click to see <%= imgList.size() %> images</div>
                            </div>

                            <div class="detail-info-box">
                                <div class="detail-title"><%= title %></div>
                                <div class="detail-meta">
                                    <span><strong>Student:</strong> <%= student %></span>
                                    <span><strong>Contact:</strong> <i class="fas fa-phone-alt"></i> <%= phone %></span>
                                </div>
                                <p style="color:#333; line-height:1.6; margin-bottom:20px;">
                                    <strong>Description:</strong><br><%= desc %>
                                </p>

                                <div style="display:flex;">
                                    <form action="ProcessItemServlet" method="POST">
                                        <input type="hidden" name="itemId" value="<%= id %>">
                                        <input type="hidden" name="action" value="approve">
                                        <button class="btn btn-approve">Approve</button>
                                    </form>
                                    <form action="ProcessItemServlet" method="POST" onsubmit="return confirm('Reject item?');">
                                        <input type="hidden" name="itemId" value="<%= id %>">
                                        <input type="hidden" name="action" value="reject">
                                        <button class="btn btn-reject">Reject</button>
                                    </form>
                                </div>
                            </div>

                        </div>
                    </td>
                </tr>

                <%
                        }
                        if(!hasData) {
                            out.println("<tr><td colspan='5' style='padding:30px; text-align:center;'>No pending approvals found.</td></tr>");
                        }
                        conn.close();
                    } catch(Exception e) { out.print(e.getMessage()); }
                %>
            </tbody>
        </table>
    </div>

    <div id="lightbox" class="lightbox">
        <span class="close-lb" onclick="closeLightbox()">&times;</span>
        
        <a class="lb-nav lb-prev" id="prevBtn" onclick="changeSlide(-1)">&#10094;</a>
        <a class="lb-nav lb-next" id="nextBtn" onclick="changeSlide(1)">&#10095;</a>

        <img id="lb-img" class="lightbox-content" src="">
        <div class="image-counter" id="img-counter">1 / 3</div>
    </div>

    <script>
        // TOGGLE ROW
        function toggleDetails(id) {
            var row = document.getElementById("details-" + id);
            row.style.display = (row.style.display === "table-row") ? "none" : "table-row";
        }

        // LIGHTBOX VARIABLES
        let currentImages = [];
        let currentIndex = 0;
        const lightbox = document.getElementById('lightbox');
        const lbImg = document.getElementById('lb-img');
        const counter = document.getElementById('img-counter');
        const prevBtn = document.getElementById('prevBtn');
        const nextBtn = document.getElementById('nextBtn');

        // OPEN LIGHTBOX
        function openLightbox(images) {
            if (!images || images.length === 0) return;
            currentImages = images;
            currentIndex = 0;
            updateLightbox();
            lightbox.style.display = 'flex';
        }

        // CLOSE LIGHTBOX
        function closeLightbox() {
            lightbox.style.display = 'none';
        }

        // CHANGE SLIDE
        function changeSlide(n) {
            currentIndex += n;
            if (currentIndex >= currentImages.length) currentIndex = 0; // Loop back to start
            if (currentIndex < 0) currentIndex = currentImages.length - 1; // Loop to end
            updateLightbox();
        }

        // UPDATE IMAGE & ARROWS
        function updateLightbox() {
            lbImg.src = currentImages[currentIndex];
            counter.innerText = (currentIndex + 1) + " / " + currentImages.length;

            // Hide arrows if only 1 image
            if (currentImages.length <= 1) {
                prevBtn.classList.add('hidden-arrow');
                nextBtn.classList.add('hidden-arrow');
                counter.style.display = 'none';
            } else {
                prevBtn.classList.remove('hidden-arrow');
                nextBtn.classList.remove('hidden-arrow');
                counter.style.display = 'block';
            }
        }

        // Close when clicking outside image
        lightbox.addEventListener('click', function(e) {
            if (e.target === lightbox) closeLightbox();
        });
        
        // Keyboard navigation
        document.addEventListener('keydown', function(e) {
            if(lightbox.style.display === 'flex') {
                if(e.key === "ArrowLeft") changeSlide(-1);
                if(e.key === "ArrowRight") changeSlide(1);
                if(e.key === "Escape") closeLightbox();
            }
        });
    </script>
</body>
</html>