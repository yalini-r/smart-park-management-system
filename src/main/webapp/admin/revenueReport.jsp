<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartpark.dto.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
User u = (User) session.getAttribute("user");
if (u == null || !"ADMIN".equalsIgnoreCase(u.getRole())) {
    response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
    return;
}
%>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Revenue Report</title>

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

   


.divider { 
    border:none; 
    border-top:2px solid #ddd; 
    margin:20px 0; 
}

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

.badge.PREBOOK { background:#e5f0ff; color:#1559c5; }
.badge.WALKIN { background:#e7f8ec; color:#108b32; }


#revenueChart {
    background: #fff;
    border-radius: 14px;
    padding: 10px;
    margin-bottom: 30px;

    width: 100% !important;
    height: 300px !important;   
    max-height: 300px;
}


.toggle-btn.active {
    background: #108b32;
    color: white;
}


</style>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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

<!-- STATS -->

  <!-- STATS : PRE-BOOKED -->
<div id="preBookedStats" class="stats">

<div class="stat-card active" data-type="preBooked"  data-status="TODAY">

           <div class="stat-left">
            <h3>Today's Revenue</h3>
            <div class="stat-value">₹${stats.preBookToday}</div>
           </div>
  
            <div class="stat-icon blue">
            <i class="fa-solid fa-coins"></i>
            </div>
   </div>
    
   <div class="stat-card" data-type="preBooked"  data-status="WEEK">

           <div class="stat-left">
            <h3>This WeeK</h3>
            <div class="stat-value">₹${stats.preBookWeek}</div>
            
           </div>
  
            <div class="stat-icon blue">
            <i class="fa-solid fa-coins"></i>
            </div>
   </div>
   
    <div class="stat-card" data-type="preBooked"  data-status="MONTH">

           <div class="stat-left">
            <h3>This MONTH</h3>
            <div class="stat-value">₹${stats.preBookMonth}</div>
           </div>
  
            <div class="stat-icon blue">
            <i class="fa-solid fa-coins"></i>
            </div>
   </div>
   
   
    <div class="stat-card" data-type="preBooked"  data-status="ALL">

           <div class="stat-left">
            <h3>Total</h3>
            <div class="stat-value">₹${stats.preBookTotal}</div>
           </div>
  
            <div class="stat-icon blue">
            <i class="fa-solid fa-coins"></i>
            </div>
   </div>
   
   
   
    
    
  </div>
  
  <!-- STATS : WALK-IN -->
  <div id="walkInStats" class="stats" style="display:none;">
  
      <div class="stat-card active" data-type="walkIn"  data-status="TODAY">

           <div class="stat-left">
            <h3>Today's Revenue</h3>
            <div class="stat-value">₹${stats.walkinToday}</div>
           </div>
  
            <div class="stat-icon blue">
            <i class="fa-solid fa-coins"></i>
            </div>
   </div>
   
   <div class="stat-card" data-type="walkIn"  data-status="WEEK">

           <div class="stat-left">
            <h3>This WeeK</h3>
            <div class="stat-value">₹${stats.walkinWeek}</div>
           </div>
  
            <div class="stat-icon blue">
            <i class="fa-solid fa-coins"></i>
            </div>
   </div>
   
    <div class="stat-card"  data-type="walkIn" data-status="MONTH">

           <div class="stat-left">
            <h3>This MONTH</h3>
            <div class="stat-value">₹${stats.walkinMonth}</div>
           </div>
  
            <div class="stat-icon blue">
            <i class="fa-solid fa-coins"></i>
            </div>
   </div>
   
   
   <div class="stat-card" data-type="walkIn" data-status="ALL">
   

           <div class="stat-left">
            <h3>Total</h3>
            <div class="stat-value">₹${stats.walkinTotal}</div>
           </div>
  
            <div class="stat-icon blue">
            <i class="fa-solid fa-coins"></i>
            </div>
   </div>
   
   
  
  </div>
  
  <!-- ================= CHART ================= -->
<canvas id="revenueChart"></canvas>



       
<hr class="divider">

<!-- TABLE -->
  <!-- Pre-Booked Bookings Table -->

<div id="preBookedTable">
<h3>Pre-Booked Vehicles</h3>
<div class="table-card">
<table>
<thead>
<tr>
<th>#</th>
<th>Vehicle number</th>
<th>Type</th>
<th>Slot</th>
<th>date</th>
<th>Amount</th>
</tr>
</thead>
<tbody>
<c:forEach var="v" items="${preBookedRevenueList}" varStatus="s">
<tr data-booking="${v.bookingType}">
<td>${s.count}</td>
<td>${v.numberPlate}</td>
<td><span class="badge ${v.bookingType}">${v.bookingType}</span></td>
<td>${v.slotNumber}</td>
<td><fmt:formatDate value="${v.exitTime}" pattern="yyyy-MM-dd "/></td>
<td>₹${v.finalAmount}</td>
</tr>
</c:forEach>
</tbody>
</table>
</div>
</div>

<!----walk in table---->

<div id="walkInTable" style="display:none;">
<h3>Walk-In Vehicles</h3>
<div class="table-card">
<table>
<thead>
<tr>
<th>#</th>
<th>Vehicle number</th>
<th>Type</th>
<th>Slot</th>
<th>date</th>
<th>Amount</th>
</tr>
</thead>
<tbody>
<c:forEach var="v" items="${walkInRevenueList}" varStatus="s">
<tr data-booking="${v.bookingType}">
<td>${s.count}</td>
<td>${v.numberPlate}</td>
<td><span class="badge ${v.bookingType}">${v.bookingType}</span></td>
<td>${v.slotNumber}</td>
<td><fmt:formatDate value="${v.exitTime}" pattern="yyyy-MM-dd "/></td>
<td>₹${v.finalAmount}</td>
</tr>
</c:forEach>

</tbody>
</table>
</div>
</div>


</div>

<script>




let ctx = document.getElementById('revenueChart').getContext('2d');

/* ======================
   LABEL SETS
====================== */
const weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
const monthLabels = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
const todayLabels = ['Today'];

/* ======================
   DATA FROM JSP
====================== */
const preBookedData = [
<c:forEach var="v" items="${preBookedChartData}" varStatus="s">
${v}${!s.last ? ',' : ''}
</c:forEach>
];

const walkInData = [
<c:forEach var="v" items="${walkInChartData}" varStatus="s">
${v}${!s.last ? ',' : ''}
</c:forEach>
];

/* ======================
   INITIAL CHART
====================== */
let chart = new Chart(ctx, {
    type: 'line',
    data: {
        labels: todayLabels,
        datasets: [{
            label: 'Revenue',
            data: [preBookedData[0]]
        }]
    }
});

let currentType = 'preBooked';

/* ======================
   STAT CLICK
====================== */
document.querySelectorAll('.stat-card').forEach(card => {
    card.addEventListener('click', () => {
        const type = card.dataset.type;
        const status = card.dataset.status;

        currentType = type;
        updateChart(type, status);
        highlightCard(type, card);
    });
});

/* ======================
   UPDATE CHART
====================== */
function updateChart(type, status) {

    const data = type === 'preBooked' ? preBookedData : walkInData;

    chart.destroy();

    // TOTAL → DOUGHNUT (SMALL)
    if (status === 'ALL') {
        chart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Today', 'Week', 'Month'],
                datasets: [{
                    data: [data[0], data[1], data[2]],
                radius: '80%'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                cutout: '70%',   
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });
        return;
    }

    // TODAY
    if (status === 'TODAY') {
        chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: todayLabels,
                datasets: [{
                    label: 'Revenue',
                    data: [data[0]]
                }]
            }
        });
        return;
    }

    // WEEK
    if (status === 'WEEK') {
        chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: weekLabels,
                datasets: [{
                    label: 'Revenue',
                    data: data.slice(0, 5) // Mon–Fri
                }]
            }
        });
        return;
    }

    // MONTH
    if (status === 'MONTH') {
        chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: monthLabels,
                datasets: [{
                    label: 'Revenue',
                    data: data.slice(0, 12)
                }]
            }
        });
    }
}

