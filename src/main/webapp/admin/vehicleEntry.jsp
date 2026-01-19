<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
<c:if test="${not empty sessionScope.success}">
  <div class="alert success">
    <i class="fa-solid fa-circle-check"></i>
    ${sessionScope.success}
  </div>
  <c:remove var="success" scope="session"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Vehicle Entry</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<style>
:root {
  --bg: #f6f9fc;
  --card-bg: #ffffff;
  --primary: #3b82f6;
  --muted: #8b97a8;
  --success: #10b981;
  --shadow: 0 6px 18px rgba(39, 57, 84, 0.06);
  --radius: 12px;
  --glass: rgba(255, 255, 255, 0.6);

  --text: #1f2937;
  --border: rgba(15, 23, 42, 0.08);
  --primary-light: rgba(59, 130, 246, 0.12);
}

    * {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

html, body{
 height: 100%;
  background: var(--bg);
  font-family: Inter, system-ui, -apple-system, "Segoe UI", Roboto, Arial, sans-serif;
  color: var(--text);
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


.wrapper {
  max-width: 1000px;
  margin-left:380px;
  padding:50px 30px;
}
   
   
/* Header */
.page-header {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 18px;
}
.page-header .icon {
  background: #1559c5;;
  color: #fff;
  width: 44px;
  height: 44px;
  border-radius: var(--radius);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
}
.page-header h1 {
  margin: 0;
  font-size: 26px;
}
.page-header p {
  margin: 2px 0 0;
  color: var(--muted);
  font-size: 14px;
}

/* Tabs */
.tabs {
  display: flex;
  background: var(--card-bg);
  border-radius: var(--radius);
  padding: 6px;
  box-shadow: var(--shadow);
  margin-bottom: 20px;
}
.tab {
  flex: 1;
  text-align: center;
  padding: 10px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  color: var(--muted);
  cursor: pointer;
}
.tab.active {
  background:#e5f0ff;
  color: #1559c5;

}

/* Cards */
.card {
  background: var(--card-bg);
  border-radius: var(--radius);
  padding: 22px;
  box-shadow: var(--shadow);
  border: 1px solid var(--border);
  margin-bottom: 22px;
}
.card h3 {
  margin: 0 0 14px;
  font-size: 18px;
}

/* Form */
.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}
.field label {
  display: block;
  font-size: 13px;
  color: var(--text);
  margin-bottom: 6px;
}
.field input,
.field select {
  width: 100%;
  padding: 10px 12px;
  border-radius: 8px;
  border: 1px solid var(--border);
  font-size: 14px;
  background: #fff;
  color: var(--text);
}
.field input:focus,
.field select:focus {
  outline: none;
  border-color: var(--primary);
}

/* Slot Section */
.slot-header {
  font-size: 14px;
  margin: 20px 0 8px;
  color: var(--muted);
}
.zones {
  display: flex;
  gap: 8px;
  margin-bottom: 14px;
}
.zone {
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 13px;
  background: rgba(59,130,246,0.08);
  color: var(--text);
  
}
.zone.active {
  background:  #1559c5;
  color: #fff;
  cursor:pointer;
}

.slots {
  cursor: pointer;
  display: grid;
  grid-template-columns: repeat(5, 1fr);
  gap: 10px;
}

.slot {
  display: block;     
  background: var(--card-bg);
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 10px;
  text-align: center;
  cursor: pointer;
  font-size: 13px;
}

.slot input {
  display: none;
}

.slot input:checked + span,
.slot.active {
  background: var(--primary);
  color: white;
  border-color: var(--primary);
}


/* Selected Slot */
.selected {
  background: var(--primary-light);
  border-radius: 10px;
  padding: 14px;
  margin-top: 14px;
  display: flex;
  justify-content: space-between;
  font-size: 14px;
}

/* Button */
.btn-main {
  width: 100%;
  margin-top: 22px;
  padding: 14px;
  border: none;
  border-radius: var(--radius);
  background: var(--primary);
  color: #fff;
  font-size: 15px;
  font-weight: 600;
  cursor: pointer;
  box-shadow: 0 6px 14px rgba(59,130,246,0.3);
}
.btn-main:hover {
  opacity: 0.95;
}
.btn-main i {
  margin-right: 6px;
}

/* Empty State */
.empty {
  text-align: center;
  color: var(--muted);
  padding: 40px 0;
}
.empty i {
  font-size: 34px;
  margin-bottom: 10px;
  color: var(--primary);
}

.hidden { display: none; }

.slot.disabled {
  background: #f3f4f6;
  color: #9ca3af;
  border-style: dashed;
  cursor: not-allowed;
  opacity: 0.7;
}

.slot.disabled:hover {
  background: #f3f4f6;
}

.alert.success {
  background: #ecfdf5;
  color: #065f46;
  padding: 12px 16px;
  border-radius: 8px;
  margin-bottom: 16px;
  font-weight: 500;
}


</style>
</head>

<body>

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


<div class="wrapper">

<div class="page-header">
    <div class="icon"><i class="fa-solid fa-arrow-right"></i></div>
    <div>
      <h1>Vehicle Entry</h1>
      <p>Record new vehicle entries</p>
    </div>
  </div>

  <div class="tabs">
    <div id="tab-walkin"
     class="tab ${activeTab ne 'PREBOOK' ? 'active' : ''}"
     onclick="showWalkIn()">
  Walk-in Entry
</div>

<div id="tab-prebook"
     class="tab ${activeTab eq 'PREBOOK' ? 'active' : ''}"
     onclick="showPreBooked()">
  Pre-booked Entry
</div>
    
  </div>

  <!-- WALK-IN -->
  <form id="walkin"
      class="${activeTab eq 'PREBOOK' ? 'hidden' : ''}"
      method="post"
      action="${pageContext.request.contextPath}/vehicleEntry">
  
    <div class="card">
      <h3>Vehicle Details</h3>
      <div class="form-grid">
        <div class="field">
          <label>Vehicle Number *</label>
         <input type="text"
       name="numberPlateWalkIn"
       pattern="[A-Z]{2}[0-9]{2}[A-Z]{1,2}[0-9]{4}"
       title="Format: TN01AB1234"
       required>
         
          
        </div>
        <div class="field">
          <label>Vehicle Type *</label>
         <select name="typeWalkIn" id="vehicleTypeSelect">
		    <option value="CAR">Car</option>
		    <option value="MOTORCYCLE">Motorcycle</option>
		</select>
         
        </div>
        <div class="field">
          <label>Driver Name</label>
         <input type="text" name="userName">
        </div>
        <div class="field">
          <label>Driver Phone</label>
          <input type="text" name="userContact">
          
        </div>
      </div>
    </div>

    <div class="card">
    
      <h3>Select Parking Slot</h3>
     
      <div class="slot-header">${freeSlots.size()}  slots are  available</div>

   <div class="zones">
  <div class="zone active" data-floor="0" onclick="filterFloor(0, this)">
    All Floors (<span class="count" id="count-0">0</span>)
  </div>
  <div class="zone" data-floor="1" onclick="filterFloor(1, this)">
    Floor 1 (<span class="count" id="count-1">0</span>)
  </div>
  <div class="zone" data-floor="2" onclick="filterFloor(2, this)">
    Floor 2 (<span class="count" id="count-2">0</span>)
  </div>
  <div class="zone" data-floor="3" onclick="filterFloor(3, this)">
    Floor 3 (<span class="count" id="count-3">0</span>)
  </div>
  <div class="zone" data-floor="4" onclick="filterFloor(4, this)">
    Floor 4 (<span class="count" id="count-4">0</span>)
  </div>
</div>
   
	      

    <div class="slots">
    
		<c:forEach var="slot" items="${slots}">
		
    <label class="slot ${slot.status ne 'FREE' ? 'disabled' : ''}"
           data-floor="${slot.floor}"
           data-slot-number="${slot.slotNumber}">

        <input type="radio"
               name="slotIdWalkIn"
               value="${slot.slotId}"
               ${slot.status ne 'FREE' ? 'disabled' : ''} />

        <span>
            Slot ${slot.slotNumber}
        </span>
    </label>
</c:forEach>
		
		
		 
    </div>
    
    <div id="noSlotsMsg" class="empty hidden">
	  <i class="fa-solid fa-ban"></i>
	  <p>No slots available on this floor</p>
	</div>
     
      <div class="selected" id="selectedBox" style="display:none;">
		  <div>
		    <strong>Selected Slot</strong><br>
		    <span id="selectedSlot">-</span>
		  </div>
		  <div>
		    <strong>Fee</strong><br>
		    $<span id="selectedFee">-</span>/hr
		  </div>
		</div>
      
      
    </div>

     <button class="btn-main" name="confirmWalkIn">
   
      <i class="fa-solid fa-circle-check"></i> Record Vehicle Entry
    </button>
  </form>
  
  

  <!-- PRE-BOOKED -->
<form id="prebooked"
      class="${activeTab eq 'PREBOOK' ? '' : 'hidden'}"
      method="post"
      action="${pageContext.request.contextPath}/vehicleEntry">

 
    <div class="card">
      <h3>Find Booking</h3>
      <div class="field">
        <label>Search by vehicle number</label>
        <input type="text"
       name="numberPlate"
       placeholder="Enter vehicle number..."
       required>
        <button class="btn-main" name="checkBooking">
      <i class="fa-solid fa-magnifying-glass"></i> Search Booking
       </button>
        
      </div>
      
      
      <c:if test="${not empty singleBooking}">
  <div class="card">
    <h3>Booking Details</h3>

    <p><b>Vehicle:</b> ${singleBooking.vehicleNumber}</p>
    <p><b>Slot ID:</b> ${singleBooking.slotId}</p>
    <p><b>Start:</b> ${singleBooking.startTime}</p>
    <p><b>End:</b> ${singleBooking.endTime}</p>

    <input type="hidden"
           name="numberPlate"
           value="${singleBooking.vehicleNumber}">

    <div class="field">
      <label>Vehicle Type</label>
      <select name="type">
        <option value="CAR">Car</option>
        <option value="MOTORCYCLE">Motorcycle</option>
      </select>
    </div>

    <button class="btn-main" name="confirmPreBooked">
      <i class="fa-solid fa-circle-check"></i>
      Confirm Vehicle Entry
    </button>
  </div>
</c:if>
      
      
    </div>

      
  </form> 

</div>

 <script> 


function showWalkIn() {
	  document.getElementById("walkin").classList.remove("hidden");
	  document.getElementById("prebooked").classList.add("hidden");
	  document.getElementById("tab-walkin").classList.add("active");
	  document.getElementById("tab-prebook").classList.remove("active");

	 
	}


function showPreBooked() 
{ 
	document.getElementById("walkin").classList.add("hidden"); 
	document.getElementById("prebooked").classList.remove("hidden");
	document.getElementById("tab-prebook").classList.add("active"); 
	document.getElementById("tab-walkin").classList.remove("active");
} 

function updateSlotCounts() {
	const counts = { "0": 0 };

	  document.querySelectorAll('.slot:not(.disabled)').forEach(slot => {
	    const floor = slot.dataset.floor;

	    counts[floor] = (counts[floor] || 0) + 1;
	    counts["0"]++;
	  });

	  document.querySelectorAll('.zone').forEach(zone => {
	    const floor = zone.dataset.floor;
	    const span = zone.querySelector('.count');
	    if (span) span.innerText = counts[floor] || 0;
	  });
	}

window.onload = () => {
	  updateSlotCounts();
	  filterFloor(0, document.querySelector(".zone.active"));
	};

	
const vehicleFees = {
		  CAR: 5,
		  MOTORCYCLE: 2
		};

		const selectedSlotSpan = document.getElementById('selectedSlot');
		const selectedFeeSpan = document.getElementById('selectedFee');
		const selectedBox = document.getElementById('selectedBox');
		const vehicleTypeSelect = document.getElementById('vehicleTypeSelect');

		function updateFee() {
		  const selectedRadio = document.querySelector('input[name="slotIdWalkIn"]:checked');
		  if (!selectedRadio) return;

		  const slotLabel = selectedRadio.closest('.slot');
		  const slotNumber = slotLabel.dataset.slotNumber;

		  const vehicleType = vehicleTypeSelect.value;
		  const fee = vehicleFees[vehicleType];

		  selectedSlotSpan.innerText = slotNumber;
		  selectedFeeSpan.innerText = fee;
		  selectedBox.style.display = 'flex';
		}

		// Update fee when slot changes
		document.querySelectorAll('input[name="slotIdWalkIn"]').forEach(radio => {
		  radio.addEventListener('change', updateFee);
		});

		// Update fee when vehicle type changes
		vehicleTypeSelect.addEventListener('change', updateFee);
		
		
		document.querySelectorAll('.slot:not(.disabled)').forEach(slot => {

			  slot.addEventListener('click', () => {
			    if (slot.classList.contains('disabled')) return;

			    document.querySelectorAll('.slot').forEach(s => s.classList.remove('active'));
			    slot.classList.add('active');
			    slot.querySelector('input').checked = true;
			    updateFee();
			  });
			});


		function filterFloor(floor, el) {
			  const slots = document.querySelectorAll(".slot");
			  const zones = document.querySelectorAll(".zone");
			  const noSlotsMsg = document.getElementById("noSlotsMsg");

			  zones.forEach(z => z.classList.remove("active"));
			  el.classList.add("active");

			  let visibleCount = 0;

			  slots.forEach(slot => {
			    const slotFloor = Number(slot.dataset.floor);
			    const radio = slot.querySelector("input");

			    if (floor === 0 || slotFloor === floor) {
			      slot.style.display = "block";
			      visibleCount++;
			    } else {
			      slot.style.display = "none";
			      radio.checked = false;
			      slot.classList.remove("active");
			    }
			  });

			  noSlotsMsg.classList.toggle("hidden", visibleCount > 0);
			  document.getElementById("selectedBox").style.display = "none";
			}


</script>

</body>
</html>
