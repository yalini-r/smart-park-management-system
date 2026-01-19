<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.smartpark.dto.User" %>
<%@ page import="com.smartpark.dao.UserDAO" %>
<%@ page import="java.util.List" %>

<%
User admin = (User) session.getAttribute("user");
if (admin == null) {
    session.invalidate();
    response.sendRedirect("../auth/login.jsp");
    return;
}

UserDAO userDAO = new UserDAO();
List<User> userList = userDAO.getAllUsers();
request.setAttribute("users", userList);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Management</title>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

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

/* STATS */
.stats {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
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


/* TABLE */
.table-card {
    background: #fff;
    border-radius: 14px;
    box-shadow: 0 6px 18px rgba(0,0,0,.06);
    overflow: hidden;
}
table {
    width: 100%;
    border-collapse: collapse;
}
th {
    background: #f9fafb;
    text-align: left;
    padding: 14px;
    font-size: 13px;
    color: #6b7280;
}
td {
    padding: 14px;
    border-top: 1px solid #f1f5f9;
    vertical-align: middle;
}
.user-cell {
    display: flex;
    align-items: center;
    gap: 12px;
}
.avatar {
    width: 38px;
    height: 38px;
    border-radius: 50%;
    background: #6366f1;
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 600;
}


/* ================= EDIT USER MODAL ================= */

.modal-bg {
    position: fixed;
    inset: 0;
    background: rgba(15, 23, 42, 0.45);
    display: none;
    justify-content: center;
    align-items: center;
    z-index: 1000;
}

.modal {
    background: #ffffff;
    width: 420px;
    border-radius: 16px;
    padding: 26px 28px;
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
    margin-bottom: 20px;
    font-size: 20px;
    font-weight: 700;
    color: #0f172a;
}

/* FORM LAYOUT */
.modal form {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

/* FIELD GROUP */
.form-group {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

.modal label {
    font-size: 13px;
    font-weight: 600;
    color: #475569;
}

.modal input,
.modal select {
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

/* FOOTER BUTTONS */
.modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
    margin-top: 22px;
}

.modal-footer .btn {
    min-width: 90px;
    padding: 10px 18px;
    border-radius: 10px;
    font-weight: 600;
    cursor: pointer;
    border: none;
    font-size: 14px;
}

.modal-footer .cancel {
    background: #e5e7eb;
    color: #334155;
}

.modal-footer .cancel:hover {
    background: #d1d5db;
}

.modal-footer .save {
    background: #4f46e5;
    color: #ffffff;
}

.modal-footer .save:hover {
    background: #4338ca;
}

/* ================= STATUS BADGE ================= */

.badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 4px 12px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 0.4px;
    text-transform: uppercase;
}

.badge.active {
    background: #e7f8ec;
    color: #108b32;
}

.badge.blocked {
    background: #fee2e2;
    color: #b91c1c;
}

/* ================= ACTIONS ================= */

.actions {
    display: flex;
    align-items: center;
    gap: 14px;
}

.actions i {
    font-size: 14px;
    padding: 8px;
    border-radius: 8px;
    cursor: pointer;
    transition: all 0.2s ease;
}

/* Edit */
.actions .fa-pen {
    background: #eef2ff;
    color: #4f46e5;
}

.actions .fa-pen:hover {
    background: #4f46e5;
    color: #ffffff;
}

/* Block */
.actions .fa-lock {
    background: #fee2e2;
    color: #b91c1c;
}

.actions .fa-lock:hover {
    background: #b91c1c;
    color: #ffffff;
}

/* Unblock */
.actions .fa-unlock {
    background: #e7f8ec;
    color: #108b32;
}

.actions .fa-unlock:hover {
    background: #108b32;
    color: #ffffff;
}

/* Remove default link styling inside actions */
.actions a {
    text-decoration: none;
}
td:nth-child(4),
td:nth-child(5) {
    vertical-align: middle;
}


 .divider { 
 border:none; 
 border-top:2px solid #ddd; 
 margin:20px 0; 
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


<div class="main"> 


<div class="page-title">User Management</div>
<div class="page-subtitle">Manage and monitor all system users</div>

<!-- STATS -->


<div class="stats">

    <div class="stat-card active" data-filter="all" onclick="filterSlots('all')">
        <div class ="stat-left">
            <h3>Total Users</h3>
            <div class="stat-value">${users.size()}</div>
        </div>
        <div class="stat-icon blue"><i class="fa fa-users"></i></div>
    </div>
 
    <div class="stat-card " data-filter="active" onclick="filterSlots('active')">
        <div class="stat-left">
            <h3>Active</h3>
            <div class="stat-value">
            <c:set var="a" value="0"/> 
            <c:forEach items="${users}" var="u"> 
            <c:if test="${u.status=='ACTIVE'}">
            <c:set var="a" value="${a+1}"/></c:if> 
            </c:forEach> ${a}
            
            </div>
        </div>
        <div class="stat-icon green"><i class="fa fa-user-check"></i></div>
    </div>

    <div class="stat-card " data-filter="blocked" onclick="filterSlots('blocked')">
        <div class="stat-left">
            <h3>Blocked</h3>
            <div class="stat-value">
              <c:set var="b" value="0"/> 
              <c:forEach items="${users}" var="u">
               <c:if test="${u.status=='BLOCKED'}">
               <c:set var="b" value="${b+1}"/></c:if> 
               </c:forEach> ${b}
            </div>
        </div>
        <div class="stat-icon red"><i class="fa fa-user-slash"></i></div>
    </div>
    
</div>

<hr class="divider">
<!-- TABLE -->
<div class="table-card">
<table>
    <thead>
        <tr>
            <th>User</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
    <c:forEach items="${users}" var="u">
        <tr class="user-row" data-status="${u.status}">
            <td>
                <div class="user-cell">
                    <div class="avatar">${u.name.substring(0,1)}</div>
                    ${u.name}
                </div>
            </td>
            <td>${u.email}</td>
            <td>${u.phone}</td>
            <td>
                <span class="badge ${u.status=='ACTIVE'?'active':'blocked'}">${u.status}</span>
            </td>
            <td class="actions">
                <i class="fa fa-pen"
                   onclick="openEdit('${u.id}','${u.name}','${u.email}','${u.phone}','${u.status}')"></i>

                <c:if test="${u.status=='ACTIVE'}">
                    <a href="${pageContext.request.contextPath}/admin/manageUsers?action=block&userId=${u.id}">
                        <i class="fa fa-lock"></i>
                    </a>
                </c:if>
                <c:if test="${u.status=='BLOCKED'}">
                    <a href="${pageContext.request.contextPath}/admin/manageUsers?action=unblock&userId=${u.id}">
                        <i class="fa fa-unlock"></i>
                    </a>
                </c:if>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</div>

<!-- EDIT MODAL -->
<div class="modal-bg" id="editModal">
    <div class="modal">
        <h2>Edit User</h2>
       <form action="${pageContext.request.contextPath}/admin/manageUsers" method="post">

    <input type="hidden" name="action" value="update">
    <input type="hidden" name="userId" id="eid">

    <div class="form-group">
        <label>Name</label>
        <input type="text" name="name" id="ename" required>
    </div>

    <div class="form-group">
        <label>Email</label>
        <input type="email" name="email" id="eemail" required>
    </div>

    <div class="form-group">
        <label>Phone Number</label>
        <input type="text" name="phone" id="ephone" required>
    </div>

    <div class="form-group">
        <label>Status</label>
        <select name="status" id="estatus">
            <option value="ACTIVE">Active</option>
            <option value="BLOCKED">Blocked</option>
        </select>
    </div>

    <div class="modal-footer">
        <button type="button" class="btn cancel" onclick="closeEdit()">Cancel</button>
        <button type="submit" class="btn save">Save</button>
    </div>

</form>
       
    </div>
</div>

 </div>
<script>
function openEdit(id,n,e,p,s){
    eid.value=id; ename.value=n; eemail.value=e; ephone.value=p; estatus.value=s;
    editModal.style.display='flex';
}
function closeEdit(){
    editModal.style.display='none';
}


function filterSlots(filter) {

    const rows = document.querySelectorAll('.user-row');

    rows.forEach(row => {
        const status = row.dataset.status.toLowerCase();

        if (filter === 'all') {
            row.style.display = '';
        } 
        else if (filter === 'active' && status === 'active') {
            row.style.display = '';
        } 
        else if (filter === 'blocked' && status === 'blocked') {
            row.style.display = '';
        } 
        else {
            row.style.display = 'none';
        }
    });

    // Highlight active stat card
    document.querySelectorAll('.stat-card').forEach(card => {
        card.classList.toggle('active', card.dataset.filter === filter);
    });
}


</script>

</body>
</html>
