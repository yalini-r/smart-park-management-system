<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.smartpark.dto.User" %>

<%
User u = (User) session.getAttribute("user");

if (u == null) {
    session.invalidate(); 
    response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
    return;
}

// Flash messages
String error = (String) request.getAttribute("error");
String msg = (String) session.getAttribute("msg");
if (msg != null) session.removeAttribute("msg");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Update Profile</title>
    <style>
        body { font-family: Arial; background: #f4f4f4; padding: 40px; }
        .container {
            width: 420px; background: white; padding: 25px;
            margin: auto; border-radius: 8px;
            box-shadow: 0 0 12px rgba(0,0,0,0.2);
        }
        h2 { text-align: center; }
        label { font-weight: bold; }
        input {
            width: 100%; padding: 8px; margin-bottom: 12px;
            border-radius: 4px; border: 1px solid #ccc;
        }
        button {
            width: 100%; padding: 10px;
            background: #0077ff; color: white;
            border: none; border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover { background: #005bb5; }
    </style>
</head>
<body>

<div class="container">

    <h2>Update Profile</h2>

    <% if (error != null) { %>
        <script>alert("<%= error %>");</script>
    <% } %>

    <% if (msg != null) { %>
        <script>alert("<%= msg %>");</script>
    <% } %>

    <!-- COMMON servlet for both admin & user -->
    <form action="${pageContext.request.contextPath}/updateProfile" method="post">
        <label>Name:</label>
        <input type="text" name="name" value="<%= u.getName() %>" required>

        <label>Email (cannot change):</label>
        <input type="text" value="<%= u.getEmail() %>" disabled>

        <label>Phone:</label>
        <input type="text" name="phone" value="<%= u.getPhone() %>" required>

        <button type="submit">Save Changes</button>
    </form>

    <br>

    <!-- Go back to correct dashboard depending on role -->
    <% if ("admin".equals(u.getRole())) { %>
        <a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp">Back to Dashboard</a>
    <% } else { %>
        <a href="${pageContext.request.contextPath}/user/userDashboard.jsp">Back to Dashboard</a>
    <% } %>

</div>

</body>
</html>
