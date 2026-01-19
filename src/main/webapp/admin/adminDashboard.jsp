<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartpark.dto.User" %>
<%@ page import="com.smartpark.dao.ParkingSlotDAO" %>
<%@ page import="com.smartpark.dao.BookingDAO" %>
<%@ page import="com.smartpark.dao.UserDAO" %>
<%@ page import="com.smartpark.dao.VehicleDAO" %>
<%
User u = (User) session.getAttribute("user");

if (u == null) {
	 session.invalidate();
    response.sendRedirect("../auth/login.jsp");
    return;
}

String role = u.getRole();

if (!"admin".equals(role)) {
    response.sendRedirect("../auth/login.jsp");
    return;
}

ParkingSlotDAO slotDAO = new ParkingSlotDAO();
BookingDAO bookingDAO = new BookingDAO();
UserDAO userDAO = new UserDAO();
VehicleDAO vehicleDAO = new VehicleDAO();

// Fetch data
int totalSlots      = slotDAO.getTotalSlots();

int occupiedSlots   = slotDAO.getOccupiedSlots();


int availableSlots = totalSlots - occupiedSlots;



 int  todaysBookings = bookingDAO.getTodaysBookingsCount();

   

int totalBookings   = bookingDAO.getTotalBookings();


int totalUsers      = userDAO.getUserCount();
int vehiclesInside  = vehicleDAO.getVehiclesInsideCount();
double todayRevenue = vehicleDAO.getTodayRevenue();
%>
<!DOCTYPE html>
<html>

<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

   <style>
    * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

html, body {
    height: 100%;
    background: #f4f6f9;
    font-family: Inter, system-ui, -apple-system, "Segoe UI", Roboto, Arial, sans-serif;
    color: #1f2937;
}

/* ================= SIDEBAR ================= */
.sidebar {
    position: fixed;
    top: 0;
    left: 0;
    width: 260px;
    height: 100vh;
    background: #ffffff;
    border-right: 1px solid #e5e7eb;
    padding: 20px 10px;
}

  #logo{
    border-bottom: 1px solid #e5e7eb;
  }

      
.sidebar h2 {
    text-align: center;
    font-size: 22px;
    font-weight: 600;
    color: #1559c5;
    margin-bottom: 20px;
}

.sidebar a {
    display: flex;
    align-items: center;
    gap: 14px;
    padding: 12px 18px;
    margin-top:10px;
    margin-bottom: 10px;
    color: #6b7280;
    text-decoration: none;
    font-size: 15px;
    border-radius: 10px;
    transition: 0.2s;
}

.sidebar a:hover {
    background: #f0f6ff;
    color: #1559c5;
    font-weight: 600;
}

.sidebar i {
    min-width: 20px;
    text-align: center;
}

#pf {
    margin-top: 180px;
}

/* ================= TOPBAR ================= */
.topbar {
    margin-left: 260px;
    height: 60px;
    border-bottom: 1px solid #e5e7eb;
    display: flex;
    justify-content:space-between;
    align-items: center;
    padding: 0 30px;
}

  .topbar .welcome {
     font-size: 18px;
     font-weight: 600;
     color: #374151;
}

.topbar a {
      
        text-decoration:none;
      }
.avatar {
    width: 42px;
    height: 42px;
    border-radius: 50%;
    background: linear-gradient(to right, #6366f1, #7c3aed);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
}

/* ================= CONTENT ================= */
.content {
    margin-left: 260px;
    padding: 10px  40px;
}

.fade-in {
    animation: fadeIn 0.6s ease-in forwards;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(6px); }
    to { opacity: 1; transform: translateY(0); }
}

.section-title {
    margin: 20px 0;
    font-size: 22px;
    font-weight: 600;
}

/* ================= CARDS ================= */
.summary-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: 20px;
    margin-top: 20px;
}

.card {
    background: #ffffff;
    padding: 22px;
    border-radius: 14px;
    border: 1px solid #e5e7eb;
    box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    transition: 0.25s;
}

.card:hover {
    transform: translateY(-5px);
}

.card h3 {
    font-size: 14px;
    color: #6b7280;
    margin-bottom: 8px;
}

.card h2, .card h1 {
    font-size: 22px;
    font-weight: 600;
}

/* ================= ICON STYLES ================= */
.icon {
    width: 42px;
    height: 42px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 18px;
    margin-bottom: 12px;
}

