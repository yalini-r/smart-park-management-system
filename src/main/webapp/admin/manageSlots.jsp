<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.smartpark.dto.ParkingSlot" %>
<%@ page import="com.smartpark.dao.ParkingSlotDAO" %>

<%
ParkingSlotDAO dao = new ParkingSlotDAO();
List<ParkingSlot> slots = dao.getAllSlots();

int total = 0;
int free = 0;
int reserved = 0;
int occupied = 0;

for(ParkingSlot s : slots){
    total++;
    if(s.getStatus().name().equals("FREE")) free++;
    else if(s.getStatus().name().equals("RESERVED")) reserved++;
    else if(s.getStatus().name().equals("OCCUPIED")) occupied++;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Manage Parking Slots</title>

<!-- FONT AWESOME -->
<link rel="stylesheet"
 href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

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
    padding:30px 34px;
}

/* HEADER */
.page-header {
    display:flex;
    justify-content:space-between;
    align-items:center;
}
.page-header h1 {
    margin:0;
    font-size:26px;
}
.page-header p {
    margin:6px 0 0;
    color:#6b7280;
}

/* ADD BUTTON */

 .top-right-add {
  position:fixed; 
  top:18px;
  right:18px; 
  z-index:999;
 }
.add-btn {
    background:#1559c5; 
    color:white; 
    padding:12px 18px;
    border-radius:12px; 
    border:none; 
    cursor:pointer;
    font-weight:700; 
    display:flex;
    gap:8px; 
    align-items:center;
    box-shadow:0 6px 18px rgba(21,89,197,0.18);
}
/* STATS */
.stats-grid {
    display:grid;
    grid-template-columns:repeat(4,1fr);
    gap:18px;
    margin:28px 0 36px;
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

     
/* ICON CIRCLES */
.stat-icon {
    width:42px;
    height:42px;
    border-radius:50%;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:16px;
}


.icon-total {  background:#e5f0ff; color:#1559c5;}
.icon-free { background:#e7f8ec; color:#108b32; }
.icon-reserved {background:#fff8dd; color:#b38a00; }
.icon-occupied {background:#ffe7e7; color:#c62828; }


 .divider { 
 border:none; 
 border-top:2px solid #ddd; 
 margin:20px 0; 
 }
 
/* FLOOR HEADER */
.floor-header {
    margin:36px 0 14px;
    display:flex;
    justify-content:flex-start;
    align-items:center;
    gap:20px;
    align-items:center;
}
.floor-title {
    display:flex;
    align-items:center;
    gap:10px;
    font-size:15px;
    font-weight:500;
}
.floor-count {
    
    font-size:10px;
    color:#6b7280;
    background:#f8fafc;
    padding:5px 10px;
    border-radius:25px;
    
}

/* GRID */
.grid {
    display:grid;
    grid-template-columns:repeat(auto-fill,minmax(260px,1fr));
    gap:18px;
}

/* SLOT CARD */
.slot-card {
    position:relative;
    background:#fff;
    padding:16px 18px;
    border-radius:14px;
    border:1px solid #e5e7eb;
    transition:.2s ease;
}
.slot-card:hover {
  
    box-shadow:0 14px 28px rgba(0,0,0,.10);
}

/* CARD CONTENT */
.slot-top {
    display:flex;
    justify-content:space-between;
    align-items:flex-start;
}

.slot-left {
    display:flex;
    gap:14px;
}

/* ICON */
.slot-icon {
    width:44px;
    height:44px;
    border-radius:12px;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:18px;
    background:#f0f6ff;
}

/* TITLE + STATUS */
.slot-title-row {
    display:flex;
    align-items:center;
    gap:8px;
}
.slot-title {
    font-size:14px;
    font-weight:600;
}

.status-badge {
    padding:3px 8px;
    border-radius:6px;
    font-size:12px;
    text-transform:capitalize;
}

/* STATUS COLORS (unchanged) */
.status-free { background:#e7f8ec; }
.status-reserved { background:#fff8dd; }
.status-occupied { background:#ffe7e7; }

/* FLOOR TEXT */
.slot-floor {
    margin-top:4px;
    font-size:13px;
    color:#6b7280;
}

/* MENU BUTTON */
.dots-btn {
    background:none;
    border:none;
    font-size:16px;
    cursor:pointer;
    opacity:0;
}
.slot-card:hover .dots-btn {
    opacity:1;
}

/* MENU */
.menu-box {
    position:absolute;
    top:40px;
    right:14px;
    background:#fff;
    border:1px solid #e5e7eb;
    border-radius:12px;
    width:130px;
    display:none;
    flex-direction:column;
    box-shadow:0 14px 28px rgba(0,0,0,.15);
    z-index:100;
}
.menu-item {
    padding:10px 14px;
    font-size:14px;
    cursor:pointer;
    display:flex;
    gap:8px;
    align-items:center;
}
.menu-item:hover {
    background:#f4f6fa;
}
.menu-item.delete {
    color:#dc2626;
}

/* form add and edit*/

.modal-bg {
    position: fixed;
    inset: 0;
    background: rgba(15, 23, 42, 0.45);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 2000;
}


.modal {
    background: #ffffff;
    width: 420px;
    border-radius: 16px;
    padding: 24px 26px;
    box-shadow: 0 30px 60px rgba(0, 0, 0, 0.25);
    animation: modalFade 0.25s ease;
}

@keyframes modalFade {
    from {
        opacity: 0;
        transform: translateY(12px) scale(0.98);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}


.modal h2 {
    margin: 0 0 18px;
    font-size: 20px;
    font-weight: 700;
    color: #0f172a;
}


.modal form {
    display: flex;
    flex-direction: column;
    gap: 14px;
}

.modal label {
    font-size: 13px;
    font-weight: 600;
    color: #475569;
}


.modal input,
.modal select {
    width: 100%;
    height: 44px;
    padding: 0 12px;
    border-radius: 10px;
    border: 1px solid #cbd5e1;
    font-size: 14px;
    outline: none;
    transition: 0.2s ease;
}

.modal input:focus,
.modal select:focus {
    border-color: #1559c5;
    box-shadow: 0 0 0 3px rgba(21, 89, 197, 0.15);
}


.modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    margin-top: 22px;
}

/* Cancel */
.modal-footer button[type="button"] {
    background: #f1f5f9;
    color: #334155;
    border: none;
    padding: 10px 18px;
    border-radius: 10px;
    font-weight: 600;
    cursor: pointer;
}

.modal-footer button[type="button"]:hover {
    background: #e2e8f0;
}

/* Primary (Add / Update) */
.modal-footer .add-btn {
    background: #1559c5;
    color: #ffffff;
    border: none;
    padding: 10px 22px;
    border-radius: 10px;
    font-weight: 700;
    cursor: pointer;
}

.modal-footer .add-btn:hover {
    background: #0f4bb3;
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


<main class="main">

<div class="page-header">
    <div>
        <h1 >Manage Parking Slots</h1>
        <p >Manage and organize your parking facility</p>
    </div>
    
    <div class="top-right-add">
    <button class="add-btn" onclick="openAddModal()"><i class="fas fa-plus"></i> Add Slot</button>
    </div>
   
</div>

<div class="stats-grid">

    <div class="stat-card active" data-filter="all"  onclick="filterSlots('all')">
        <div class="stat-left" >
            <h3>Total Slots</h3>
            <div class="stat-value"><%=total%></div>
        </div>
        <div class="stat-icon icon-total">
            <i class="fa-solid fa-square-parking"></i>
        </div>
    </div>

    <div class="stat-card" data-filter="free" onclick="filterSlots('free')" >
        <div class="stat-left"  >
            <h3>Available</h3>
            <div class="stat-value"><%=free%></div>
        </div>
        <div class="stat-icon icon-free">
            <i class="fa-solid fa-circle-check"></i>
        </div>
    </div>

    <div class="stat-card" data-filter="reserved" onclick="filterSlots('reserved')">
        <div class="stat-left" >
            <h3>Reserved</h3>
            <div class="stat-value"><%=reserved%></div>
        </div>
        <div class="stat-icon icon-reserved">
            <i class="fa-solid fa-clock"></i>
        </div>
    </div>

    <div class="stat-card" data-filter="occupied" onclick="filterSlots('occupied')">
        <div class="stat-left" >
            <h3>Occupied</h3>
            <div class="stat-value"><%=occupied%></div>
        </div>
        <div class="stat-icon icon-occupied">
            <i class="fa-solid fa-car-side"></i>
        </div>
    </div>

</div>


<hr class="divider">
<%
for(int floor=1; floor<=4; floor++){
    int count = 0;
    boolean hasSlot=false;
    for(ParkingSlot s: slots){
        if(s.getFloor()==floor){ count++; }
    }
%>

<div class="floor-header">
    <div class="floor-title">
        <i class="fa-solid fa-layer-group"></i>
        Floor <%=floor%>
    </div>
    <div class="floor-count"><%=count%> slots</div>
</div>

<div class="grid">
<%

for(ParkingSlot s: slots){
    if(s.getFloor()==floor){
        hasSlot=true;
        String stLower = s.getStatus().name().toLowerCase();
%>

<div class="slot-card" data-status="<%= stLower %>" id="slot-<%= s.getSlotId() %>">
    <div class="slot-top">

        <div class="slot-left">
            <div class="slot-icon">
                <i class="fa-solid fa-car"></i>
            </div>

            <div>
                <div class="slot-title-row">
                    <div class="slot-title"><%=s.getSlotNumber()%></div>
                    <span class="status-badge status-<%=stLower%>"><%=stLower%></span>
                </div>
                <div class="slot-floor">Floor <%=s.getFloor()%></div>
            </div>
        </div>

        <button class="dots-btn"
        onclick="toggleMenu('<%=s.getSlotId()%>', event)">
        
            <i class="fa-solid fa-ellipsis-vertical"></i>
        </button>

        <div class="menu-box" id="menu-<%=s.getSlotId()%>">
            <div class="menu-item"  onclick="openEditModal('<%= s.getSlotId() %>',
                                            '<%= s.getSlotNumber() %>',
                                            '<%= s.getFloor() %>',
                                            '<%= s.getStatus().name() %>')">
                <i class="fa-solid fa-pen"></i> Edit 
            </div>
            <div class="menu-item delete" onclick="deleteSlot(<%= s.getSlotId() %>)">
                <i class="fa-solid fa-trash"></i> Delete
            </div>
        </div>

    </div>
</div>

<%
}} if(!hasSlot){
%>
<p style="color:#777;font-style:italic;">No slots on this floor</p>
<% } %>
</div>

<% } %>


<!-- ADD SLOT MODAL -->
<div class="modal-bg" id="modalAdd">
    <div class="modal">
        <h2>Add Parking Slot</h2>

        <form action="${pageContext.request.contextPath}/addSlot" method="post">

            <label>Slot Number</label>
            <input type="text" name="slotNumber" placeholder="Ex: A12" required>

            <label>Floor</label>
            <input type="number" name="floor" placeholder="Ex: 1" required>

            <label>Status</label>
            <select name="status">
                <option value="FREE">Free</option>
                <option value="RESERVED">Reserved</option>
                <option value="OCCUPIED">Occupied</option>
            </select>

            <div class="modal-footer">
                <button type="button" onclick="closeAddModal()">Cancel</button>
                <button type="submit" class="add-btn">Add Slot</button>
            </div>
        </form>
    </div>
</div>


<!-- EDIT SLOT MODAL -->
<div class="modal-bg" id="modalEdit">
    <div class="modal">
        <h2>Edit Parking Slot</h2>

        <form action="${pageContext.request.contextPath}/updateSlot" method="post">

            <input type="hidden" name="slotId" id="editSlotId">

            <label>Slot Number</label>
            <input type="text" name="slotNumber" id="editSlotNumber">

            <label>Floor</label>
            <input type="number" name="floor" id="editFloor">

            <label>Status</label>
            <select name="status" id="editStatus">
                <option value="FREE">Free</option>
                <option value="RESERVED">Reserved</option>
                <option value="OCCUPIED">Occupied</option>
            </select>

            <div class="modal-footer">
                <button type="button" onclick="closeEditModal()">Cancel</button>
                <button type="submit" class="add-btn">Update</button>
            </div>
        </form>
    </div>
</div>



</main>


<script>
/* ===========================
   FILTER SLOTS
=========================== */
function filterSlots(filter) {
    const cards = document.querySelectorAll(".slot-card");

    cards.forEach(card => {
        const status = card.dataset.status;
        card.style.display =
            (filter === "all" || filter === status) ? "" : "none";
    });

    document.querySelectorAll(".stat-card").forEach(sc => {
        sc.classList.toggle("active", sc.dataset.filter === filter);
    });
}

/* ===========================
   ADD SLOT MODAL
=========================== */
function openAddModal() {
    document.getElementById("modalAdd").style.display = "flex";
}

function closeAddModal() {
    document.getElementById("modalAdd").style.display = "none";
}

/* ===========================
   EDIT SLOT MODAL
=========================== */
function openEditModal(id, num, floor, status) {
    document.getElementById("editSlotId").value = id;
    document.getElementById("editSlotNumber").value = num;
    document.getElementById("editFloor").value = floor;
    document.getElementById("editStatus").value = status.toUpperCase();
    document.getElementById("modalEdit").style.display = "flex";

    closeAllMenus();
}

function closeEditModal() {
    document.getElementById("modalEdit").style.display = "none";
}

/* ===========================
   DELETE SLOT
=========================== */
function deleteSlot(id) {
    closeAllMenus();

    if (confirm("Delete this slot?")) {
        window.location =
            "${pageContext.request.contextPath}/deleteSlot?slotId=" + id;
    }
}

/* ===========================
   THREE DOT MENU
=========================== */
function toggleMenu(id, event) {
    event.stopPropagation();

    const menu = document.getElementById("menu-" + id);

    document.querySelectorAll(".menu-box").forEach(m => {
        if (m !== menu) m.style.display = "none";
    });

    menu.style.display =
        (menu.style.display === "flex") ? "none" : "flex";
}

function closeAllMenus() {
    document.querySelectorAll(".menu-box")
        .forEach(menu => menu.style.display = "none");
}

/* ===========================
   GLOBAL CLICK HANDLING
=========================== */
document.addEventListener("click", e => {
    if (!e.target.closest(".dots-btn") &&
        !e.target.closest(".menu-box")) {
        closeAllMenus();
    }
});

/* ===========================
   INITIAL LOAD
=========================== */
document.addEventListener("DOMContentLoaded", () => {
    filterSlots("all");

    document.querySelectorAll(".menu-box").forEach(menu => {
        menu.addEventListener("click", e => e.stopPropagation());
    });
});
</script>

</body>
</html>
