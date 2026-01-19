<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartpark.dto.User" %>
<%@ page import="com.smartpark.dao.BookingDAO" %>
<%@ page import="com.smartpark.dto.BookingViewDTO" %>
<%@ page import="com.smartpark.dto.Booking" %>
<%@ page import="java.util.List" %>

<%
User u = (User) session.getAttribute("user");
int userId = u.getId();

String role = u.getRole();
if (!"user".equals(role)) {
    response.sendRedirect("../auth/login.jsp");
    return;
}
%>

<%
    BookingDAO bookingDao = new BookingDAO();

   
    List<BookingViewDTO> userBookings = null;

    try {
        userBookings = bookingDao.getBookingViewsByUserId(u.getId());
    } catch (Exception e) {
        e.printStackTrace(); 
        userBookings = new java.util.ArrayList<>();
    }

    int total = 0;
    int active = 0;
    int upcoming = 0;
    int cancelled = 0;

    java.time.LocalDateTime now = java.time.LocalDateTime.now();
    BookingViewDTO currentBooking = null;

    if (userBookings != null) {
        for (BookingViewDTO b : userBookings) {
            total++;

            if (b.getStatus() == null) continue;

            String status = b.getStatus().name();

            if ("ACTIVE".equalsIgnoreCase(status)) {

              
                if (b.getStartTime() != null
                        && now.isAfter(b.getStartTime())
                        && (b.getEndTime() == null || now.isBefore(b.getEndTime()))) {

                    currentBooking = b;
                }
                active++;
            }
            else if ("BOOKED".equalsIgnoreCase(status)
                    && b.getStartTime() != null
                    && b.getStartTime().isAfter(now)) {

                upcoming++;
            }
            else if ("CANCELLED".equalsIgnoreCase(status)) {
                cancelled++;
            }
        }
    }

    request.setAttribute("total", total);
    request.setAttribute("active", active);
    request.setAttribute("upcoming", upcoming);
    request.setAttribute("cancelled", cancelled);
    request.setAttribute("currentBooking", currentBooking);
%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>
    <style>
 * { 
 box-sizing: border-box; 
 }

