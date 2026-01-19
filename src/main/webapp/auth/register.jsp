<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>

<!-- Font Awesome Icons -->
   <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

<style>
    body {
        margin: 0;
        padding: 0;
        font-family: "Poppins", sans-serif;
        background: #f4f6fa;
        height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .container {
        width: 380px;
        background: #ffffff;
        padding: 40px 35px;
        border-radius: 20px;
        box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
        text-align: left;
    }

    .icon-box {
        width: 55px;
        height: 55px;
        background: linear-gradient(to right, #6366f1, #7c3aed);
        color: white;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 15px;
        font-size: 22px;
    }

    h2 {
        text-align: center;
        font-size: 25px;
        margin-bottom: 5px;
    }

    p.subtitle {
        text-align: center;
        color: #6b7280;
        font-size: 14px;
        margin-bottom: 25px;
    }

    label {
        display: block;
        margin-bottom: 6px;
        font-size: 14px;
        font-weight: 500;
        color: #374151;
    }

    .input-group {
        position: relative;
        margin-bottom: 18px;
    }

    .input-group i {
        position: absolute;
        left: 12px;
        top: 50%;
        transform: translateY(-50%);
        color: #9ca3af;
    }

    .input-group input {
        width: 85%;
        padding: 12px 12px 12px 38px;
        font-size: 14px;
        border: 1px solid #e5e7eb;
        border-radius: 8px;
        background: #f9fafb;
        outline: none;
        transition: 0.2s;
    }

    .input-group input:focus {
        background: #fff;
        border-color:#6366f1;
    }

    .btn {
        width: 100%;
        background: linear-gradient(to right, #6366f1, #7c3aed);
        padding: 12px;
        border: none;
        border-radius: 8px;
        color: white;
        font-size: 16px;
        cursor: pointer;
        margin-top: 10px;
    }

    .login-text {
        text-align: center;
        margin-top: 15px;
        font-size: 14px;
        color: #6b7280;
    }

    .login-text a {
        color: #7c3aed;
        text-decoration: none;
        font-weight: 500;
    }

    .footer-text {
        text-align: center;
        margin-top: 18px;
        font-size: 11px;
        color: #9ca3af;
    }
    
    .error{
    
       color:red;
       font-size:12px;
       text-align: center;
       margin: 10px 0px;
    }
    
    .password-field {
    position: relative;
}

.eye-icon {
    position: absolute;
    right: 50px;
    top: 50%;
    transform: translateY(-50%);
    cursor: pointer;
}
    
    
</style>

</head>
<body>



<div class="container">

    <div class="icon-box">
        <i class="fa-solid fa-user"></i>
    </div>

    <h2>Create Account</h2>
    <p class="subtitle">Join us today and get started</p>
    
     <c:if test="${not empty error}">
        <div class="error">${error}</div>
      </c:if>
      
      
    <form action="${pageContext.request.contextPath}/register" method="post">

    <!-- Full Name -->
    <label for="fullname">Full Name</label>
    <div class="input-group">
        <i class="fa-solid fa-user"></i>
        <input type="text" id="full name" name ="name" placeholder="Enter your name">
    </div>

    <!-- Email -->
    <label for="email">Email</label>
    <div class="input-group">
        <i class="fa-solid fa-envelope"></i>
        <input type="email" id="email" name ="email" placeholder="you@example.com">
    </div>

    <!-- Phone Number -->
    <label for="phone">Phone Number</label>
    <div class="input-group">
        <i class="fa-solid fa-phone"></i>
         <input type="text" id="phone" name ="phone"   placeholder="+91 98765 43210">
         
    </div>

    <!-- Password -->
		<label for="password">Password</label>
		<div class="input-group password-field">
		    <i class="fa-solid fa-lock"></i>
		
		    <input type="password" id="password" name="password" placeholder="••••••">
		
		    <!-- Eye icon -->
		    <span id="togglePassword" class="eye-icon">
		        <i id="eyeOpen" class="fa-solid fa-eye" style="display:none;"></i>
		        <i id="eyeClose" class="fa-solid fa-eye-slash"></i>
		    </span>
		</div>

    <button class="btn">Register</button>
    
    </form>

     <div class="login-text">
        Already have an account?  
        <a href="${pageContext.request.contextPath}/auth/login.jsp">Login</a>
    </div>

    

</div>

<script>
const password = document.getElementById("password");
const toggle = document.getElementById("togglePassword");
const eyeOpen = document.getElementById("eyeOpen");
const eyeClose = document.getElementById("eyeClose");

toggle.addEventListener("click", () => {
    if (password.type === "password") {
        password.type = "text";
        eyeOpen.style.display = "inline";
        eyeClose.style.display = "none";
    } else {
        password.type = "password";
        eyeOpen.style.display = "none";
        eyeClose.style.display = "inline";
    }
});
</script>


</body>
</html>
