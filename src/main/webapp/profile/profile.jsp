<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartpark.dto.User" %>

<%
    User u = (User) session.getAttribute("user");
    if (u == null) { 
        session.invalidate(); 
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
    
    String role = u.getRole();
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Profile</title>

<link rel="stylesheet" 
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">


<style>

:root {
  --primary: #3b82f6;
  --primary-hover: #2563eb;
  --sidebar-bg: #ffffff;
  --page-bg: #f8fafc;
  --text-dark: #0f172a;
  --text-light: #64748b;
  --card-bg: #ffffff;
  --border: #e2e8f0;
  --radius: 14px;
  --shadow: 0 4px 25px rgba(15, 23, 42, 0.08);
}

   * { box-sizing: border-box; }

        html, body {
         margin: 0;
	    padding: 0;
	    background: #f4f6f9;
	    font-family: Arial, sans-serif;
          height: 100%;
		 
		  font-family: Inter, system-ui, -apple-system, "Segoe UI", Roboto, Helvetica,
		    Arial, sans-serif;
		 
		  color: #1f2937;
            
        }


/* SIDEBAR */
        
       
    .sidebar > div {
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
        padding: 20px 10px;
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
          margin-top:10px;
        margin-bottom: 10px;
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
    margin-top: auto;
}
   
/* ------------------- MAIN AREA ------------------- */
.main {
  padding: 40px;
  margin-left: 500px;
}

.page-title {
  font-size: 28px;
  font-weight: 700;
  color: var(--text-dark);
}

.page-subtitle {
  margin-top: 5px;
  font-size: 14px;
  color: var(--text-light);
}

/* ------------------- PROFILE HEADER ------------------- */

.profile-top-card {
  margin-top: 25px;
  background: var(--card-bg);
  padding: 25px;
  border-radius: var(--radius);
  box-shadow: var(--shadow);
  display: flex;
  align-items: center;
  gap: 20px;
  width: 600px;
}

.avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: linear-gradient(to right, #6366f1, #7c3aed);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 32px;
  color: white;
  font-weight: 700;
}

.card {
  background: var(--card-bg);
  width: 600px;
  padding: 25px;
  margin-top: 25px;
  border-radius: var(--radius);
  box-shadow: var(--shadow);
}

.card h4 {
  margin: 0 0 15px;
  color: var(--text-dark);
  font-size: 18px;
  font-weight: 600;
}

.p-info p{

  color: #81839a;
  font-size:14px;
}

/* ------------------- FIELD / VIEW / EDIT ------------------- */

label {
  font-size: 10px;
  color: #81839a;
  font-weight: 600;
}

.field {
  margin-bottom: 18px;
}

.field-view {
  margin-top: 5px;
  background: #f7f8fb;
  padding: 13px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  gap: 12px;
  border: 1px solid #e4e6ee;
}

.field-icon {
  font-size: 12px;
  color: #a6a8b3;
}

.edit-icon {
  margin-left: auto;
  opacity: 0;
  cursor: pointer;
  color: #a6a8b3;
  transition: 0.2s;
}

.field-view:hover .edit-icon {
  opacity: 1;
}

.field-edit {
  margin-top: 5px;
  background: #f7f8fb;
  padding: 13px;
  border-radius: 12px;
  display: none;
 
  gap: 10px;
  border: 1px solid #e4e6ee;
}

.field-edit input {
  width: 90%;
  padding: 10px;
  border-radius: 10px;
  border: 1px solid #d6d8e1;
}

button.save,
button.cancel {
  padding: 8px 12px;
  border: none;
  border-radius: 10px;
  cursor: pointer;
}

button.save {
  background: #0a0f24;
  color: white;
}

button.cancel {
  background: #d9534f;
  color: white;
}

.toggle-pass {
  position: absolute;
  right: 60px;
  top: 10px;
  cursor: pointer;
  color: #a6a8b3;
}

.save-btn {
  width: 100%;
  padding: 12px;
  background: var(--primary);
  color: white;
  border-radius: 10px;
  font-weight: 600;
  border: none;
  cursor: pointer;
}

.save-btn:hover {
  background: var(--primary-hover);
}

</style>
</head>
<body>


<%
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>

<script>
  <% if (msg != null) { %>
    alert("<%= msg %>");
  <% } %>
  <% if (error != null) { %>
    alert("<%= error %>");
  <% } %>
</script>



<% if ("user".equals(role)) { %>

<!-- ================= USER SIDEBAR ================= -->
<div class="sidebar">
  <div>

    <div id="logo">
      <i class="fa-solid fa-car"></i>
      <div>
        <h2>ParkEase</h2>
        <p id="small-text">Pre-Booking System</p>
      </div>
    </div>
    

    <div >
      <a href="<%= request.getContextPath() %>/user/userDashboard.jsp">
        <i class="fa-solid fa-gauge"></i> Dashboard
      </a>
      <a href="<%= request.getContextPath() %>/user/booking-page">
        <i class="fa-solid fa-ticket"></i> Book Slot
      </a>
      <a href="<%= request.getContextPath() %>/user/view-bookings">
        <i class="fa-solid fa-list-check"></i> My Bookings
      </a>
    </div>

    <div class="bottom-links">
      <a href="<%= request.getContextPath() %>/profile/profile.jsp">
        <i class="fa-solid fa-user"></i> Profile
      </a>
      <a href="<%= request.getContextPath() %>/logout">
        <i class="fa-solid fa-right-from-bracket"></i> Logout
      </a>
    </div>

  </div>
</div>

<% } else if ("admin".equals(role)) { %>

<!-- ================= ADMIN SIDEBAR ================= -->
<div class="sidebar">
  <div>

    <div id="logo">
      <h2>Admin Panel</h2>
    </div>

  <div>
      <a href="<%= request.getContextPath() %>/admin/adminDashboard.jsp">
      <i class="fa-solid fa-gauge"></i>
      <span>Dashboard</span>
    </a>

    <a href="<%= request.getContextPath() %>/admin/manageSlots.jsp">
      <i class="fa-solid fa-square-parking"></i>
      <span>Manage Slots</span>
    </a>

    <a href="<%= request.getContextPath() %>/admin/manageUsers.jsp">
      <i class="fa-solid fa-users"></i>
      <span>Manage Users</span>
    </a>

    <a href="<%= request.getContextPath() %>/viewBookings">
      <i class="fa-solid fa-list-check"></i>
      <span>View Bookings</span>
    </a>

    <a href="<%= request.getContextPath() %>/admin/vehicleEntry.jsp">
      <i class="fa-solid fa-car-side"></i>
      <span>Vehicle Entry</span>
    </a>

    <a href="<%= request.getContextPath() %>/admin/vehicleExit.jsp">
      <i class="fa-solid fa-arrow-right-from-bracket"></i>
      <span>Vehicle Exit</span>
    </a>
  </div>
   

    <div class="bottom-links">
      <a href="<%= request.getContextPath() %>/profile/profile.jsp">
        <i class="fa-solid fa-user"></i>
        <span>Profile</span>
      </a>

      <a href="<%= request.getContextPath() %>/logout">
        <i class="fa-solid fa-right-from-bracket"></i>
        <span>Logout</span>
      </a>
    </div>

  </div>
</div>

<% } %>


<div class="main">

  <div class="page-title">Profile Settings</div>
  <div class="page-subtitle">Manage your account information</div>

  <!-- TOP PROFILE CARD -->
  <div class="profile-top-card">
    <div class="avatar"><%= u.getName().substring(0,1).toUpperCase() %></div>
    <div class="p-info">
      <h3><%= u.getName() %></h3>
      <p><%= u.getEmail() %></p>
    </div>
  </div>

    <!-- PERSONAL INFORMATION CARD -->
<div class="card">
  <h4>Personal Information</h4>

  <form action="${pageContext.request.contextPath}/updateProfile" method="post">

    <!-- FULL NAME -->
    <div class="field" data-key="name">
      <label>FULL NAME</label>

      <!-- VIEW MODE -->
      <div class="field-view">
        <i class="fa-solid fa-user field-icon"></i>
        <span class="value"><%= u.getName() %></span>
        <i class="fa-solid fa-pen edit-icon"></i>
      </div>

      <!-- EDIT MODE -->
      <div class="field-edit">
        <input type="text" name="name" value="<%= u.getName() %>" required>
        <button type="submit" class="save"><i class="fa-solid fa-check"></i></button>
        <button type="button" class="cancel"><i class="fa-solid fa-xmark"></i></button>
      </div>
    </div>

    <!-- EMAIL (READ ONLY) -->
    <div class="field">
      <label>EMAIL ADDRESS</label>
      <div class="field-view">
        <i class="fa-solid fa-envelope field-icon"></i>
        <span class="value"><%= u.getEmail() %></span>
      </div>
    </div>

    <!-- PHONE -->
    <div class="field" data-key="phone">
      <label>PHONE</label>

      <!-- VIEW MODE -->
      <div class="field-view">
        <i class="fa-solid fa-phone field-icon"></i>
        <span class="value"><%= u.getPhone() == null ? "Not set" : u.getPhone() %></span>
        <i class="fa-solid fa-pen edit-icon"></i>
      </div>

      <!-- EDIT MODE -->
      <div class="field-edit">
        <input type="text" name="phone"
               value="<%= u.getPhone() == null ? "" : u.getPhone() %>">
        <button type="submit" class="save"><i class="fa-solid fa-check"></i></button>
        <button type="button" class="cancel"><i class="fa-solid fa-xmark"></i></button>
      </div>
    </div>

  </form>
</div>
    

     <!-- PASSWORD CARD -->
<div class="card">
  <h4>Password</h4>

  <div class="field" data-key="password">
    <label>PASSWORD</label>

    <div class="field-view">
      <i class="fa-solid fa-lock field-icon"></i>
      <span class="value">••••••••</span>
      <i class="fa-solid fa-pen edit-icon"></i>
    </div>

    <!-- FORM FOR CHANGE PASSWORD -->
    <form class="field-edit" 
          style="flex-direction: column; gap: 10px; display:none;"
          method="post"
          action="${pageContext.request.contextPath}/changePassword">

      <!-- OLD PASSWORD -->
      <div style="position: relative;">
        <input type="password" name="oldPwd" id="oldPwd" placeholder="Current Password" required>
        <i class="fa-solid fa-eye toggle-pass" onclick="togglePass('oldPwd', this)"></i>
      </div>

      <!-- NEW PASSWORD -->
      <div style="position: relative;">
        <input type="password" name="newPwd" id="newPwd" placeholder="New Password" required>
        <i class="fa-solid fa-eye toggle-pass" onclick="togglePass('newPwd', this)"></i>
      </div>

      <!-- CONFIRM PASSWORD -->
      <div style="position: relative;">
        <input type="password" name="confirmPwd" id="confirmPwd" placeholder="Confirm Password" required>
        <i class="fa-solid fa-eye toggle-pass" onclick="togglePass('confirmPwd', this)"></i>
      </div>

      <div style="display: flex; gap: 10px;">
        <button type="submit" class="save"><i class="fa-solid fa-check"></i></button>
        <button type="button" class="cancel"><i class="fa-solid fa-xmark"></i></button>
      </div>

    </form>

  </div>
</div>
     
</div>

<script>


	
	
	// Toggle password view
function togglePass(fieldId, icon) {
    const input = document.getElementById(fieldId);

    if (input.type === "password") {
        input.type = "text";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    } else {
        input.type = "password";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    }
}

//Toggle password view
function togglePass(fieldId, icon) {
    const input = document.getElementById(fieldId);

    if (input.type === "password") {
        input.type = "text";
        icon.classList.remove("fa-eye");
        icon.classList.add("fa-eye-slash");
    } else {
        input.type = "password";
        icon.classList.remove("fa-eye-slash");
        icon.classList.add("fa-eye");
    }
}

// Handle edit/cancel for fields
document.querySelectorAll(".field").forEach((field) => {

    let view = field.querySelector(".field-view");
    let edit = field.querySelector(".field-edit");

    let pen = field.querySelector(".edit-icon");
    if (pen) {
        pen.onclick = () => {
            view.style.display = "none";
            edit.style.display = "flex";
        };
    }

    let cancel = field.querySelector(".cancel");
    if (cancel) {
        cancel.onclick = () => {
            edit.style.display = "none";
            view.style.display = "flex";
        };
    }
});



</script>

</body>
</html>
