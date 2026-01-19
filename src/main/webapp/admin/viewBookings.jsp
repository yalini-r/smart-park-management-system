<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<%@ page import="java.util.*" %>
<%@ page import="com.smartpark.dto.*" %>


<%
User u = (User) session.getAttribute("user");
if (u == null) {
    session.invalidate();
    response.sendRedirect(request.getContextPath() + "/auth/login.jsp");

    return;
}

if (!"ADMIN".equalsIgnoreCase(u.getRole()))
 {
	response.sendRedirect(request.getContextPath() + "/auth/login.jsp");

    return;
}


%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Parking Dashboard</title>
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

/* MAIN */
.main {
    margin-left:280px;
    padding:30px 50px;
}

/* HEADER */
.page-title {
    font-size: 26px;
    font-weight: 700;
}
.page-subtitle {
    color: #6b7280;
    margin-bottom: 24px;
}

.toggle-btn {
    background:#1559c5;
    color:white;
    border:none;
    padding:8px 16px;
    margin-left:10px;
    border-radius:6px;
    cursor:pointer;
    font-weight:600;
}
.toggle-btn:hover { opacity:0.85; }

/* STATS */
.stats {
    display: grid;
    grid-template-columns: repeat(6, 1fr);
    gap: 18px;
    margin-bottom: 30px;
}

.stat-card {
    padding:18px 20px;
    border-radius:14px;
    background:white;
    border:1px solid #e5e7eb;
    display:flex;
    justify-content:space-between;
    align-items:center;
    box-shadow:0 3px 10px rgba(0,0,0,0.06);
    transition:0.15s;
    cursor:pointer;
    text-decoration:none;
    color:inherit;
     transition: transform 0.15s, box-shadow 0.15s;
}
.stat-card:hover { 
 transform:translateY(-4px); 
}


 .stat-card.active {
  outline:3px solid rgba(21,89,197,0.15); 
  }

.stat-left h3 {
    margin:0;
    font-size:13px;
    color:#6b7280;
    font-weight:600;
}
.stat-left .stat-value {
    font-size:20px;
    font-weight:600;
    margin-top:6px;
}

.stat-icon {
    width: 42px;
    height: 44px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 16px;
}

