<%@page import="java.sql.*" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // 1. SECURITY CHECK
    String userRole = (String) session.getAttribute("role");
    if (userRole == null || !userRole.equals("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }

    // 2. CONNECT TO DATABASE
    int studentCount = 0;
    int itemCount = 0;
    int pendingCount = 0;

    Connection conn = null;
    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");

        // Count Students
        PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) FROM USERS WHERE ROLE = 'STUDENT'");
        ResultSet rs1 = ps1.executeQuery();
        if (rs1.next()) studentCount = rs1.getInt(1);

        // Count Total Items (Using your ITEMS table)
        PreparedStatement ps2 = conn.prepareStatement("SELECT COUNT(*) FROM ITEMS");
        ResultSet rs2 = ps2.executeQuery();
        if (rs2.next()) itemCount = rs2.getInt(1);

        // Count Pending Items (Using your ITEMS table)
        PreparedStatement ps3 = conn.prepareStatement("SELECT COUNT(*) FROM ITEMS WHERE STATUS = 'PENDING'");
        ResultSet rs3 = ps3.executeQuery();
        if (rs3.next()) pendingCount = rs3.getInt(1);

    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { font-family: "Segoe UI", sans-serif; margin: 0; background-color: #f4f6f9; display: flex; }
        .sidebar { width: 250px; background-color: #2c3e50; color: white; height: 100vh; position: fixed; }
        .sidebar h2 { text-align: center; padding: 20px 0; background-color: #1a252f; margin: 0; }
        .sidebar a { display: block; color: white; padding: 15px 20px; text-decoration: none; border-bottom: 1px solid #34495e; }
        .sidebar a:hover { background-color: #34495e; }
        .sidebar .logout { background-color: #c0392b; }
        
        .content { margin-left: 250px; padding: 30px; width: 100%; }
        
        .cards { display: flex; gap: 20px; margin-bottom: 30px; }
        .card { flex: 1; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); display: flex; align-items: center; justify-content: space-between; }
        .card h3 { margin: 0; font-size: 36px; color: #2c3e50; }
        .card p { margin: 0; color: #7f8c8d; }
        .icon-box { font-size: 40px; color: #3498db; }
        .red-icon { color: #e74c3c; }

        table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #8B0000; color: white; }
        
        .btn-approve { background-color: #27ae60; color: white; padding: 8px 12px; text-decoration: none; border-radius: 4px; font-size: 14px; }
        .btn-approve:hover { background-color: #219150; }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2>Admin Panel</h2>
        <a href="#"><i class="fas fa-home"></i> Dashboard</a>
        <a href="#"><i class="fas fa-box"></i> Manage Items</a>
        <a href="LogoutServlet" class="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <div class="content">
        <h1>Welcome, Admin!</h1>
        
        <div class="cards">
            <div class="card">
                <div><h3><%= studentCount %></h3><p>Students</p></div>
                <i class="fas fa-user-graduate icon-box"></i>
            </div>
            <div class="card">
                <div><h3><%= itemCount %></h3><p>Total Items</p></div>
                <i class="fas fa-box-open icon-box"></i>
            </div>
            <div class="card">
                <div><h3><%= pendingCount %></h3><p>Pending</p></div>
                <i class="fas fa-exclamation-circle icon-box red-icon"></i>
            </div>
        </div>

        <h3>Items Waiting for Approval</h3>
        <table>
            <tr>
                <th>Item Name</th>
                <th>Seller</th>
                <th>Price</th>
                <th>Status</th>
                <th>Action</th>
            </tr>

            <%
                try {
                   // JOIN QUERY: Get Item details AND the Seller's Name from USERS table
                   String sql = "SELECT i.ITEM_ID, i.ITEM_NAME, i.PRICE, i.STATUS, u.FULL_NAME " +
                                "FROM ITEMS i " +
                                "JOIN USERS u ON i.USER_ID = u.USER_ID " +
                                "WHERE i.STATUS = 'PENDING'";
                                
                   PreparedStatement psList = conn.prepareStatement(sql);
                   ResultSet rsList = psList.executeQuery();
                   
                   while (rsList.next()) {
            %>
            <tr>
                <td><%= rsList.getString("ITEM_NAME") %></td>
                <td><%= rsList.getString("FULL_NAME") %></td> 
                <td>RM <%= rsList.getDouble("PRICE") %></td>
                <td style="color:orange; font-weight:bold;">PENDING</td>
                <td>
                    <a href="ApproveServlet?id=<%= rsList.getInt("ITEM_ID") %>" class="btn-approve">Approve</a>
                </td>
            </tr>
            <% 
                   }
                } catch(Exception e) { out.println(e.getMessage()); } 
                if(conn != null) conn.close(); 
            %>
        </table>
    </div>

</body>
</html>