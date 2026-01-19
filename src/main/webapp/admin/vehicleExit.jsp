<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Vehicle Exit</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
/* ===== SAME CSS (UNCHANGED) ===== */
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
.sidebar {
    position: fixed; top: 0; left: 0;
    width: 260px; height: 100vh;
    background: #fff;
    border-right: 1px solid #e5e7eb;
    padding: 20px 10px;
}
#logo { border-bottom: 1px solid #e5e7eb; }
.sidebar h2 {
    text-align: center; font-size: 22px;
    color: #1559c5; margin-bottom: 20px;
}
.sidebar a {
    display: flex; align-items: center;
    gap: 14px; padding: 12px 18px;
    margin: 10px 0;
    color: #6b7280;
    text-decoration: none;
    border-radius: 10px;
}
.sidebar a:hover {
    background: #f0f6ff;
    color: #1559c5;
    font-weight: 600;
}
#pf { margin-top: 180px; }

/* MAIN */

.container {
    margin-left: 280px;
    padding: 30px 50px;
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

.stats {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
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

.blue { background:#e5f0ff; color:#1559c5;}
.green { background:#e7f8ec; color:#108b32;  }
.red { background: #fee2e2; color: #b91c1c; }
.yellow { background:#fff6d6; color:#f1c40f; }


.divider { 
    border:none; 
    border-top:2px solid #ddd; 
    margin:20px 0; 
}

#pre-table h3 ,
#walkin-table h3{

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

.btn {
    padding: 8px 16px;
    border-radius: 10px;
    border: none;
    font-weight: 600;
    cursor: pointer;
    background: #4f46e5;
    color: white;
}
.btn:hover { background: #4338ca; }

.overstay {
    background-color: #fee2e2;
    font-weight: 600;
}

.longstay { background-color: #d1f0ff; font-weight: 500; }
.highfee { background-color: #fef3c7; font-weight: 500; }


.toggle-btn.active {
    background: #108b32;
    color: white;
}


</style>
</head>

<body>

<!-- ===== SIDEBAR ===== -->
<div class="sidebar">
  <div id="logo"><h2>Admin Panel</h2></div>

  <a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp"><i class="fa-solid fa-gauge"></i>Dashboard</a>
  <a href="${pageContext.request.contextPath}/admin/manageSlots.jsp"><i class="fa-solid fa-square-parking"></i>Manage Slots</a>
  <a href="${pageContext.request.contextPath}/admin/manageUsers.jsp"><i class="fa-solid fa-users"></i>Manage Users</a>
  <a href="${pageContext.request.contextPath}/viewBookings"><i class="fa-solid fa-list-check"></i>View Bookings</a>
  <a href="${pageContext.request.contextPath}/vehicleEntry"><i class="fa-solid fa-car-side"></i>Vehicle Entry</a>
  <a href="${pageContext.request.contextPath}/vehicleExit"><i class="fa-solid fa-arrow-right-from-bracket"></i>Vehicle Exit</a>
    <a href="${pageContext.request.contextPath}/admin/revenue">
      
      <i class="fa-solid fa-chart-line"></i>
      
       <span>Revenue Report</span>
      </a>
  <div id="pf">
    <a href="${pageContext.request.contextPath}/profile/profile.jsp"><i class="fa-solid fa-user"></i>Profile</a>
    <a href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i>Logout</a>
  </div>
</div>

<!-- ===== MAIN ===== -->
<div class="container">

  <div class="page-title-bar" style="display:flex; justify-content: space-between; align-items:center; margin-bottom: 20px;">
   
    <div>
      <h1 class="page-title">Vehicle Exit</h1>
      <p class="page-subtitle">Pre-Booked & Walk-In exit management</p>
    </div>
    
     <!-- TOGGLE BUTTONS -->
  <div>
    <button class="toggle-btn active" onclick="showSection('pre')">Pre-Booked</button>
    
    <button class="toggle-btn" onclick="showSection('walkin')">Walk-In</button>
  </div>
  </div>

 

  <!-- PRE-BOOKED STATS -->
  
<div id="pre-stats" class="stats">

  <div class="stat-card active" onclick="filterPre('all', this)">
  
        <div class="stat-left">
            <h3>Total Pre-Booked</h3>
            <div class="stat-value">${preStats.total}</div>
        </div>
        <div class="stat-icon blue">
            <i class="fa-solid fa-calendar-check"></i>
        </div>
    </div>

    <div class="stat-card"
         onclick="filterPre('long' , this)">
        <div class="stat-left">
            <h3>Long Stay</h3>
            <div class="stat-value">${preStats.longStay}</div>
        </div>
        <div class="stat-icon green">
            <i class="fa-solid fa-clock"></i>
        </div>
    </div>

    <div class="stat-card"
         onclick="filterPre('overstay' , this)">
        <div class="stat-left">
            <h3>Overstay</h3>
            <div class="stat-value">${preStats.overstay}</div>
        </div>
        <div class="stat-icon red">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>
    </div>
    
    <div class="stat-card" onclick="filterPre('exited', this)">
  <div class="stat-left">
    <h3>Exited Vehicles</h3>
    <div class="stat-value">${preStats.exited}</div>
  </div>
  <div class="stat-icon green">
    <i class="fa-solid fa-check-circle"></i>
  </div>
</div>
    

    <div class="stat-card">
        <div class="stat-left">
            <h3>Revenue</h3>
            <div class="stat-value"><fmt:formatNumber value="${preStats.revenue}" type="currency" currencySymbol="₹" />
            </div>
        </div>
        <div class="stat-icon yellow">
            <i class="fa-solid fa-indian-rupee-sign"></i>
        </div>
    </div>
    
   
    

</div>	

 
<!-- WALK-IN STATS -->
<div id="walkin-stats" class="stats" style="display:none">

   <div class="stat-card active" onclick="filterWalk('all', this)">
        <div class="stat-left">
            <h3>Total Walk-In</h3>
            <div class="stat-value">${walkInStats.total}</div>
        </div>
        <div class="stat-icon blue">
            <i class="fa-solid fa-car"></i>
        </div>
    </div>

    <div class="stat-card" onclick="filterWalk('long' ,  this)">
        <div class="stat-left">
            <h3>Long Stay</h3>
            <div class="stat-value">${walkInStats.longStay}</div>
        </div>
        <div class="stat-icon red">
            <i class="fa-solid fa-hourglass-half"></i>
        </div>
    </div>
    
    <div class="stat-card" onclick="filterWalk('exited', this)">
  <div class="stat-left">
    <h3>Exited Vehicles</h3>
  <div class="stat-value">${walkInStats.exited}</div>
  
  </div>
  <div class="stat-icon green">
    <i class="fa-solid fa-check-circle"></i>
  </div>
</div>
    

    <div class="stat-card" >
        <div class="stat-left">
            <h3>Revenue</h3>
            <div class="stat-value"><fmt:formatNumber value="${walkInStats.revenue}" type="currency" currencySymbol="₹" />
            </div>
        </div>
        <div class="stat-icon yellow">
            <i class="fa-solid fa-indian-rupee-sign"></i>
        </div>
    </div>
    
    
    

</div>

<hr class="divider">
 
<!-- TABLE -->

  <!-- PRE-BOOKED TABLE -->
  <div id="pre-table" class="card">
  <h3>Pre-Booked Vehicles</h3>
<div class="table-card">
    <table>
      <thead>
        <tr>
        <th>User</th>
          <th>Vehicle</th>
          
          <th>Slot</th>
          <th>Entry Time</th>
           <th>Booking End Time</th>
           <th>Exit Time</th>
            <th>Estimated Fee (₹)</th>
            <th>Final Fee (₹)</th>
            <th>Action</th>
          
        </tr>
      </thead>
      <tbody>
      <c:forEach var="v" items="${preBookedVehicles}">
              <tr
			  data-overstay="${v.overstay}"
			  data-long="${v.longStay}"
			  data-exited="${v.exitTime != null}"
			  class="${v.overstay ? 'overstay' : ''} ${v.longStay ? 'longstay' : ''} ${v.finalAmount > 200 ? 'highfee' : ''}"
			  
			>
                     <td>${v.userName}</td>
                    <td>${v.numberPlate}</td>
                   
                    <td>Slot ${v.slotNumber}</td>
                    <td title="${v.entryTime}">
					    <fmt:formatDate value="${v.entryTime}" pattern="HH:mm"/>
					</td>
					<td title="${v.bookingEndTime}">
					    <c:choose>
					        <c:when test="${v.bookingEndTime != null}">
					            <fmt:formatDate value="${v.bookingEndTime}" pattern="HH:mm"/>
					        </c:when>
					        <c:otherwise>-</c:otherwise>
					    </c:choose>
					</td>
                    
                    
                    <td>
				    <c:choose>
				        <c:when test="${v.exitTime != null}">
				          <fmt:formatDate value="${v.exitTime}" pattern="HH:mm"/>
				          
				        </c:when>
				        <c:otherwise>-</c:otherwise>
				    </c:choose>
				   </td>
                    <td><fmt:formatNumber value="${v.estimatedAmount}" type="currency" currencySymbol="₹" />

                    </td>
                    <td>
					  <c:choose>
					    <c:when test="${not empty v.finalAmount}">
					      <fmt:formatNumber value="${v.finalAmount}" type="currency" currencySymbol="₹" />
					    </c:when>
					    <c:otherwise>
					     <fmt:formatNumber value="${v.estimatedAmount}" type="currency" currencySymbol="₹" />
					    </c:otherwise>
					  </c:choose>
					</td>
                    
                   <td>
					    <c:if test="${v.exitTime == null}">
					        <form method="post" action="${pageContext.request.contextPath}/vehicleExit">
					            <input type="hidden" name="bookingId" value="${v.bookingId}">
					            <button class="btn btn-danger" type="submit">
					                Checkout
					            </button>
					        </form>
					    </c:if>
					
					    <c:if test="${v.exitTime != null}">
					        <span class="badge bg-success">Exited</span>
					    </c:if>
					</td>
                   
                </tr>
            </c:forEach>
      </tbody>
    </table>
    </div>
  </div>

 <!-- WALK-IN TABLE -->
<div id="walkin-table" class="card" style="display:none">
<h3>Walk-In Vehicles</h3>
<div class="table-card">
    <table>
      <thead>
        <tr>
         
          <th>Vehicle</th>
          <th>Slot</th>
          <th>Entry Time</th>
           <th>Exit Time</th>
          <th>Estimated Fee (₹)</th>
          <th>Final Fee (₹)</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="v" items="${walkInVehicles}">
          <tr
		  data-long="${v.longStay}"
		data-exited="${v.exitTime != null}"
		
		 
		  class="${v.overstay ? 'overstay' : ''} ${v.longStay ? 'longstay' : ''} ${v.finalAmount > 200 ? 'highfee' : ''}"
		 >
		          
                <td>${v.numberPlate}</td>
                <td>Slot ${v.slotNumber}</td>
                <td title="${v.entryTime}">
				    <fmt:formatDate value="${v.entryTime}" pattern="HH:mm"/>
				</td>
                 <td>
				    <c:choose>
				        <c:when test="${v.exitTime != null}">
				           <fmt:formatDate value="${v.exitTime}" pattern="HH:mm"/>
				           
				        </c:when>
				        <c:otherwise>-</c:otherwise>
				    </c:choose>
				</td>
                 
                <td><fmt:formatNumber value="${v.estimatedAmount}" type="currency" currencySymbol="₹" /></td>
               <td>
				  <c:choose>
				    <c:when test="${not empty v.finalAmount}">
				     <fmt:formatNumber value="${v.finalAmount}" type="currency" currencySymbol="₹" />
				    </c:when>
				    <c:otherwise>
				     <fmt:formatNumber value="${v.estimatedAmount}" type="currency" currencySymbol="₹" />
				    </c:otherwise>
				  </c:choose>
				</td>
               
                <td>
			    <c:if test="${v.exitTime == null}">
			        <form method="post" action="${pageContext.request.contextPath}/vehicleExit">
			            <input type="hidden" name="bookingId" value="${v.bookingId}">
			            <button class="btn btn-danger" type="submit">
			                Checkout
			            </button>
			        </form>
			    </c:if>
			
			    <c:if test="${v.exitTime != null}">
			        <span class="badge bg-success">Exited</span>
			    </c:if>
			</td>
			                
            </tr>
        </c:forEach>
      </tbody>
    </table>
    </div>
</div>
 
</div>

<script>
function showSection(type) {
  document.getElementById("pre-stats").style.display = type === 'pre' ? 'grid' : 'none';
  document.getElementById("walkin-stats").style.display = type === 'walkin' ? 'grid' : 'none';
  document.getElementById("pre-table").style.display = type === 'pre' ? 'block' : 'none';
  document.getElementById("walkin-table").style.display = type === 'walkin' ? 'block' : 'none';
  
  // toggle button active
  document.querySelectorAll('.toggle-btn').forEach(b => b.classList.remove('active'));
  if (type === 'pre') document.querySelector('.toggle-btn[onclick*="pre"]').classList.add('active');
  else document.querySelector('.toggle-btn[onclick*="walkin"]').classList.add('active');
}

function filterPre(type, el) {

	  document.querySelectorAll('#pre-table tbody tr').forEach(row => {

	    if (type === 'all') {
	      row.style.display = '';
	    }
	    else if (type === 'long' && row.dataset.long === 'true') {
	      row.style.display = '';
	    }
	    else if (type === 'overstay' && row.dataset.overstay === 'true') {
	      row.style.display = '';
	    }
	    else if (type === 'exited' && row.dataset.exited === 'true') {
	      row.style.display = '';
	    }
	    else {
	      row.style.display = 'none';
	    }

	  });

	  // highlight active stat
	  document.querySelectorAll('#pre-stats .stat-card')
	    .forEach(c => c.classList.remove('active'));

	  el.classList.add('active');
	}



function filterWalk(type , el) {

	  document.querySelectorAll('#walkin-table tbody tr').forEach(row => {

	    if (type === 'all') {
	      row.style.display = '';
	    }
	    else if (type === 'long' && row.dataset.long === 'true') {
	      row.style.display = '';
	    }
	    else if (type === 'exited' && row.dataset.exited === 'true') {
	      row.style.display = '';
	    }
	    else {
	      row.style.display = 'none';
	    }
	  });

	  // highlight active card
	  document.querySelectorAll('#walkin-stats .stat-card')
	    .forEach(c => c.classList.remove('active'));

	  el.classList.add('active');
	}
	
	
function disableExitBtn(btn) {
    btn.disabled = true;
    btn.innerHTML = '<i class="fa fa-spinner fa-spin"></i> Processing...';
    btn.style.opacity = '0.6';
    return true;
}


</script>

</body>
</html>
