
package com.smartpark.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.smartpark.dto.User;
import com.smartpark.dto.UsersStatus;
import com.smartpark.util.GetConnection;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {

    // ---------------------------
    // REGISTER USER (HASHED)
    // ---------------------------
    public boolean registerUser(User user) throws SQLException {

        String sql = "INSERT INTO users (name, email, password, phone, role) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            // Hash password before inserting
            String hashedPwd = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashedPwd);
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole() == null ? "user" : user.getRole());

            return ps.executeUpdate() > 0;
        }
    }



    // ---------------------------
    // VALIDATE LOGIN (CHECK HASH)
    // ---------------------------
    public User validateUser(String email, String password) throws SQLException {

        String query = "SELECT * FROM users WHERE email = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {

            pst.setString(1, email);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {

                String storedHash = rs.getString("password");

                // Compare using BCrypt
                if (BCrypt.checkpw(password, storedHash)) {

                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));

                    return user; 
                }
            }
        }

        return null; 
    }



    // ---------------------------
    // UPDATE NAME
    // ---------------------------
    public boolean updateName(int id, String name) throws SQLException {

        String sql = "UPDATE users SET name = ? WHERE id = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;
        }
    }
    
    
 // ---------------------------
    // VERIFY OLD PASSWORD
    // ---------------------------
    public boolean verifyPassword(int userId, String oldPwd) throws Exception {
    	
        String sql = "SELECT password FROM users WHERE id=?";
        
        try (Connection con =GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
            	
                String hashedPwd = rs.getString("password");
                return BCrypt.checkpw(oldPwd, hashedPwd); 
                
            }
            
            return false;
        }
    }




    // ---------------------------
    // UPDATE PASSWORD (HASHED)
    // ---------------------------
    public boolean updatePassword(int userId, String newPassword) throws SQLException {

        String sql = "UPDATE users SET password = ? WHERE id = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String hashedPwd = BCrypt.hashpw(newPassword, BCrypt.gensalt());

            ps.setString(1, hashedPwd);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;
        }
    }



    // ---------------------------
    // UPDATE PHONE NUMBER
    // ---------------------------
    public boolean updatePhoneNumber(int id, String phone) throws SQLException {

        String sql = "UPDATE users SET phone = ? WHERE id = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, phone);
            ps.setInt(2, id);

            return ps.executeUpdate() > 0;
        }
    }



    // ---------------------------
    // DELETE USER BY ID
    // ---------------------------
    public boolean deleteUser(int id) throws SQLException {

        String sql = "DELETE FROM users WHERE id = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // Overloaded
    public boolean deleteUser(User user) throws SQLException {
        return deleteUser(user.getId());
    }



    // ---------------------------
    // CHECK EXISTING EMAIL
    // ---------------------------
    public boolean isEmailExists(String email) throws SQLException {

        String sql = "SELECT id FROM users WHERE email = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); 
            }
        }
    }
    
    public User getUserById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setName(rs.getString("name"));
                    u.setEmail(rs.getString("email"));
                    u.setPhone(rs.getString("phone"));
                    u.setRole(rs.getString("role"));
                    u.setPassword(rs.getString("password")); 
                    return u;
                }
            }
        }
        return null;
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> list = new ArrayList<>();

        // Include the new 'status' column
        String sql = "SELECT id, name, email, phone, role, status FROM users WHERE role <> 'ADMIN'";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setPhone(rs.getString("phone"));
                u.setRole(rs.getString("role"));
              
                u.setStatus(UsersStatus.valueOf(rs.getString("status"))); 
                list.add(u);
            }
        }

        return list;
    }


    
    public int getUserCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE role <> 'ADMIN'";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public boolean updateStatus(int userId, UsersStatus status) throws SQLException {
        String sql = "UPDATE users SET status=? WHERE id=?";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }


    public int saveOrGetUser(String name, String contact) throws SQLException {

       
        if (name == null || name.trim().isEmpty()
                || contact == null || contact.trim().isEmpty()) {
            return 1;
        }

        String findSql = "SELECT id FROM users WHERE phone = ?";
        String insertSql =
        	    "INSERT INTO users(name, email, password, phone, role) " +
        	    "VALUES (?, ?, ?, ?, 'USER')";
      
        try (Connection con = GetConnection.getConnection()) {

            
            try (PreparedStatement ps = con.prepareStatement(findSql)) {
                ps.setString(1, contact);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }

           
            try (PreparedStatement ps =
                    con.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, name);
                ps.setString(2, contact);
                ps.executeUpdate();

                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 1;
    }

}