html, body {
margin: 0;
padding: 0;
background: #f4f6f9;
 height: 100%;
  font-family: Inter, system-ui, -apple-system, "Segoe UI", Roboto, Helvetica,
 Arial, sans-serif;
 color: #1f2937;
       
      }

      /* SIDEBAR */
      .sidebar {
          position: fixed;
          top: 0;
          left: 0;
          width: 260px;
          height: 100vh;
          background: #ffffff;
          border-right: 1px solid #e5e7eb;
          display: flex;
          flex-direction: column;
          justify-content: space-between;
          padding: 20px 0;
      }

      #logo{
         margin-top:-20px;
         display:flex;
         justify-content:center;
         align-items:center;
         gap:12px;
         border-bottom: 1px solid #e5e7eb;
      }

      #logo i{
          padding: 10px;
          color:white;
          background: linear-gradient(to right, #6366f1, #7c3aed);
          font-size:12px;
          border-radius:5px;
          margin-top:10px;
      }

      .sidebar h2 {
         color: #1559c5;
          font-size: 22px;
          font-weight: 600;
      }

      #small-text{
         font-size:10px;
         color:#6b7280;
         margin-top:-20px;
      }

      .sidebar a {
          display: flex;
          align-items: center;
          gap: 15px;
          padding: 12px 20px;
          color: #6b7280;
          text-decoration: none;
          margin-bottom: 8px;
          font-size: 15px;
          border-radius: 10px;
          transition: all 0.2s;
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

      .top-links{
          margin:20px 0px;
      }

      .sidebar .bottom-links {
          margin:400px 0px;
      }

      /* TOPBAR */
      .topbar {
          margin-left: 260px;
          height: 60px;
          display: flex;
          align-items: center;
          justify-content: space-between;
          padding: 0 30px;
          border-bottom: 1px solid #e5e7eb;
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
    margin-right:40px;
    font-weight: 600;
}
     

        /* CONTENT */
        .content {
            margin-left: 260px;
            padding: 30px 40px;
        }

        /* STATS CARDS */
        .stats-cards {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            flex: 1 1 220px;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            display: flex;
            align-items: center;
            justify-content: space-between;
            border: 1px solid #e5e7eb;
        }

        .card i {
            font-size: 28px;
            padding: 10px;
            border-radius: 50%;
            background: #f0f6ff;
            color: #1559c5;
        }

        .card .card-info {
            text-align: right;
        }

        .card .card-info .number {
            font-size: 18px;
            font-weight: 600;
            color: #374151;
        }

        .card .card-info .label {
            font-size: 13px;
            color: #6b7280;
        }

        /* LOWER SECTION */
        .lower-section {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }

        .lower-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            padding: 20px;
            border: 1px solid #e5e7eb;
        }
        
        .lower-card button{
        
            padding: 6px 12px;
            background: linear-gradient(to right, #6366f1, #7c3aed);
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            transition: 0.3s;
        }

       

    </style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <div>
         <div id="logo">
            <i class="fas fa-car"></i>
            <div>
              <h2>ParkEase</h2>
              <p id="small-text">Pre-Booking System</p>
            </div>
         </div>

        <div class="top-links">
          <a href="${pageContext.request.contextPath}/user/userDashboard.jsp"><i class="fa-solid fa-gauge"></i> Dashboard</a>
          <a href="${pageContext.request.contextPath}/user/booking-page"><i class="fa-solid fa-ticket"></i> Book Slot</a>
          <a href="${pageContext.request.contextPath}/user/view-bookings"><i class="fa-solid fa-list-check"></i> My Bookings</a>
        </div>

        <div class="bottom-links">
            <a href="${pageContext.request.contextPath}/profile/profile.jsp"><i class="fa-solid fa-user"></i> Profile</a>
            <a href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </div>
</div>

<!-- TOPBAR -->
<div class="topbar">
    <div class="welcome">Welcome back, <%= u.getName() %></div>
    
     <div>
        <!-- Clickable profile image -->
     <a href="${pageContext.request.contextPath}/profile/profile.jsp">
         <div class="avatar"><%= u.getName().substring(0,1).toUpperCase() %></div>
     </a>
       
     </div>
    
</div>

<!-- CONTENT -->
<div class="content">

    <!-- Stats Cards -->
    <div class="stats-cards">

        <div class="card">
            <i class="fa-solid fa-calendar"></i>
            <div class="card-info">
                <div class="number">${total}</div>
                <div class="label">Total Bookings</div>
            </div>
        </div>

        <div class="card">
            <i class="fa-solid fa-circle-check" style="color:#10b981;background:#d1fae5"></i>
            <div class="card-info">
                <div class="number">${active}</div>
                <div class="label">Active</div>
            </div>
        </div>

        <div class="card">
            <i class="fa-solid fa-clock" style="color:#8b5cf6;background:#ede9fe"></i>
            <div class="card-info">
                <div class="number">${upcoming}</div>
                <div class="label">Upcoming</div>
            </div>
        </div>

        <div class="card">
            <i class="fa-solid fa-xmark" style="color:#ef4444;background:#fee2e2"></i>
            <div class="card-info">
                <div class="number">${cancelled}</div>
                <div class="label">Cancelled</div>
            </div>
        </div>
    </div>

    <!-- Lower Section -->
    <div class="lower-section">

        <div class="lower-card">
       <h3>Current Booking</h3>

      <c:choose>
    <c:when test="${currentBooking != null}">
        <p><strong>Slot:</strong> ${currentBooking.slotNumber}</p>
        <p><strong>Start:</strong> ${currentBooking.startTime}</p>
        <p><strong>End:</strong> ${currentBooking.endTime}</p>

        <button onclick="location.href='${pageContext.request.contextPath}/user/view-bookings'">
            View Booking
        </button>
    </c:when>

    <c:otherwise>
        <p>No Active Booking</p>
        <p>You don't have any active parking session right now.</p>
        <button onclick="location.href='${pageContext.request.contextPath}/user/booking.jsp'">
            Book a Slot
        </button>
    </c:otherwise>
</c:choose>
</div>
        

  

    </div>

</div>




</body>
</html>
