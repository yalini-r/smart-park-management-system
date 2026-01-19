<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.smartpark.dto.ParkingSlot" %>
<%@ page import="com.smartpark.dto.Booking" %>
<%@ page import="com.smartpark.dto.User" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>




<!DOCTYPE html>
<html>
<head>
    <title>Book Parking Slot</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>

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
        
.container {
    margin-left: 260px;
            padding: 30px 40px;
}

/* TOP TITLE */
 .title-row {
  display: flex;
  justify-content: space-between;
  flex-direction:column;
  margin-bottom: 30px;
		}
		
.title-row h1 {
  margin: 0;
  font-size: 26px;
  letter-spacing: -0.2px;
}

.subtitle {
  color: #8b97a8;
  font-size: 13px;
  margin-top: 6px;
}


/* STATS BAR */
.stats-card {
    background: #fff;
    padding: 18px;
    border-radius: 14px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.08);
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 25px;
}

.stats-left {
    display: flex;
    gap: 25px;
}

.stat-box {
    background: #f1f4f7;
    padding: 10px 16px;
    border-radius: 10px;
    font-weight: 600;
}

/* View booking button */
.view-btn {
    background: linear-gradient(to right, #6366f1, #7c3aed);
    border: none;
    padding: 10px 18px;
    color: white;
    border-radius: 10px;
    font-weight: 600;
    cursor: pointer;
}

/* LEGEND */
.legend {
 display: flex; 
 gap: 20px; 
 margin-bottom: 20px; 
 } 
.legend-item { 
display: flex;
 align-items: center; 
 gap: 6px; 
 font-size: 15px; 
 } 
.legend-box { 
	width: 12px;
	height: 12px; 
	display: inline-block;
	border-radius: 3px; 
  } 
.legend-box.free { background: #4CAF50; }
.legend-box.reserved { background: #2196F3; } 
.legend-box.occupied { background: #f44336; }
.legend-box.oth-booked { background: #6b7280; }

/* SLOT FLOOR CARD */
.floor-card {
    background: #fff;
    padding: 20px 30px;
    border-radius: 14px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    margin-top: 25px;
}


.floor-title {
 
    font-size: 20px;
    margin-bottom: 12px;
    font-weight: 700;
}

/* SLOT GRID */
.slots-grid {
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    gap: 12px;
}

.slot {
    height: 90px;
    padding: 20px;
    text-align: center;
    border-radius: 10px;
    cursor: pointer;
    font-weight: 700;
    font-size: 16px;
    transition: transform 0.2s;
}


.slot.free {
    background:#d1fae5;
    color:#10b981;
    border:2px solid #10b981;
}

.slot.selected {
    background:#fef9c3;
    color:#b45309;
    border:2px solid #b45309;
}

.slot.own-booked {
    background:#dbeafe;
    color:#2563eb;
    border:2px solid #2563eb;
    cursor: not-allowed;
}

.slot.other-booked {
    background: #e5e7eb;   
    color: #6b7280;
    border: 2px dashed #9ca3af;
    cursor: not-allowed;
}


.slot.occupied {
    background:#fee2e2;
    color:#dc2626;
    border:2px solid #dc2626;
    cursor: not-allowed;
}

.slot.free:hover {
    transform: scale(1.05);
}

/* POPUP */
.popup {
    position: fixed;
    top: 0; left: 0;
    height: 100%; width: 100%;
    background: rgba(0,0,0,0.45);
    justify-content: center;
    align-items: center;
    display: none;
}

.booking-form {
    background: #fff;
    padding: 25px;
    width: 360px;
    border-radius: 12px;
    position: relative;
    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
}

.close-btn {
    position: absolute;
    top: 12px;
    right: 14px;
    font-size: 25px;
    cursor: pointer;
}
.booking-form  h2{
  text-align: center;
  font-size: 25px;
  margin-bottom: 5px;
}

.booking-form label {
     display: block;
     margin-bottom: 6px;
     margin-top:20px;
     font-size:14px;
     font-weight: 500;
     color: #374151;
    }

.booking-form input , 
.booking-form select{
   width: 100%;
   padding: 12px 12px 12px 38px;
   font-size: 14px;
   border: 1px solid #e5e7eb;
   border-radius: 8px;
   background: #f9fafb;
   outline: none;
   transition: 0.2s;
}

#estimatedAmount{
 width: 30%;
   padding: 10px 20px;
   font-size: 14px;
   border: 1px solid #e5e7eb;
   border-radius: 8px;
   background: #f9fafb;
    outline: none;
   transition: 0.2s;
}

.booking-form input:focus {
     background: #fff;
     border-color:#6366f1;
    }

 

.booking-form button {
     width: 100%;
     background: linear-gradient(to right, #6366f1, #7c3aed);
     padding: 12px;
     border: none;
     border-radius: 8px;
     color: white;
     font-size: 16px;
     cursor: pointer;
     margin-top: 30px;
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

<div class="container">

  
      <div class="title-row">
       <h1>Book Parking Slot</h1>
       <div class="subtitle">View and manage your reservations</div>
   </div>

    <!-- STATS -->
    <div class="stats-card">
        <div class="stats-left">
            <div class="stat-box">
              <i class="fa-solid fa-car"></i> Total: ${fn:length(slots)}
            </div>
            <div class="stat-box">
            <i class="fa-solid fa-square-check"></i> Available: ${availableCount}
            </div>
            
            <div class="stat-box">
            <i class="fa-solid fa-ban"></i> Occupied: ${occupiedCount}
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/user/view-bookings">
            <button class="view-btn">View Bookings</button>
        </form>
    </div>

    <!-- LEGEND -->
    <div class="legend"> 
        <div class="legend-item"><span class="legend-box free"></span> Available</div> 
        <div class="legend-item"><span class="legend-box reserved"></span> Your Booking</div> 
        <div class="legend-item"><span class="legend-box occupied"></span> Occupied</div> 
        <div class="legend-item"><span class="legend-box oth-booked"></span> Booked by Other</div>
    </div>

<!-- SLOT GRID -->
<c:set var="currentFloor" value="-1" />

<c:forEach var="s" items="${slots}">

    <!-- New floor -->
    <c:if test="${currentFloor != s.floor}">

        <!-- Close previous floor -->
        <c:if test="${currentFloor != -1}">
                </div> <!-- close slots-grid -->
            </div> <!-- close floor-card -->
        </c:if>

        <c:set var="currentFloor" value="${s.floor}" />

        <div class="floor-card">
            <div class="floor-title">Floor ${s.floor}</div>
            <div class="slots-grid">

    </c:if>

    <!-- Determine slot class -->
    <c:set var="active" value="${activeMap[s.slotId]}" />
    <c:set var="booked" value="${bookedMap[s.slotId]}" />

    <c:choose>
        <c:when test="${active != null}">
            <c:set var="cls" value="occupied" />
        </c:when>
        <c:when test="${booked != null and booked.userId == user.id}">
            <c:set var="cls" value="own-booked" />
        </c:when>
        <c:when test="${booked != null and booked.userId != user.id}">
            <c:set var="cls" value="other-booked" />
        </c:when>
        <c:when test="${s.status eq 'OCCUPIED'}">
            <c:set var="cls" value="occupied" />
        </c:when>
        <c:otherwise>
            <c:set var="cls" value="free" />
        </c:otherwise>
    </c:choose>

    <!-- Render slot -->
    <div class="slot ${cls}" 
         data-slot-id="${s.slotId}" 
         data-enabled="${cls eq 'free'}">
        <i class="fa-solid fa-car"></i><br>
        ${s.slotNumber}
    </div>

</c:forEach>

<!-- Close LAST floor -->
</div> 
</div> 


<!-- POPUP -->
<div id="popup" class="popup">

    <form class="booking-form" 
          action="${pageContext.request.contextPath}/user/booking-action" method="post">
        <div class="close-btn">&times;</div>
        <input type="hidden" name="action" value="create">
        <input type="hidden" name="slotId" id="slotId">

        <h2>Book Slot</h2>
        <label>Start Time</label>
		<input type="datetime-local" name="startTime" id="startTime" min="${nowPlus30}" required>
		
		<label>End Time</label>
		<input type="datetime-local" name="endTime" id="endTime" required>
       
        <label>Vehicle Type</label>
		<select name="vehicleType" id="vehicleType" required>
		    <option value="">Select Vehicle Type</option>
		    <option value="CAR">Car</option>
		    <option value="MOTORCYCLE">Motor bike</option>
		</select>
         
        <label>Vehicle Number</label>
		<input type="text" name="vehicle_number"
		       pattern="[A-Z]{2}\s?[0-9]{2}\s?[A-Z]{1,2}\s?[0-9]{4}"
		       placeholder="AB12CD3456" required style="text-transform:uppercase;">
		<label>Estimated Amount</label>

		<div id="estimatedAmount" style="font-weight:600; margin-top:5px;">
		    ₹0
		</div>
		
		<input type="hidden" name="estimatedAmount" id="estimatedAmountInput" value="0">
		
        <button>Book Now</button>
    </form>
</div>

<script>
// ------------------- Keep all your existing JS as-is -------------------
let selected = null;
document.querySelectorAll(".slot").forEach(slot => {
    slot.addEventListener("click", () => {
        if (slot.dataset.enabled!== "true") return;
        if (selected) selected.classList.remove("selected");
        selected = slot;
        slot.classList.add("selected");
        document.getElementById("slotId").value = slot.dataset.slotId;
        document.getElementById("popup").style.display = "flex";
    });
});
document.querySelector(".close-btn").onclick = () => {
    document.getElementById("popup").style.display = "none";
    if (selected) selected.classList.remove("selected");
};
document.getElementById("popup").onclick = function(e) {
    if (e.target === this) {
        this.style.display = "none";
        if (selected) selected.classList.remove("selected");
    }
};

const BUFFER_MINUTES = 30;
const now = new Date();
now.setMinutes(now.getMinutes() + BUFFER_MINUTES - now.getTimezoneOffset());
const minDateTime = now.toISOString().slice(0, 16);
document.getElementById("startTime").min = minDateTime;
document.getElementById("endTime").min = minDateTime;
document.getElementById('startTime').addEventListener('change', updateEstimatedAmount);
document.getElementById('endTime').addEventListener('change', updateEstimatedAmount);
document.querySelector('select[name="vehicleType"]').addEventListener('change', updateEstimatedAmount);

function updateEstimatedAmount() {
    const vehicleType = document.querySelector('select[name="vehicleType"]').value;
    const startValue = document.getElementById('startTime').value;
    const endValue = document.getElementById('endTime').value;

    if (!vehicleType || !startValue || !endValue) {
        document.getElementById('estimatedAmount').textContent = "₹0";
        document.getElementById('estimatedAmountInput').value = 0;
        return;
    }

    const start = new Date(startValue);
    const end = new Date(endValue);
    if (end <= start) {
        document.getElementById('estimatedAmount').textContent = "₹0";
        document.getElementById('estimatedAmountInput').value = 0;
        return;
    }

    let ratePerHour = vehicleType === "CAR" ? 50 : 30;
    let hours = Math.ceil((end - start) / (1000 * 60 * 60));
    if (hours < 1) hours = 1;
    const amount = hours * ratePerHour;
    document.getElementById('estimatedAmount').textContent = "₹" + amount;
    document.getElementById('estimatedAmountInput').value = amount;
}
</script>

</body>
</html>
