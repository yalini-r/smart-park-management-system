<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.smartpark.dto.User" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
User u = (User) session.getAttribute("user");
if (u == null) {
    response.sendRedirect("../auth/login.jsp");
    return;
}

String error = (String) request.getAttribute("error");
String msg = (String) session.getAttribute("msg");
if (msg != null) session.removeAttribute("msg");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Change Password</title>

    <style>
        body {
            font-family: Arial;
            background: #f0f0f0;
            padding: 40px;
        }

        .container {
            width: 420px;
            margin: auto;
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 12px rgba(0,0,0,0.2);
        }

        h2 { text-align: center; }

        .msg { padding: 10px; margin-bottom: 12px; border-radius: 5px; font-weight: bold; }
        .error { background: #ffdddd; border-left: 5px solid #e60000; }
        .success { background: #ddffdd; border-left: 5px solid #00b400; }

        .input-group {
            position: relative;
        }

        input {
            width: 100%;
            padding: 8px 35px 8px 8px;
            margin-top: 4px;
            margin-bottom: 12px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }

        .eye {
            position: absolute;
            right: 10px;
            top: 12px;
            cursor: pointer;
            font-size: 14px;
            color: #555;
        }

        button {
            width: 100%;
            padding: 10px;
            background: #0077ff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        button:disabled {
            background: #9ec9ff;
            cursor: not-allowed;
        }

        .strength { font-size: 13px; font-weight: bold; margin-bottom: 10px; }
    </style>

    <script>
        function togglePassword(id, iconId) {
            let field = document.getElementById(id);
            let icon = document.getElementById(iconId);

            if (field.type === "password") {
                field.type = "text";
                icon.innerHTML = "🙈";
            } else {
                field.type = "password";
                icon.innerHTML = "👁️";
            }
        }

        function checkStrength() {
            let pwd = document.getElementById("newPwd").value;
            let strengthMsg = document.getElementById("strengthMsg");
            let submitBtn = document.getElementById("submitBtn");

            let strength = 0;
            if (pwd.length >= 8) strength++;
            if (/[A-Z]/.test(pwd)) strength++;
            if (/[0-9]/.test(pwd)) strength++;
            if (/[@#$%^&+=!]/.test(pwd)) strength++;

            if (strength <= 1) {
                strengthMsg.innerHTML = "Weak Password";
                strengthMsg.style.color = "red";
                submitBtn.disabled = true;
            }
            else if (strength === 2) {
                strengthMsg.innerHTML = "Medium Strength";
                strengthMsg.style.color = "orange";
                submitBtn.disabled = false;
            }
            else {
                strengthMsg.innerHTML = "Strong Password";
                strengthMsg.style.color = "green";
                submitBtn.disabled = false;
            }
        }
    </script>

</head>
<body>

<div class="container">
    <h2>Change Password</h2>

    <% if (error != null) { %>
        <div class="msg error"><%= error %></div>
    <% } %>

    <% if (msg != null) { %>
        <div class="msg success"><%= msg %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/changePassword"  method="post">

        <label>Old Password:</label>
        <div class="input-group">
            <input type="password" name="oldPwd" id="oldPwd" required>
            <span class="eye" id="eye1" onclick="togglePassword('oldPwd','eye1')">👁️</span>
        </div>

        <label>New Password:</label>
        <div class="input-group">
            <input type="password" name="newPwd" id="newPwd" onkeyup="checkStrength()" required>
            <span class="eye" id="eye2" onclick="togglePassword('newPwd','eye2')">👁️</span>
        </div>

        <div class="strength" id="strengthMsg"></div>

        <label>Confirm New Password:</label>
        <div class="input-group">
            <input type="password" name="confirmPwd" id="confirmPwd" required>
            <span class="eye" id="eye3" onclick="togglePassword('confirmPwd','eye3')">👁️</span>
        </div>

        <button id="submitBtn" type="submit" disabled>Update Password</button>
    </form>

    <br>
    <a href="userDashboard.jsp">Back to Dashboard</a>
</div>

</body>
</html>
