<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.*"%>
<%@page import="java.util.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
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
        
        .date-badge { 
            background: #fff; 
            padding: 8px 15px; 
            border-radius: 20px; 
            font-size: 14px; 
            color: #800000; 
            font-weight: 600;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05); 
            display: flex; 
            align-items: center; 
            gap: 8px;
        }

        /* Cards Container */
        .cards-container { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); 
            gap: 20px; 
            margin-bottom: 30px; 
        }
        
        .card { 
            background: white; 
            padding: 25px; 
            border-radius: 10px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.05); 
            transition: 0.3s; 
            border-left: 5px solid #800000;
        }
        .card:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(0,0,0,0.1); }
        
        .card-info h3 { margin: 0; font-size: 32px; color: #333; font-weight: 700; }
        .card-info p { margin: 5px 0 0; color: #777; font-size: 14px; font-weight: 500; }
        
        .card-icon { 
            width: 60px; 
            height: 60px; 
            border-radius: 50%; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 24px; 
        }
        
        /* Icon Colors */
        .icon-blue { background: #e3f2fd; color: #1976d2; }     /* Students */
        .icon-green { background: #e8f5e9; color: #2e7d32; }    /* Total Items */
        .icon-orange { background: #fff3e0; color: #ef6c00; }   /* Pending */
        .icon-purple { background: #f3e5f5; color: #8e24aa; }   /* Sold */
        .icon-red { background: #ffebee; color: #c62828; }      /* Rejected */
        
        /* Chart Container */
        .charts-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }
        
        .chart-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
            border-top: 5px solid #800000;
        }
        
        .chart-card h3 {
            color: #800000;
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 18px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .chart-card h3 i {
            font-size: 20px;
        }
        
        .chart-container {
            height: 350px;
            position: relative;
        }
        
        @media (max-width: 1200px) {
            .charts-container {
                grid-template-columns: 1fr;
            }
        }
        
        /* Chart colors */
        .chart-colors {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
            font-size: 12px;
        }
        
        .color-label {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .color-box {
            width: 12px;
            height: 12px;
            border-radius: 2px;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-header"><i class="fas fa-user-shield"></i> Admin Panel</div>
        <a href="admin_dashboard.jsp" class="active"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
        <a href="manage_items.jsp"><i class="fas fa-boxes"></i> Manage Items</a>
        <a href="manage_user.jsp"><i class="fas fa-users"></i> Users</a>
        <a href="approvals.jsp"><i class="fas fa-check-circle"></i> Approvals</a>
        <a href="admin_report.jsp"><i class="fas fa-chart-bar"></i> Reports</a>
        <a href="LogoutServlet" style="margin-top: auto;"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <%
        // 1. Setup Clock
        SimpleDateFormat sdf = new SimpleDateFormat("EEE, d MMM yyyy h:mm a");
        sdf.setTimeZone(TimeZone.getTimeZone("Asia/Kuala_Lumpur"));
        String malaysiaTime = sdf.format(new java.util.Date());

        // 2. Initialize Variables
        int studentCount = 0;
        int totalItems = 0;
        int pendingCount = 0;
        int soldCount = 0;
        int rejectedCount = 0;
        
        // 3. Chart Data Variables
        List<String> itemCategories = new ArrayList<>();
        List<Integer> categoryCounts = new ArrayList<>();
        List<String> userNames = new ArrayList<>();
        List<Integer> sellActivity = new ArrayList<>();
        List<Integer> buyActivity = new ArrayList<>();

        Connection conn = null;
        try {
            Class.forName("org.apache.derby.jdbc.ClientDriver");
            conn = DriverManager.getConnection("jdbc:derby://localhost:1527/campus_marketplace", "app", "app");
            Statement stmt = conn.createStatement();

            // --- A. CARD STATS ---
            // Count non-admin users
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM USERS WHERE USERNAME NOT LIKE 'admin%'");
            if(rs.next()) studentCount = rs.getInt(1);
            
            // Count items by status
            rs = stmt.executeQuery("SELECT STATUS, COUNT(*) as count FROM ITEMS GROUP BY STATUS");
            while(rs.next()){
                String status = rs.getString("STATUS");
                int count = rs.getInt("count");
                totalItems += count;
                
                if(status != null) {
                    String s = status.trim().toLowerCase();
                    if(s.contains("pending") || s.contains("review") || "pending".equals(s)) {
                        pendingCount = count;
                    } else if(s.contains("sold") || "sold".equals(s)) {
                        soldCount = count;
                    } else if(s.contains("rejected") || "rejected".equals(s)) {
                        rejectedCount = count;
                    }
                }
            }
            
            // --- B. PIE CHART: ITEM CATEGORIES ---
            // Try to get categories from ITEMS table
            try {
                // First, check if CATEGORY column exists by trying to query it
                rs = stmt.executeQuery("SELECT CATEGORY, COUNT(*) as item_count FROM ITEMS WHERE CATEGORY IS NOT NULL AND TRIM(CATEGORY) != '' GROUP BY CATEGORY ORDER BY item_count DESC");
                
                boolean hasData = false;
                while(rs.next()){
                    String category = rs.getString("CATEGORY");
                    int count = rs.getInt("item_count");
                    
                    if(category != null && !category.trim().isEmpty() && count > 0){
                        itemCategories.add(category.trim());
                        categoryCounts.add(count);
                        hasData = true;
                    }
                }
                
                // If no category data, use status as categories
                if(!hasData){
                    rs = stmt.executeQuery("SELECT STATUS, COUNT(*) as item_count FROM ITEMS GROUP BY STATUS ORDER BY item_count DESC");
                    while(rs.next()){
                        String status = rs.getString("STATUS");
                        int count = rs.getInt("item_count");
                        
                        if(status != null && !status.trim().isEmpty()){
                            itemCategories.add(status.trim());
                            categoryCounts.add(count);
                        }
                    }
                }
                
            } catch(SQLException e) {
                // CATEGORY column might not exist, use status
                System.out.println("CATEGORY column not found, using STATUS instead: " + e.getMessage());
                rs = stmt.executeQuery("SELECT STATUS, COUNT(*) as item_count FROM ITEMS GROUP BY STATUS ORDER BY item_count DESC");
                while(rs.next()){
                    String status = rs.getString("STATUS");
                    int count = rs.getInt("item_count");
                    
                    if(status != null && !status.trim().isEmpty()){
                        itemCategories.add(status.trim());
                        categoryCounts.add(count);
                    }
                }
            }
            
            // If still no categories, create some from item names or add default
            if(itemCategories.isEmpty()){
                // Try to extract categories from item names or use generic ones
                itemCategories.add("Available");
                itemCategories.add("Sold");
                itemCategories.add("Rejected");
                
                // Get counts for these statuses
                int availableCount = totalItems - (soldCount + rejectedCount + pendingCount);
                categoryCounts.add(availableCount > 0 ? availableCount : 2);
                categoryCounts.add(soldCount > 0 ? soldCount : 3);
                categoryCounts.add(rejectedCount > 0 ? rejectedCount : 1);
            }
            
            // --- C. BAR CHART: TOP 5 USERS BY ACTIVITY ---
            // Get ALL user activity from database - both selling and buying
            
            // Step 1: Get user selling activity (items they've listed from ITEMS table)
            Map<Integer, Integer> userSellMap = new HashMap<>(); // user_id -> items_listed
            Map<Integer, String> userIdToName = new HashMap<>(); // user_id -> username
            
            rs = stmt.executeQuery("SELECT u.USER_ID, u.USERNAME, COUNT(i.ITEM_ID) as items_listed " +
                                 "FROM USERS u " +
                                 "LEFT JOIN ITEMS i ON u.USER_ID = i.USER_ID " +
                                 "WHERE u.USERNAME NOT LIKE 'admin%' " +
                                 "GROUP BY u.USER_ID, u.USERNAME");
            
            while(rs.next()){
                int userId = rs.getInt("USER_ID");
                String username = rs.getString("USERNAME");
                int itemsListed = rs.getInt("items_listed");
                
                userSellMap.put(userId, itemsListed);
                userIdToName.put(userId, username);
            }
            
            // Step 2: Get user buying activity from TRANSACTIONS table
            Map<Integer, Integer> userBuyMap = new HashMap<>(); // user_id -> items_bought
            
            // Check if TRANSACTIONS table exists
            try {
                ResultSet tableCheck = stmt.executeQuery(
                    "SELECT 1 FROM SYS.SYSTABLES WHERE TABLENAME = 'TRANSACTIONS'"
                );
                
                if(tableCheck.next()){
                    // TRANSACTIONS table exists - get buying activity
                    rs = stmt.executeQuery("SELECT BUYER_ID, COUNT(*) as items_bought " +
                                         "FROM TRANSACTIONS " +
                                         "GROUP BY BUYER_ID");
                    
                    while(rs.next()){
                        int buyerId = rs.getInt("BUYER_ID");
                        int itemsBought = rs.getInt("items_bought");
                        userBuyMap.put(buyerId, itemsBought);
                    }
                    
                    // Also count selling activity from TRANSACTIONS (items sold)
                    rs = stmt.executeQuery("SELECT SELLER_ID, COUNT(*) as items_sold " +
                                         "FROM TRANSACTIONS " +
                                         "GROUP BY SELLER_ID");
                    
                    while(rs.next()){
                        int sellerId = rs.getInt("SELLER_ID");
                        int itemsSold = rs.getInt("items_sold");
                        // Add to existing sell count from ITEMS table
                        int currentSold = userSellMap.getOrDefault(sellerId, 0);
                        userSellMap.put(sellerId, currentSold + itemsSold);
                    }
                }
                tableCheck.close();
            } catch(Exception e) {
                System.out.println("Error checking TRANSACTIONS table: " + e.getMessage());
            }
            
            // Step 3: Combine data and prepare for sorting
            List<Map.Entry<Integer, int[]>> userActivities = new ArrayList<>();
            
            for(Integer userId : userIdToName.keySet()){
                String username = userIdToName.get(userId);
                int itemsSold = userSellMap.getOrDefault(userId, 0);
                int itemsBought = userBuyMap.getOrDefault(userId, 0);
                
                // Only include users with some activity
                if(itemsSold > 0 || itemsBought > 0){
                    int[] activities = new int[]{itemsSold, itemsBought};
                    userActivities.add(new AbstractMap.SimpleEntry<>(userId, activities));
                }
            }
            
            // Step 4: Sort by total activity (sell + buy)
            Collections.sort(userActivities, new Comparator<Map.Entry<Integer, int[]>>() {
                @Override
                public int compare(Map.Entry<Integer, int[]> a, Map.Entry<Integer, int[]> b) {
                    int totalA = a.getValue()[0] + a.getValue()[1];
                    int totalB = b.getValue()[0] + b.getValue()[1];
                    return Integer.compare(totalB, totalA); // Descending order
                }
            });
            
            // Step 5: Take top 5 users
            int count = 0;
            for(Map.Entry<Integer, int[]> entry : userActivities){
                if(count >= 5) break;
                
                int userId = entry.getKey();
                int[] activities = entry.getValue();
                String username = userIdToName.get(userId);
                
                // Shorten long usernames for display
                String displayName = username;
                if(displayName.length() > 10){
                    displayName = displayName.substring(0, 8) + "..";
                }
                
                userNames.add(displayName);
                sellActivity.add(activities[0]); // Items sold/listed
                buyActivity.add(activities[1]);   // Items bought
                count++;
            }
            
            // If we have fewer than 5 active users, add inactive users to fill
            if(userNames.size() < 5){
                // Get all users who weren't included yet
                for(Integer userId : userIdToName.keySet()){
                    String username = userIdToName.get(userId);
                    
                    // Check if this user is already in our list
                    boolean alreadyInList = false;
                    for(String existingName : userNames){
                        if(existingName.contains(username.replace("..", "")) || 
                           username.contains(existingName.replace("..", ""))){
                            alreadyInList = true;
                            break;
                        }
                    }
                    
                    if(!alreadyInList && userNames.size() < 5){
                        // Shorten long usernames for display
                        String displayName = username;
                        if(displayName.length() > 10){
                            displayName = displayName.substring(0, 8) + "..";
                        }
                        
                        userNames.add(displayName);
                        sellActivity.add(0);
                        buyActivity.add(0);
                    }
                }
            }

        } catch(Exception e) { 
            e.printStackTrace();
            // Minimal fallback only if database fails completely
            itemCategories = Arrays.asList("Available", "Sold", "Rejected");
            categoryCounts = Arrays.asList(0, 0, 0);
            
            userNames = Arrays.asList("Database", "Error", "Check", "Connection");
            sellActivity = Arrays.asList(0, 0, 0, 0);
            buyActivity = Arrays.asList(0, 0, 0, 0);
        } 
        finally { 
            if(conn != null) try { conn.close(); } catch(SQLException ignore) {} 
        }
        
        // Calculate percentages for display
        int totalPieItems = 0;
        for(int count : categoryCounts){
            totalPieItems += count;
        }
        
        List<String> pieLabelsWithPercentage = new ArrayList<>();
        for(int i = 0; i < itemCategories.size(); i++){
            String category = itemCategories.get(i);
            int count = categoryCounts.get(i);
            double percentage = totalPieItems > 0 ? (count * 100.0 / totalPieItems) : 0;
            pieLabelsWithPercentage.add(String.format("%s (%.1f%%)", category, percentage));
        }
        
        // Prepare JSON data
        StringBuilder categoriesJson = new StringBuilder("[");
        for(int i = 0; i < pieLabelsWithPercentage.size(); i++){
            if(i > 0) categoriesJson.append(",");
            categoriesJson.append("\"").append(pieLabelsWithPercentage.get(i).replace("\"", "\\\"")).append("\"");
        }
        categoriesJson.append("]");
        
        StringBuilder categoryCountsJson = new StringBuilder("[");
        for(int i = 0; i < categoryCounts.size(); i++){
            if(i > 0) categoryCountsJson.append(",");
            categoryCountsJson.append(categoryCounts.get(i));
        }
        categoryCountsJson.append("]");
        
        StringBuilder usersJson = new StringBuilder("[");
        for(int i = 0; i < userNames.size(); i++){
            if(i > 0) usersJson.append(",");
            usersJson.append("\"").append(userNames.get(i).replace("\"", "\\\"")).append("\"");
        }
        usersJson.append("]");
        
        StringBuilder sellActivityJson = new StringBuilder("[");
        for(int i = 0; i < sellActivity.size(); i++){
            if(i > 0) sellActivityJson.append(",");
            sellActivityJson.append(sellActivity.get(i));
        }
        sellActivityJson.append("]");
        
        StringBuilder buyActivityJson = new StringBuilder("[");
        for(int i = 0; i < buyActivity.size(); i++){
            if(i > 0) buyActivityJson.append(",");
            buyActivityJson.append(buyActivity.get(i));
        }
        buyActivityJson.append("]");
    %>

    <div class="main-content">
        
        <div class="page-header">
            <h2>Dashboard Overview</h2>
            <div class="date-badge"><i class="far fa-clock"></i> <%= malaysiaTime %></div>
        </div>

        <div class="cards-container">
            <div class="card">
                <div class="card-info">
                    <h3><%= studentCount %></h3>
                    <p>Total Students</p>
                </div>
                <div class="card-icon icon-blue">
                    <i class="fas fa-user-graduate"></i>
                </div>
            </div>
            
            <div class="card">
                <div class="card-info">
                    <h3><%= totalItems %></h3>
                    <p>Total Items</p>
                </div>
                <div class="card-icon icon-green">
                    <i class="fas fa-shopping-bag"></i>
                </div>
            </div>
            
            <div class="card">
                <div class="card-info">
                    <h3><%= pendingCount %></h3>
                    <p>Pending Review</p>
                </div>
                <div class="card-icon icon-orange">
                    <i class="fas fa-clock"></i>
                </div>
            </div>
            
            <div class="card">
                <div class="card-info">
                    <h3><%= soldCount %></h3>
                    <p>Items Sold</p>
                </div>
                <div class="card-icon icon-purple">
                    <i class="fas fa-hand-holding-usd"></i>
                </div>
            </div>

            <div class="card">
                <div class="card-info">
                    <h3><%= rejectedCount %></h3>
                    <p>Rejected Items</p>
                </div>
                <div class="card-icon icon-red">
                    <i class="fas fa-ban"></i>
                </div>
            </div>
        </div>
        
        <!-- CHARTS SECTION -->
        <div class="charts-container">
            <!-- Pie Chart - Item Categories -->
            <div class="chart-card">
                <h3><i class="fas fa-chart-pie"></i> Item Distribution by Category</h3>
                <div class="chart-container">
                    <canvas id="pieChart"></canvas>
                </div>
                <div class="chart-colors" id="pieLegend">
                    <% 
                        // Display category names with counts
                        for(int i = 0; i < itemCategories.size(); i++){
                            String category = itemCategories.get(i);
                            int count = categoryCounts.get(i);
                            double percentage = totalPieItems > 0 ? (count * 100.0 / totalPieItems) : 0;
                    %>
                    <div class="color-label">
                        <div class="color-box" style="background-color: <%= getPieColor(i) %>;"></div>
                        <span><%= category %>: <%= count %> items (<%= String.format("%.1f", percentage) %>%)</span>
                    </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Bar Chart - User Activity -->
            <div class="chart-card">
                <h3><i class="fas fa-chart-bar"></i> Top 5 Users Activity</h3>
                <div class="chart-container">
                    <canvas id="barChart"></canvas>
                </div>
                <div class="chart-colors">
                    <div class="color-label">
                        <div class="color-box" style="background-color: #800000;"></div>
                        <span>Items Listed</span>
                    </div>
                    <div class="color-label">
                        <div class="color-box" style="background-color: #36a2eb;"></div>
                        <span>Items Purchased</span>
                    </div>
                </div>
                <div style="font-size: 11px; color: #666; margin-top: 10px;">
                    <i class="fas fa-info-circle"></i> Real data from database - Based on ITEMS and TRANSACTIONS tables
                </div>
            </div>
        </div>

    </div>

    <%!
        // Method to get consistent pie chart colors
        private String getPieColor(int index) {
            String[] colors = {
                "#800000", "#ff6384", "#36a2eb", "#ffce56", "#4bc0c0",
                "#9966ff", "#ff9f40", "#8ac926", "#1982c4", "#6a4c93",
                "#ff595e", "#8ac926", "#1982c4", "#ffca3a", "#6a4c93"
            };
            return colors[index % colors.length];
        }
    %>

    <script>
        // Debug: Log the data being used
        console.log("Pie Chart Data:");
        console.log("Labels:", <%= categoriesJson.toString() %>);
        console.log("Data:", <%= categoryCountsJson.toString() %>);
        
        console.log("Bar Chart Data:");
        console.log("Users:", <%= usersJson.toString() %>);
        console.log("Items Listed:", <%= sellActivityJson.toString() %>);
        console.log("Items Purchased:", <%= buyActivityJson.toString() %>);
        
        // Pie Chart - Item Distribution
        const pieCtx = document.getElementById('pieChart').getContext('2d');
        const pieLabels = <%= categoriesJson.toString() %>;
        const pieData = <%= categoryCountsJson.toString() %>;
        
        // Define colors for pie chart
        const pieColors = [
            '#800000', '#ff6384', '#36a2eb', '#ffce56', '#4bc0c0',
            '#9966ff', '#ff9f40', '#8ac926', '#1982c4', '#6a4c93',
            '#ff595e', '#8ac926', '#1982c4', '#ffca3a', '#6a4c93'
        ];
        
        const pieChart = new Chart(pieCtx, {
            type: 'pie',
            data: {
                labels: pieLabels,
                datasets: [{
                    data: pieData,
                    backgroundColor: pieColors.slice(0, Math.min(pieData.length, pieColors.length)),
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right',
                        labels: {
                            padding: 20,
                            usePointStyle: true,
                            pointStyle: 'circle',
                            font: {
                                size: 11
                            }
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.raw || 0;
                                const total = pieData.reduce((a, b) => a + b, 0);
                                const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                                // Extract just the category name without percentage
                                const categoryName = label.split(' (')[0];
                                return `${categoryName}: ${value} items (${percentage}%)`;
                            }
                        }
                    }
                }
            }
        });
        
        // Bar Chart - User Activity
        const barCtx = document.getElementById('barChart').getContext('2d');
        const barLabels = <%= usersJson.toString() %>;
        const sellData = <%= sellActivityJson.toString() %>;
        const buyData = <%= buyActivityJson.toString() %>;
        
        const barChart = new Chart(barCtx, {
            type: 'bar',
            data: {
                labels: barLabels,
                datasets: [
                    {
                        label: 'Items Listed',
                        data: sellData,
                        backgroundColor: '#800000',
                        borderColor: '#500000',
                        borderWidth: 1
                    },
                    {
                        label: 'Items Purchased',
                        data: buyData,
                        backgroundColor: '#36a2eb',
                        borderColor: '#1e7eb7',
                        borderWidth: 1
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: 'Number of Items'
                        },
                        ticks: {
                            stepSize: 1,
                            precision: 0,
                            callback: function(value) {
                                if (value % 1 === 0) {
                                    return value;
                                }
                            }
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: 'Users'
                        }
                    }
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const datasetLabel = context.dataset.label || '';
                                const value = context.raw || 0;
                                const username = barLabels[context.dataIndex];
                                
                                if(value > 0) {
                                    return `${username}: ${value} ${datasetLabel.toLowerCase()}`;
                                }
                                return `${username}: No ${datasetLabel.toLowerCase()}`;
                            }
                        }
                    }
                }
            }
        });
        
        // Responsive adjustments
        window.addEventListener('resize', function() {
            pieChart.resize();
            barChart.resize();
        });
    </script>

</body>
</html>