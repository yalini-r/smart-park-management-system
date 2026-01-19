package com.smartpark.dao;

import java.sql.*;
import com.smartpark.dto.VehicleRate;
import com.smartpark.dto.VehicleType;
import com.smartpark.util.GetConnection;


public class VehicleRateDAO {

    
    public VehicleRate getRateByVehicleType(Connection con, VehicleType type) throws SQLException {
        String sql = "SELECT hourly_rate, night_multiplier, weekend_multiplier FROM vehicle_rate WHERE vehicle_type = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, type.name());
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return new VehicleRate(
                        type,
                        rs.getDouble("hourly_rate"),
                        rs.getDouble("night_multiplier"),
                        rs.getDouble("weekend_multiplier")
                );
            }
        }
    }

   
    public VehicleRate getRateByVehicleType(VehicleType type) throws SQLException {
        try (Connection con = GetConnection.getConnection()) {
            return getRateByVehicleType(con, type);
        }
    }
}
