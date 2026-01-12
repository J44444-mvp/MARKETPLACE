<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Admins & Users</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* --- GENERAL STYLES --- */
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { display: flex; min-height: 100vh; background-color: #f4f6f9; margin: 0; }

        /* Sidebar */
        .sidebar { width: 260px; background-color: #800000; color: white; display: flex; flex-direction: column; padding: 20px; position: fixed; height: 100%; }
        .sidebar-header { font-size: 22px; font-weight: bold; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 20px; }
        .sidebar a { text-decoration: none; color: rgba(255, 255, 255, 0.8); padding: 15px; margin-bottom: 10px; display: block; border-radius: 8px; transition: 0.3s; }
        .sidebar a:hover { background-color: rgba(255, 255, 255, 0.1); color: white; transform: translateX(5px); }
        .sidebar a.active { background-color: white; color: #800000; font-weight: bold; }

        /* Main Content */
        .main-content { margin-left: 260px; flex: 1; padding: 40px; }
        
        .page-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 10px; margin-bottom: 20px; }
        h2 { color: #800000; margin: 0; }
        
        /* ADD ADMIN BUTTON */
        .btn-add { background-color: #800000; color: white; text-decoration: none; padding: 10px 20px; border-radius: 5px; font-weight: bold; border: none; cursor: pointer; transition: 0.3s; display: flex; align-items: center; gap: 8px; }
        .btn-add:hover { background-color: #500000; transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }

        /* Table */
        .table-container { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; }
        th { background-color: #800000; color: white; padding: 15px; text-align: left; }
        td { padding: 15px; border-bottom: 1px solid #eee; color: #333; }
        
        /* --- ADMIN ROW STYLING --- */
        .admin-row { background-color: #fff8e1; color: #5d4037; font-weight: 600; }

        /* --- ACTION BUTTONS --- */
        .action-buttons { display: flex; gap: 5px; }
        
        .btn-delete { background-color: #d32f2f; color: white; border: none; padding: 8px 12px; border-radius: 4px; cursor: pointer; transition: 0.3s; }
        .btn-delete:hover { background-color: #b71c1c; }
        
        .btn-edit { background-color: #007bff; color: white; border: none; padding: 8px 12px; border-radius: 4px; cursor: pointer; transition: 0.3s; }
        .btn-edit:hover { background-color: #0056b3; }

        /* --- PAGINATION --- */
        .pagination { display: flex; justify-content: center; margin-top: 20px; gap: 5px; }
        .pagination a { color: #800000; float: left; padding: 8px 16px; text-decoration: none; transition: background-color .3s; border: 1px solid #ddd; border-radius: 5px; background-color: white; }
        .pagination a.active { background-color: #800000; color: white; border: 1px solid #800000; }
        .pagination a:hover:not(.active) { background-color: #ddd; }

        /* --- MODAL STYLES --- */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.5); align-items: center; justify-content: center; }
        .modal-content { background-color: #fff; padding: 30px; border-radius: 8px; width: 450px; box-shadow: 0 4px 20px rgba(0,0,0,0.2); animation: fadeIn 0.3s ease-in-out; position: relative; }
        .close-btn { position: absolute; top: 15px; right: 20px; font-size: 24px; cursor: pointer; color: #888; }
        .close-btn:hover { color: #333; }
        .form-group { margin-bottom: 15px; text-align: left; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 600; color: #333; }
        .form-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 5px; font-size: 14px; }
        .form-group input:read-only { background-color: #e9ecef; cursor: not-allowed; } 
        
        .modal-buttons { margin-top: 20px; display: flex; justify-content: flex-end; gap: 10px; }
        .btn-cancel { background-color: #ccc; color: #333; padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; }
        .btn-submit { background-color: #800000; color: white; padding: 10px 20px; border-radius: 5px; border: none; cursor: pointer; }
        
        .modal-header i { font-size: 60px; color: #28a745; margin-bottom: 20px; }
        .success-text { text-align: center; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
        
        /* Warning Modal Specific Styles */
        .warning-modal .modal-header i { color: #ff9800; }
        .warning-modal .modal-content { width: 500px; }
        .warning-text { color: #d32f2f; font-weight: 600; margin: 15px 0; }
        
        /* Role Display in Table */
        .role-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            margin-left: 5px;
        }
        .role-admin { background-color: #d4af37; color: #000; }
        .role-user { background-color: #6c757d; color: white; }
        
        /* Fix for current admin2 issue - manually set role */
        .force-admin { 
            color: #d4af37 !important; 
            font-weight: bold !important;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manage_items.jsp"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp" class="active"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="admin_report.jsp"><i class="fas fa-chart-bar"></i> Reports</a>
        <a href="LogoutServlet" style="margin-top: auto;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="main-content">
        
        <div class="page-header">
            <h2>Manage Users</h2>
            <button class="btn-add" onclick="openAddModal()">
                <i class="fas fa-user-shield"></i> Add Admin
            </button>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th>Phone</th> 
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        Statement stmt = null;
                        ResultSet rs = null;
                        
                        // PAGINATION LOGIC
                        int pageId = 1;
                        int recordsPerPage = 10;
                        if(request.getParameter("page") != null) {
                            try { pageId = Integer.parseInt(request.getParameter("page")); } catch(Exception e) {}
                        }
                        int start = (pageId - 1) * recordsPerPage;
                        int totalRecords = 0;

                        try {
                            Class.forName("org.apache.derby.jdbc.ClientDriver");
                            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
                            
                            Statement countStmt = conn.createStatement();
                            ResultSet countRs = countStmt.executeQuery("SELECT COUNT(*) AS total FROM USERS");
                            if(countRs.next()) totalRecords = countRs.getInt("total");
                            countRs.close(); countStmt.close();

                            // Update admin2 to have ROLE='admin' if it exists
                            try {
                                Statement updateStmt = conn.createStatement();
                                int updated = updateStmt.executeUpdate(
                                    "UPDATE USERS SET ROLE = 'admin' WHERE USERNAME = 'admin2' AND (ROLE IS NULL OR ROLE != 'admin')"
                                );
                                if (updated > 0) {
                                    System.out.println("Updated admin2 to ROLE='admin'");
                                }
                                updateStmt.close();
                            } catch (Exception e) {
                                System.out.println("Could not update admin2 role: " + e.getMessage());
                            }
                            
                            // Query to get users, prioritizing admins
                            String sql = "SELECT * FROM USERS " +
                                         "ORDER BY " +
                                         "CASE WHEN USERNAME = 'admin' THEN 0 " +
                                         "WHEN ROLE = 'admin' THEN 1 " +
                                         "WHEN LOWER(USERNAME) LIKE 'admin%' THEN 2 " +
                                         "ELSE 3 END ASC, " +
                                         "USER_ID DESC " +
                                         "OFFSET " + start + " ROWS FETCH NEXT " + recordsPerPage + " ROWS ONLY";
                                         
                            stmt = conn.createStatement();
                            rs = stmt.executeQuery(sql);
                            
                            while(rs.next()) {
                                int id = rs.getInt("USER_ID");
                                String username = rs.getString("USERNAME");
                                String email = rs.getString("EMAIL");
                                String phone = rs.getString("PHONE_NUMBER");
                                String fullName = rs.getString("FULL_NAME");
                                
                                String jsPhone = (phone != null) ? phone : "";
                                String jsFullName = (fullName != null) ? fullName : "";
                                
                                // Determine user role
                                String role = "user";
                                boolean isAnyAdmin = false;
                                boolean isMainAdmin = "admin".equalsIgnoreCase(username);
                                
                                try {
                                    role = rs.getString("ROLE");
                                    if (role == null) {
                                        // If ROLE is null, check if username starts with admin
                                        role = username.toLowerCase().startsWith("admin") ? "admin" : "user";
                                    }
                                } catch (SQLException e) {
                                    // ROLE column doesn't exist, use username pattern
                                    role = username.toLowerCase().startsWith("admin") ? "admin" : "user";
                                }
                                
                                // Force admin2 to be admin
                                if ("admin2".equals(username)) {
                                    role = "admin";
                                }
                                
                                isAnyAdmin = "admin".equals(role);
                                
                                // Check if user has items in marketplace
                                boolean hasItems = false;
                                if (!isMainAdmin) {
                                    PreparedStatement checkStmt = conn.prepareStatement(
                                        "SELECT COUNT(*) AS item_count FROM ITEMS WHERE user_id = ?"
                                    );
                                    checkStmt.setInt(1, id);
                                    ResultSet checkRs = checkStmt.executeQuery();
                                    if (checkRs.next()) {
                                        hasItems = checkRs.getInt("item_count") > 0;
                                    }
                                    checkRs.close();
                                    checkStmt.close();
                                }
                    %>
                    <tr class="<%= isAnyAdmin ? "admin-row" : "" %>">
                        <td><%= id %></td>
                        <td>
                            <% if(isAnyAdmin) { %> 
                                <i class="fas fa-crown" style="color:#d4af37; margin-right:5px;"></i> 
                            <% } %>
                            <%= username %>
                            <span class="role-badge role-<%= role %>">
                                <%= role %>
                            </span>
                        </td>
                        <td><%= email %></td>
                        <td><%= (phone != null ? phone : "-") %></td> 
                        <td>
                            <div class="action-buttons">
                                <button class="btn-edit" onclick="openEditModal('<%=id%>', '<%=username%>', '<%=email%>', '<%=jsPhone%>', '<%=jsFullName%>')">
                                    <i class="fas fa-edit"></i> Edit
                                </button>

                                <% if(isMainAdmin) { %>
                                    <% } else { %>
                                    <form action="ManageUserServlet" method="POST" style="margin:0;" id="deleteForm<%= id %>" onsubmit="return checkUserItems(event, <%= id %>, '<%= username %>', <%= hasItems %>)">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="userId" value="<%= id %>">
                                        <input type="hidden" name="username" value="<%= username %>">
                                        <button type="submit" class="btn-delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                    <%
                            }
                        } catch(Exception e) { e.printStackTrace(); } 
                        finally { 
                            if(rs != null) rs.close();
                            if(stmt != null) stmt.close();
                            if(conn != null) conn.close(); 
                        }
                    %>
                </tbody>
            </table>
        </div>

        <% 
           int totalPages = (int) Math.ceil((double)totalRecords / recordsPerPage); 
           // Only show pagination if there's more than 1 page
           if (totalPages > 1) { 
        %>
        <div class="pagination">
            <% if(pageId > 1) { %>
                <a href="manage_user.jsp?page=<%= pageId - 1 %>">&laquo; Previous</a>
            <% } %>
            
            <% for(int i=1; i<=totalPages; i++) { %>
                <a href="manage_user.jsp?page=<%= i %>" class="<%= (i==pageId) ? "active" : "" %>"><%= i %></a>
            <% } %>

            <% if(pageId < totalPages) { %>
                <a href="manage_user.jsp?page=<%= pageId + 1 %>">Next &raquo;</a>
            <% } %>
        </div>
        <% } %>
    </div>

    <!-- Add Admin Modal -->
    <div id="addModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeAddModal()">&times;</span>
            <h3 style="margin-top:0; color:#800000;">Add New Admin</h3>
            <p style="font-size:12px; color:#666;">Username must start with 'admin'. Role will be automatically set to 'admin'.</p>
            
            <form action="AddAdminServlet" method="POST">
                <input type="hidden" name="role" value="admin">
                
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" required placeholder="admin_username">
                </div>
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required>
                </div>
                <div class="modal-buttons">
                    <button type="button" class="btn-cancel" onclick="closeAddModal()">Cancel</button>
                    <button type="submit" class="btn-submit">Add Admin</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div id="editModal" class="modal">
        <div class="modal-content">
            <span class="close-btn" onclick="closeEditModal()">&times;</span>
            <h3 style="margin-top:0; color:#007bff;">Edit User Details</h3>
            
            <form action="ManageUserServlet" method="POST">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="userId" id="edit_userId">
                
                <div class="form-group">
                    <label>Username (Cannot be changed)</label>
                    <input type="text" id="edit_username" name="username" readonly>
                </div>
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" id="edit_fullName" name="fullName" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" id="edit_email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" id="edit_phone" name="phone" required>
                </div>
                <div class="form-group">
                    <label>New Password (Leave blank to keep current)</label>
                    <input type="password" name="password" placeholder="********">
                </div>
                
                <div class="modal-buttons">
                    <button type="button" class="btn-cancel" onclick="closeEditModal()">Cancel</button>
                    <button type="submit" class="btn-submit" style="background-color: #007bff;">Update</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Success Modal -->
    <div id="successModal" class="modal">
        <div class="modal-content success-text" style="width: 400px;">
            <div class="modal-header"><i class="fas fa-check-circle"></i></div>
            <h3>Success!</h3>
            <p id="successMessage">Action completed successfully.</p>
            <button class="btn-submit" onclick="closeSuccessModal()">OK</button>
        </div>
    </div>

    <!-- Warning Modal (For items in marketplace) -->
    <div id="warningModal" class="modal warning-modal">
        <div class="modal-content success-text">
            <span class="close-btn" onclick="closeWarningModal()">&times;</span>
            <div class="modal-header"><i class="fas fa-exclamation-triangle"></i></div>
            <h3 style="color: #ff9800;">Cannot Delete User</h3>
            <p id="warningMessage">This user has items listed in the marketplace!</p>
            <div class="warning-text">
                <i class="fas fa-info-circle"></i> Please delete or transfer all items first before deleting the user.
            </div>
            <button class="btn-submit" onclick="closeWarningModal()" style="background-color: #ff9800; margin-top: 20px;">OK</button>
        </div>
    </div>

    <script>
        // Modal Functions
        function openAddModal() { document.getElementById('addModal').style.display = 'flex'; }
        function closeAddModal() { document.getElementById('addModal').style.display = 'none'; }
        
        // Edit Modal Logic
        function openEditModal(id, username, email, phone, fullName) {
            document.getElementById('edit_userId').value = id;
            document.getElementById('edit_username').value = username;
            document.getElementById('edit_email').value = email;
            document.getElementById('edit_phone').value = phone;
            document.getElementById('edit_fullName').value = fullName;
            document.getElementById('editModal').style.display = 'flex';
        }
        function closeEditModal() { document.getElementById('editModal').style.display = 'none'; }

        function closeSuccessModal() { document.getElementById('successModal').style.display = 'none'; }
        
        function closeWarningModal() { document.getElementById('warningModal').style.display = 'none'; }

        // New function to check if user has items before deletion
        function checkUserItems(event, userId, username, hasItems) {
            event.preventDefault(); // Prevent form submission
            
            if (hasItems) {
                // Show warning modal instead of confirmation
                document.getElementById('warningModal').style.display = 'flex';
                return false;
            } else {
                // If no items, show regular confirmation
                if (confirm('Are you sure you want to delete user "' + username + '"?')) {
                    // Submit the form
                    event.target.closest('form').submit();
                }
                return false;
            }
        }

        // Alert Message Logic (Reads URL params)
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const msg = urlParams.get('msg');
            
            if (msg) {
                const modal = document.getElementById('successModal');
                const text = document.getElementById('successMessage');
                
                // Specific logic for Admin vs User messages
                if (msg === 'user_deleted') {
                    text.innerText = "User deleted successfully.";
                } else if (msg === 'admin_deleted') {
                    text.innerText = "Admin deleted successfully.";
                } else if (msg === 'added') {
                    text.innerText = "New Admin added successfully!";
                } else if (msg === 'user_updated') {
                    text.innerText = "User details updated successfully!";
                } else if (msg === 'admin_updated') {
                    text.innerText = "Admin details updated successfully!";
                }
                
                modal.style.display = 'flex';
                
                // Clean URL
                window.history.replaceState({}, document.title, window.location.pathname);
            }
        }
        
        // Validate username starts with 'admin' when adding new admin
        document.addEventListener('DOMContentLoaded', function() {
            const addForm = document.querySelector('#addModal form');
            if (addForm) {
                addForm.addEventListener('submit', function(e) {
                    const usernameInput = this.querySelector('input[name="username"]');
                    const username = usernameInput.value.trim();
                    
                    if (!username.toLowerCase().startsWith('admin')) {
                        e.preventDefault();
                        alert('Username must start with "admin"! Example: admin2, admin_john, etc.');
                        usernameInput.focus();
                    }
                });
            }
        });
    </script>
</body>
</html>