/* =========================
   SWITCH TABLE (TAB)
========================= */
function showTable(type) {
    currentType = type;
    currentStatus = 'TODAY';

    document.getElementById('preBookedTable').style.display =
        type === 'preBooked' ? 'block' : 'none';

    document.getElementById('walkInTable').style.display =
        type === 'walkIn' ? 'block' : 'none';

    document.getElementById('preBookedStats').style.display =
        type === 'preBooked' ? 'grid' : 'none';

    document.getElementById('walkInStats').style.display =
        type === 'walkIn' ? 'grid' : 'none';

    /* Toggle button active */
    document.querySelectorAll('.toggle-btn').forEach(b => b.classList.remove('active'));
    if (type === 'preBooked')
        document.querySelector('.toggle-btn[onclick*="preBooked"]').classList.add('active');
    else
        document.querySelector('.toggle-btn[onclick*="walkIn"]').classList.add('active');

    resetStats(type);
    updateChart(type, 'TODAY');
}

/* =========================
   HIGHLIGHT ACTIVE STAT
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
   RESET STATS ON TAB SWITCH
========================= */
function resetStats(type) {
    const statBox = type === 'preBooked'
        ? '#preBookedStats'
        : '#walkInStats';

    const cards = document.querySelectorAll(`${statBox} .stat-card`);
    cards.forEach(c => c.classList.remove('active'));

    if (cards.length > 0) {
        cards[0].classList.add('active');
    }
}

/* ======================
DEFAULT LOAD
====================== */
document.addEventListener("DOMContentLoaded", () => {
 showTable('preBooked');
});
</script>






</body>
</html>