.yellow { background:#fff6d6; color:#f1c40f; }
.green { background:#e7f8ec; color:#108b32; }
.blue { background:#e5f0ff; color:#1559c5; }
.red { background:#fee2e2; color:#b91c1c; }
.gray{ background:#d1d5db; color: #6b7280 ;}


#preBookedTable h3 ,
#walkInTable h3 {

   margin-bottom : 10px;
}

/* TABLE */
.table-card {
    background:#fff;
    border-radius:14px;
    box-shadow:0 6px 18px rgba(0,0,0,.06);
    overflow:hidden;
}
table {
    width:100%;
    border-collapse:collapse;
}
th {
    background:#f9fafb;
    text-align:left;
    padding:14px;
    font-size:13px;
    color:#6b7280;
}
td {
    padding:14px;
    border-top:1px solid #f1f5f9;
    font-size:14px;
}

/* BADGES */
.badge {
    display:inline-flex;
    align-items:center;
    justify-content:center;
    padding:4px 12px;
    border-radius:999px;
    font-size:12px;
    font-weight:700;
    text-transform:uppercase;
}

.badge.BOOKED {
    background:#fff6d6; color:#c49b0f;
}
.badge.ACTIVE {
    background:#e7f8ec; color:#108b32;
}
.badge.COMPLETED {
    background:#e5f0ff; color:#1559c5;
}
.badge.CANCELLED {
    background:#fee2e2; color:#b91c1c;
}

.badge.EXPIRED {
  background:#d1d5db; color: #6b7280 ;
}

/* ACTIONS */
.actions {
    display:flex;
    align-items:center;
    gap:12px;
}

.actions button {
    border:none;
    padding:8px;
    border-radius:8px;
    cursor:pointer;
    font-size:14px;
    font-weight:600;
}

.actions .checkin { background:#e7f8ec; color:#108b32; }
.actions .checkout { background:#e5f0ff; color:#1559c5; }
.actions .cancel { background:#fee2e2; color:#b91c1c; }

.actions button:hover {
    opacity:0.85;
}

.divider { 
    border:none; 
    border-top:2px solid #ddd; 
    margin:20px 0; 
}
.message { color: green; margin-bottom: 10px; }
.error { color: red; margin-bottom: 10px; }

td:nth-child(4),
td:nth-child(5) {
    vertical-align: middle;
}

.toggle-btn.active {
    background: #108b32;
    color: white;
}



</style>
</head>

<body>
<!-- Sidebar -->
<div class="sidebar" id="sidebar">


  <div id="logo">
  
 <h2>Admin Panel</h2>
 </div>
 

    <!-- Dashboard -->
    <a  href="${pageContext.request.contextPath}/admin/adminDashboard.jsp">
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

<div class="main">

<!-- Page Header with Toggle Buttons -->
<div class="page-title-bar" style="display:flex; justify-content: space-between; align-items:center; margin-bottom: 20px;">
    <div>
        <div class="page-title">Parking Dashboard</div>
        <div class="page-subtitle">Manage and monitor all parking bookings</div>
    </div>
    <div>
        <button onclick="showTable('preBooked')" class="toggle-btn active">Pre-Booked</button>
        <button onclick="showTable('walkIn')" class="toggle-btn">Walk-In</button>
    </div>
</div>

<!-- Messages -->
<c:if test="${not empty sessionScope.message}">
    <div class="message">${sessionScope.message}</div>
    <c:remove var="message" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.error}">
    <div class="error">${sessionScope.error}</div>
    <c:remove var="error" scope="session"/>
</c:if>

<!-- STATS -->

  <!-- STATS : PRE-BOOKED -->
<div id="preBookedStats" class="stats">

    <!-- ALL -->
   <div class="stat-card active" data-type="preBooked" data-status="ALL">
   
        <div class="stat-left">
            <h3>All</h3>
          <div class="stat-value">${preBookedTotalCount}</div>
          
        </div>
        <div class="stat-icon blue">
            <i class="fa-solid fa-layer-group"></i>
        </div>
    </div>

    <!-- BOOKED -->
   <div class="stat-card " data-type="preBooked" data-status="BOOKED">
   
        <div class="stat-left">
            <h3>Booked</h3>
            <div class="stat-value">${preBookedBookedCount}</div>
        </div>
        <div class="stat-icon yellow">
            <i class="fa-solid fa-clock"></i>
        </div>
    </div>

    <!-- ACTIVE -->
   <div class="stat-card " data-type="preBooked" data-status="ACTIVE">
   
        <div class="stat-left">
            <h3>Active</h3>
            <div class="stat-value">${preBookedActiveCount}</div>
        </div>
        <div class="stat-icon green">
            <i class="fa-solid fa-bolt"></i>
        </div>
    </div>

    <!-- COMPLETED -->
  <div class="stat-card " data-type="preBooked" data-status="COMPLETED">
  
        <div class="stat-left">
            <h3>Completed</h3>
            <div class="stat-value">${preBookedCompletedCount}</div>
        </div>
        <div class="stat-icon blue">
            <i class="fa-solid fa-check"></i>
        </div>
    </div>

    <!-- CANCELLED -->
   <div class="stat-card " data-type="preBooked" data-status="CANCELLED">
   
        <div class="stat-left">
            <h3>Cancelled</h3>
            <div class="stat-value">${preBookedCancelledCount}</div>
        </div>
        <div class="stat-icon red">
            <i class="fa-solid fa-xmark"></i>
        </div>
    </div>

    <!-- EXPIRED -->
   <div class="stat-card " data-type="preBooked" data-status="EXPIRED">
   
        <div class="stat-left">
            <h3>Expired</h3>
            <div class="stat-value">${preBookedExpiredCount}</div>
        </div>
        <div class="stat-icon gray">
            <i class="fa-solid fa-clock-rotate-left"></i>
        </div>
    </div>

</div>
  

<!-- STATS : WALK-IN -->
<div id="walkInStats" class="stats" style="display:none;">

     <!-- ALL -->
   <div class="stat-card active" data-type="walkIn" data-status="ALL">
   
        <div class="stat-left">
            <h3>All</h3>
            <div class="stat-value">${walkInTotalCount}</div>
            
        </div>
        <div class="stat-icon blue">
            <i class="fa-solid fa-layer-group"></i>
        </div>
    </div>

    <!-- ACTIVE -->
  <div class="stat-card " data-type="walkIn" data-status="ACTIVE">
  
        <div class="stat-left">
            <h3>Active</h3>
            <div class="stat-value">${walkInActiveCount}</div>
        </div>
        <div class="stat-icon green">
            <i class="fa-solid fa-bolt"></i>
        </div>
    </div>

    <!-- COMPLETED -->
   <div class="stat-card " data-type="walkIn" data-status="COMPLETED">
   
        <div class="stat-left">
            <h3>Completed</h3>
            <div class="stat-value">${walkInCompletedCount}</div>
        </div>
        <div class="stat-icon blue">
            <i class="fa-solid fa-check"></i>
        </div>
    </div>

</div>


<hr class="divider">

<!-- TABLE -->
  <!-- Pre-Booked Bookings Table -->
<div id="preBookedTable">
<h3>Pre-Booked Vehicles</h3>
<div class="table-card">
<table>
<thead>
<tr>
    <th>User</th>
    <th>Vehicle</th>
    <th>Slot</th>
    <th>Start Time</th>
    <th>End Time</th>
    <th>Status</th>
    <th>Actions</th>
</tr>
</thead>
<tbody>
   <c:forEach var="b" items="${preBookedBookings}">
    <tr data-status="${b.status}">
        <td>${b.userName}</td>
        <td>${b.vehicleNumber}</td>
        <td>${b.slotNumber}</td>
        <td>${b.startTimeFormatted}</td>
        <td>${b.endTimeFormatted}</td>
        <td>
            <span class="badge ${b.status}">${b.status}</span>
        </td>
        <td class="actions">
            <c:choose>
                <c:when test="${b.status == 'BOOKED'}">
                    <form action="${pageContext.request.contextPath}/checkIn" method="post">
                        <input type="hidden" name="bookingId" value="${b.bookingId}">
                        <button type="submit" class="checkin">
                            <i class="fa-solid fa-right-to-bracket"></i> Check In
                        </button>
                    </form>
                </c:when>

               <c:when test="${b.status == 'ACTIVE'}">
				  <a href="${pageContext.request.contextPath}/vehicleExit?bookingId=${b.bookingId}"
					   class="btn btn-warning">
					   Proceed to Exit
					</a>
				  
				</c:when>
               

                <c:otherwise>No actions</c:otherwise>
            </c:choose>
        </td>
    </tr>
</c:forEach>
   
</tbody>
</table>
</div>
</div>

<!-- Walk-In Bookings Table -->
 
<div id="walkInTable" style="display:none;">
<h3>Walk-In Vehicles</h3>
<div class="table-card">
<table>
<thead>
<tr>
    <th>User</th>
    <th>Vehicle</th>
    <th>Slot</th>
    <th>Entry Time</th>
  <th>Rate (₹/hour)</th>
  
    <th>Status</th>
    <th>Actions</th>
</tr>
</thead>
<tbody>
<c:forEach var="b" items="${walkInBookings}">
    <tr data-status="${b.status}">
      <td>${b.guestName}</td>
      
       
        <td>${b.vehicleNumber}</td>
        <td>${b.slotNumber}</td>
        <td>${b.startTimeFormatted}</td>
       <td>₹${b.hourlyRate}/hr</td>
       <td><span class="badge ${b.status}">${b.status}</span></td>
        <td class="actions">
            <c:choose>
               <c:when test="${b.status == 'ACTIVE'}">
					   <a href="${pageContext.request.contextPath}/vehicleExit?bookingId=${b.bookingId}"
						   class="btn btn-warning">
						   Proceed to Exit
						</a>
					   
					</c:when>
               
                <c:otherwise>No actions</c:otherwise>
            </c:choose>
        </td>
    </tr>
</c:forEach>
</tbody>
</table>
</div>
</div>
     
</div>


<script>
let currentTable = 'preBooked';

document.addEventListener("DOMContentLoaded", () => {
    initStatClicks();
    showTable('preBooked');
});

/* =========================
   INIT STAT CLICK HANDLERS
========================= */
function initStatClicks() {
    console.log("Stat click handlers attached"); 

    document.querySelectorAll('.stat-card').forEach(card => {
        card.addEventListener('click', () => {
            console.log(card.dataset.type, card.dataset.status); 
            const type = card.dataset.type;
            const status = card.dataset.status;

            currentTable = type;
            filterRows(type, status);
            highlightCard(type, card);
        });
    });
}


/* =========================
   SWITCH TABLE
========================= */
function showTable(type) {
    currentTable = type;

    document.getElementById('preBookedTable').style.display =
        type === 'preBooked' ? 'block' : 'none';

    document.getElementById('walkInTable').style.display =
        type === 'walkIn' ? 'block' : 'none';

    document.getElementById('preBookedStats').style.display =
        type === 'preBooked' ? 'grid' : 'none';

    document.getElementById('walkInStats').style.display =
        type === 'walkIn' ? 'grid' : 'none';
    
    
    // toggle button active
    document.querySelectorAll('.toggle-btn').forEach(b => b.classList.remove('active'));
    if (type === 'preBooked') document.querySelector('.toggle-btn[onclick*="preBooked"]').classList.add('active');
    else document.querySelector('.toggle-btn[onclick*="walkIn"]').classList.add('active');

    resetStats(type);
}

/* =========================
   FILTER ROWS
========================= */
function filterRows(type, status) {
    const tableId =
        type === 'preBooked' ? 'preBookedTable' :
        type === 'walkIn' ? 'walkInTable' : null;

    if (!tableId) {
        console.error("Invalid table type:", type);
        return;
    }

    const table = document.getElementById(tableId);
    if (!table) {
        console.error("Table not found:", tableId);
        return;
    }

    const normalized = status.toUpperCase();

    table.querySelectorAll('tbody tr').forEach(row => {
        const rowStatus = row.dataset.status.toUpperCase();
        row.style.display =
            normalized === 'ALL' || rowStatus === normalized ? '' : 'none';
    });
}


/* =========================
   HIGHLIGHT STAT
========================= */
function highlightCard(type, activeCard) {
    const statBox = type === 'preBooked'
        ? '#preBookedStats'
        : '#walkInStats';

    document.querySelectorAll(`${statBox} .stat-card`)
        .forEach(c => c.classList.remove('active'));

    activeCard.classList.add('active');
}

/* =========================
   RESET ON TAB SWITCH
========================= */
function resetStats(type) {
    const statBox = type === 'preBooked'
        ? '#preBookedStats'
        : '#walkInStats';

    const cards = document.querySelectorAll(`${statBox} .stat-card`);
    cards.forEach(c => c.classList.remove('active'));

    const first = cards[0];
    if (first) {
        first.classList.add('active');
        filterRows(type, 'ALL');
    }
}
</script>


</body>
</html>