.purple { background: #ede9fe; color: #7c3aed; }
.green  { background: #d1fae5; color: #10b981; }
.blue   { background: #dbeafe; color: #2563eb; }
.yellow { background: #fef9c3; color: #b45309; }
.red    { background: #fee2e2; color: #ef4444; }

/* ================= PROFILE DROPDOWN ================= */
.profile-container {
    position: relative;
}

.dropdown {
    display: none;
    position: absolute;
    right: 0;
    top: 52px;
    width: 220px;
    background: white;
    border-radius: 12px;
    border: 1px solid #e5e7eb;
    box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    overflow: hidden;
}

.dropdown-header {
    text-align: center;
    padding: 12px;
    border-bottom: 1px solid #e5e7eb;
}

.dropdown a {
    display: block;
    padding: 12px 18px;
    color: #374151;
    text-decoration: none;
}

.dropdown a:hover {
    background: #f0f6ff;
}

.profile-container:hover .dropdown {
    display: block;
}
    
       
</style>
</head>

<body>

<!-- Popup message for success actions -->
<c:if test="${not empty sessionScope.popupMsg}">
    <script>
        alert("${sessionScope.popupMsg}");
    </script>
    <c:remove var="popupMsg" scope="session"/>
</c:if>

<div class="layout">

<!-- Sidebar -->
<div class="sidebar" id="sidebar">


  <div id="logo">
  
 <h2>Admin Panel</h2>
 </div>
 

    <!-- Dashboard -->
    <a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp">
        <i class="fa-solid fa-gauge"></i>
        <span>Dashboard</span>
    </a>

    <!-- Manage Parking Slots (Single Page) -->
    <a href="${pageContext.request.contextPath}/admin/manageSlots.jsp">
        <i class="fa-solid fa-square-parking"></i>
        <span>Manage Slots</span>
    </a>

    <!-- Manage Users -->
    <a href="${pageContext.request.contextPath}/admin/manageUsers.jsp">
        <i class="fa-solid fa-users"></i>
        <span>Manage Users</span>
    </a>

    <!-- View Bookings -->
    <a href="${pageContext.request.contextPath}/viewBookings">
        <i class="fa-solid fa-list-check"></i>
        <span>View Bookings</span>
    </a>

    <!-- Vehicle entry -->
      <a href="${pageContext.request.contextPath}/vehicleEntry">
      <i class="fa-solid fa-car-side"></i> 
       <span>Vehicle Entry</span>
       </a>
       
       
      <a href="${pageContext.request.contextPath}/vehicleExit">
      
      <i class="fa-solid fa-arrow-right-from-bracket"></i> 
       <span>Vehicle Exit</span>
      </a>
      
       <a href="${pageContext.request.contextPath}/admin/revenue">
      
      <i class="fa-solid fa-chart-line"></i>
      
       <span>Revenue Report</span>
      </a>
  
  

     <div id="pf">
     
    <a href="${pageContext.request.contextPath}/profile/profile.jsp">
        <i class="fa-solid fa-user"></i>
        <span>Profile</span>
    </a>

    <a href="${pageContext.request.contextPath}/logout">
        <i class="fa-solid fa-right-from-bracket"></i>
        <span>Logout</span>
    </a>
    </div>

</div>



<!-- Top Bar -->
<div class="topbar">
   
     <div class="welcome">Welcome back, <%= u.getName() %></div>
     <div>
        <!-- Clickable profile image -->
     <a href="${pageContext.request.contextPath}/profile/profile.jsp">
         <div class="avatar"><%= u.getName().substring(0,1).toUpperCase() %></div>
     </a>
       
     </div>

    
</div>
  
        



    <!-- ---------------------------- CONTENT ---------------------------- -->
          
    <div class="content fade-in">

       

        <h2 class="section-title">Overview</h2>

        <!-- NEW CARDS WITH ANIMATION -->
      <div class="summary-grid">

            <div class="card">
                <div class="icon purple">
                <i class="fa-solid fa-square-parking"></i>
                </div>
                <h3>Total Slots</h3>
                <h2 id="totalSlots"><%= totalSlots %></h2>
                
            </div>
            
            <div class="card">
			    <div class="icon green">
			        <i class="fa-solid fa-square-check"></i>
			    </div>
			    <h3>Available Slots</h3>
			    <h2><%= availableSlots %></h2>
			</div>
            

            <div class="card">
                <div class="icon red"><i class="fa-solid fa-car"></i></div>
                <h3>Occupied Slots</h3>
                <h2 id="occupiedSlots"><%= occupiedSlots %></h2>
                
            </div>
            
            <div class="card">
			    <div class="icon purple"><i class="fa-solid fa-list"></i></div>
			    <h3>Total Bookings</h3>
			    <h2><%= totalBookings %></h2>
			</div>
            

            <div class="card">
                <div class="icon blue"><i class="fa-solid fa-calendar-day"></i></div>
                <h3>Today's Bookings</h3>
                <h2 id="todayBookings"><%= todaysBookings %></h2>
                
            </div>

            <div class="card">
                <div class="icon yellow"><i class="fa-solid fa-users"></i></div>
                <h3>Total Users</h3>
                <h2 id="totalUsers"><%= totalUsers %></h2>
               
            </div>
            
            <div class="card">
		     <div class="icon red"><i class="fa-solid fa-car-burst"></i></div>
		    <h3>Vehicles Inside</h3>
		    <h2><%= vehiclesInside %></h2>
		     </div>
            
            
            
             <div class="card">
                <div class="icon blue">
                <i class="fa-solid fa-indian-rupee-sign"></i>
                </div>
                <h3>Today's Revenue</h3>
                <h1>₹<%= todayRevenue %></h1>
            </div>
            
       </div>



</div>

</body>
</html>
