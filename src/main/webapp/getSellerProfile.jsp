<%@page import="java.sql.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Get seller ID from request
    String sellerIdStr = request.getParameter("sellerId");
    
    if (sellerIdStr == null || sellerIdStr.isEmpty()) {
        out.print("<div style='text-align: center; padding: 40px; color: var(--dark-gray);'>" +
                  "<i class='fas fa-exclamation-circle fa-3x' style='color: #dc3545; margin-bottom: 20px;'></i>" +
                  "<h4>Seller ID is required</h4>" +
                  "</div>");
        return;
    }
    
    try {
        int sellerId = Integer.parseInt(sellerIdStr);
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
        
        // Get seller profile information
        String sellerQuery = "SELECT full_name, email, phone_number FROM USERS WHERE user_id = ?";
        PreparedStatement sellerStmt = conn.prepareStatement(sellerQuery);
        sellerStmt.setInt(1, sellerId);
        ResultSet sellerRs = sellerStmt.executeQuery();
        
        if (!sellerRs.next()) {
            out.print("<div style='text-align: center; padding: 40px; color: var(--dark-gray);'>" +
                      "<i class='fas fa-user-slash fa-3x' style='color: #dc3545; margin-bottom: 20px;'></i>" +
                      "<h4>Seller Not Found</h4>" +
                      "<p>The seller profile could not be found.</p>" +
                      "</div>");
            sellerStmt.close();
            conn.close();
            return;
        }
        
        String sellerName = sellerRs.getString("full_name");
        String sellerEmail = sellerRs.getString("email");
        String sellerPhone = sellerRs.getString("phone_number");
        
        sellerStmt.close();
        
        // Get seller's statistics
        int activeCount = 0, soldCount = 0, totalItems = 0;
        
        // Count active items
        String activeCountQuery = "SELECT COUNT(*) as count FROM ITEMS WHERE user_id = ? AND (status = 'AVAILABLE' OR status = 'APPROVED')";
        PreparedStatement activeCountStmt = conn.prepareStatement(activeCountQuery);
        activeCountStmt.setInt(1, sellerId);
        ResultSet activeCountRs = activeCountStmt.executeQuery();
        if (activeCountRs.next()) {
            activeCount = activeCountRs.getInt("count");
        }
        activeCountStmt.close();
        
        // Count sold items
        String soldCountQuery = "SELECT COUNT(*) as count FROM ITEMS WHERE user_id = ? AND status = 'SOLD'";
        PreparedStatement soldCountStmt = conn.prepareStatement(soldCountQuery);
        soldCountStmt.setInt(1, sellerId);
        ResultSet soldCountRs = soldCountStmt.executeQuery();
        if (soldCountRs.next()) {
            soldCount = soldCountRs.getInt("count");
        }
        soldCountStmt.close();
        
        totalItems = activeCount + soldCount;
        
        // Get seller's other active listings (excluding current item if available)
        String currentItemId = request.getParameter("currentItemId");
        String otherListingsQuery = "SELECT item_id, item_name, price, image_url FROM ITEMS " +
                                   "WHERE user_id = ? AND (status = 'AVAILABLE' OR status = 'APPROVED') ";
        
        if (currentItemId != null && !currentItemId.isEmpty()) {
            otherListingsQuery += "AND item_id != ? ";
        }
        
        otherListingsQuery += "ORDER BY date_submitted DESC LIMIT 5";
        
        PreparedStatement otherListingsStmt = conn.prepareStatement(otherListingsQuery);
        otherListingsStmt.setInt(1, sellerId);
        if (currentItemId != null && !currentItemId.isEmpty()) {
            otherListingsStmt.setInt(2, Integer.parseInt(currentItemId));
        }
        ResultSet otherListingsRs = otherListingsStmt.executeQuery();
%>

<div class="seller-profile-view">
    <div class="profile-header">
        <div class="profile-avatar-large">
            <%
                if (sellerName != null && sellerName.length() >= 2) {
                    out.print(sellerName.substring(0, 2).toUpperCase());
                } else if (sellerName != null && !sellerName.isEmpty()) {
                    out.print(sellerName.substring(0, 1).toUpperCase());
                } else {
                    out.print("SU");
                }
            %>
        </div>
        <div class="profile-info-large">
            <h4><%= sellerName %></h4>
            <div class="profile-contact">
                <div><i class="fas fa-envelope"></i> <%= sellerEmail %></div>
                <%
                    if (sellerPhone != null && !sellerPhone.isEmpty() && !sellerPhone.equals("null")) {
                %>
                <div><i class="fas fa-phone"></i> <%= sellerPhone %></div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    
    <div class="profile-stats">
        <div class="profile-stat-item">
            <div class="stat-value"><%= totalItems %></div>
            <div class="stat-label">Total Items</div>
        </div>
        <div class="profile-stat-item">
            <div class="stat-value"><%= activeCount %></div>
            <div class="stat-label">Active</div>
        </div>
        <div class="profile-stat-item">
            <div class="stat-value"><%= soldCount %></div>
            <div class="stat-label">Sold</div>
        </div>
    </div>
    
    <div class="seller-listings-preview">
        <h4 class="listings-title">Other Items from This Seller</h4>
        
        <div class="preview-items">
            <%
                boolean hasOtherItems = false;
                while (otherListingsRs.next()) {
                    hasOtherItems = true;
                    int otherItemId = otherListingsRs.getInt("item_id");
                    String otherItemName = otherListingsRs.getString("item_name");
                    double otherItemPrice = otherListingsRs.getDouble("price");
                    String otherItemImage = otherListingsRs.getString("image_url");
            %>
            <a href="item-detail.jsp?id=<%= otherItemId %>" class="preview-item" onclick="window.parent.location.href='item-detail.jsp?id=<%= otherItemId %>'; window.parent.document.getElementById('sellerProfileModal').style.display='none'; return false;">
                <div class="preview-item-img">
                    <%
                        if (otherItemImage != null && !otherItemImage.isEmpty() && !otherItemImage.equals("null")) {
                    %>
                    <img src="uploads/<%= otherItemImage %>" alt="<%= otherItemName %>" 
                         onerror="this.onerror=null; this.src='https://via.placeholder.com/60/800000/ffffff?text=Img'">
                    <%
                        } else {
                    %>
                    <i class="fas fa-tag" style="color: var(--dark-gray); font-size: 24px;"></i>
                    <%
                        }
                    %>
                </div>
                <div class="preview-item-info">
                    <div class="preview-item-title"><%= otherItemName %></div>
                    <div class="preview-item-price">RM<%= String.format("%.2f", otherItemPrice) %></div>
                </div>
            </a>
            <%
                }
                
                if (!hasOtherItems) {
            %>
            <div class="no-other-items">
                <i class="fas fa-box-open" style="font-size: 48px; color: var(--medium-gray); margin-bottom: 15px;"></i>
                <p>No other active listings from this seller.</p>
            </div>
            <%
                }
            %>
        </div>
    </div>
</div>

<%
        otherListingsStmt.close();
        conn.close();
        
    } catch(Exception e) {
        e.printStackTrace();
        out.print("<div style='text-align: center; padding: 40px; color: var(--dark-gray);'>" +
                  "<i class='fas fa-exclamation-triangle fa-3x' style='color: #dc3545; margin-bottom: 20px;'></i>" +
                  "<h4>Error Loading Profile</h4>" +
                  "<p>Unable to load seller information due to a database error.</p>" +
                  "</div>");
    }
%>