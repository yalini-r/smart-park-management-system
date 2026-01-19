package com.smartpark.dao;

import com.smartpark.dto.*;

import com.smartpark.util.GetConnection;
import java.time.Duration;
import java.time.LocalDate;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class VehicleDAO {

	public boolean enterWalkInVehicle(
	        String numberPlate,
	        VehicleType type,
	        int slotId,
	        String guestName,
	        String guestPhone
	) throws SQLException {

	    try (Connection con = GetConnection.getConnection()) {

	        con.setAutoCommit(false);

	        if (hasActiveVehicle(con, numberPlate)) {
	            con.rollback();
	            return false;
	        }

	        ParkingSlotDAO slotDAO = new ParkingSlotDAO();
	        if (!slotDAO.isSlotFree(con, slotId)) {
	            con.rollback();
	            return false;
	        }

	        BookingDAO bookingDAO = new BookingDAO();
	        int bookingId = bookingDAO.createWalkInBooking(
	                con, slotId, numberPlate, type, guestName, guestPhone
	        );

	        String sql = "INSERT INTO vehicle (number_plate, type, entry_time, user_id, slot_id, booking_id) VALUES (?, ?, NOW(), NULL, ?, ?)";

	        try (PreparedStatement ps = con.prepareStatement(sql)) {
	            ps.setString(1, numberPlate);
	            ps.setString(2, type.name());
	            ps.setInt(3, slotId);
	            ps.setInt(4, bookingId);
	            ps.executeUpdate();
	        }

	        slotDAO.updateSlotStatus(con, slotId, SlotStatus.OCCUPIED);
	        con.commit();
	        return true;
	    }
	}



	public boolean hasActiveVehicle(String numberPlate) throws SQLException {
	    String sql =
	        "SELECT 1 FROM vehicle " +
	        "WHERE number_plate = ? AND exit_time IS NULL";

	    try (Connection con = GetConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setString(1, numberPlate);
	        ResultSet rs = ps.executeQuery();
	        return rs.next();
	    }
	}


	
	public boolean hasActiveVehicle(Connection con, String numberPlate)
	        throws SQLException {

	    String sql =
	        "SELECT 1 FROM vehicle " +
	        "WHERE number_plate = ? AND exit_time IS NULL " +
	        "FOR UPDATE";

	    try (PreparedStatement ps = con.prepareStatement(sql)) {
	        ps.setString(1, numberPlate);
	        ResultSet rs = ps.executeQuery();
	        return rs.next();
	    }
	}


    public boolean enterPreBookedVehicle(int bookingId, String numberPlate, VehicleType type)
            throws SQLException {

        String sql =
            "SELECT slot_id, user_id FROM booking " +
            "WHERE booking_id = ? AND status = 'BOOKED' " +
            "AND NOW() BETWEEN start_time AND end_time FOR UPDATE";

        try (Connection con = GetConnection.getConnection()) {
            con.setAutoCommit(false);

            int slotId;
            int userId;

            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, bookingId);
                ResultSet rs = ps.executeQuery();

                if (!rs.next()) {
                    con.rollback();
                    return false;
                }

                slotId = rs.getInt("slot_id");
                userId = rs.getInt("user_id");
            }

            ParkingSlotDAO slotDAO = new ParkingSlotDAO(); 

            //allow RESERVED, block only OCCUPIED
            String slotSql = "SELECT status FROM parking_slot WHERE slot_id = ? FOR UPDATE";
            try (PreparedStatement ps = con.prepareStatement(slotSql)) {
                ps.setInt(1, slotId);
                ResultSet rs = ps.executeQuery();

                if (!rs.next()) {
                    con.rollback();
                    return false;
                }

                SlotStatus status = SlotStatus.valueOf(rs.getString("status"));
                if (status == SlotStatus.OCCUPIED) {
                    con.rollback();
                    return false;
                }
            }

            // Double-entry safety
            if (vehicleExistsForBooking(con, bookingId)) {
                con.rollback();
                return false;
            }

            // Insert vehicle
            String insert =
                "INSERT INTO vehicle (number_plate, type, entry_time, user_id, slot_id, booking_id) " +
                "VALUES (?, ?, NOW(), ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(insert)) {
                ps.setString(1, numberPlate);
                ps.setString(2, type.name());
                ps.setInt(3, userId);
                ps.setInt(4, slotId);
                ps.setInt(5, bookingId);
                ps.executeUpdate();
            }

            // Booking - ACTIVE
            BookingDAO bookingDAO = new BookingDAO();
            bookingDAO.updateStatus(
                    con,
                    bookingId,
                    BookingStatus.ACTIVE,
                    slotDAO
            );


            // Slot - OCCUPIED
            slotDAO.updateSlotStatus(con, slotId, SlotStatus.OCCUPIED);

            con.commit();
            return true;
        }
    }


    private boolean vehicleExistsForBooking(Connection con, int bookingId)
            throws SQLException {

        String sql =
            "SELECT 1 FROM vehicle WHERE booking_id = ? LIMIT 1";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }


    public List<VehicleExitViewDTO> getVehiclesInsideForExit() throws SQLException {

        List<VehicleExitViewDTO> list = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now(); 

        String sql =
        	    "SELECT v.vehicle_id, v.number_plate, v.type AS vehicle_type," +
        	    " v.entry_time, v.exit_time, v.final_amount," +
        	    " b.booking_id, b.booking_type, b.start_time, b.end_time AS booking_end_time, b.status AS booking_status, b.estimated_amount," +
        	    " u.name AS user_name, s.floor, s.slot_number, s.slot_id" +
        	    " FROM vehicle v" +
        	    " LEFT JOIN booking b ON v.booking_id = b.booking_id" +
        	    " JOIN parking_slot s ON v.slot_id = s.slot_id" +
        	    " LEFT JOIN users u ON v.user_id = u.id" +
        	    " ORDER BY v.exit_time IS NULL DESC, v.entry_time DESC";


        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                VehicleExitViewDTO dto = new VehicleExitViewDTO();

                dto.setVehicleId(rs.getInt("vehicle_id"));
                dto.setBookingId(rs.getInt("booking_id"));

                dto.setNumberPlate(rs.getString("number_plate"));
                dto.setVehicleType(VehicleType.valueOf(rs.getString("vehicle_type")));

                // Entry time
                Timestamp entryTs = rs.getTimestamp("entry_time");
                dto.setEntryTime(entryTs != null ? entryTs.toLocalDateTime() : null);

                // Booking type
                String bt = rs.getString("booking_type");
                dto.setBookingType(bt == null ? BookingType.WALKIN : BookingType.valueOf(bt));

                // Booking start time
                Timestamp startTs = rs.getTimestamp("start_time");
                dto.setBookingStartTime(startTs != null ? startTs.toLocalDateTime() : null);

                // Booking end time
                Timestamp endTs = rs.getTimestamp("booking_end_time");
                dto.setBookingEndTime(endTs != null ? endTs.toLocalDateTime() : null);

                // Booking status
                String status = rs.getString("booking_status");
                dto.setBookingStatus(status != null ? status : "ACTIVE");

                // Long stay (walk-in)
                if (entryTs != null && dto.getBookingType() == BookingType.WALKIN) {
                    long hours = Duration.between(entryTs.toLocalDateTime(), now).toHours();
                    dto.setLongStay(hours >= 6);
                } else {
                    dto.setLongStay(false);
                }

                // Over stay (pre-book only)
                if (dto.getBookingType() == BookingType.PREBOOK && endTs != null) {
                    dto.setOverstay(now.isAfter(endTs.toLocalDateTime().plusMinutes(15)));
                } else {
                    dto.setOverstay(false);
                }

                // Amounts
                dto.setEstimatedAmount(rs.getDouble("estimated_amount"));

                Timestamp exitTs = rs.getTimestamp("exit_time");
                dto.setExitTime(exitTs != null ? exitTs.toLocalDateTime() : null);

                Double finalAmount = rs.getObject("final_amount", Double.class);
                dto.setFinalAmount(finalAmount);

                dto.setUserName(rs.getString("user_name"));
                dto.setFloor(rs.getInt("floor"));
                dto.setSlotNumber(rs.getString("slot_number"));
                dto.setSlotId(rs.getInt("slot_id"));
               

                list.add(dto);
            }
        }

        return list;
    }


    /* =========================================================
       EXIT PROCESS – ATOMIC & SAFE
       ========================================================= */
 // VehicleDAO.java
    public void processVehicleExit(int vehicleId, LocalDateTime exitTime, double finalAmount) throws SQLException {
        String lockVehicleSql = "SELECT booking_id, slot_id FROM vehicle WHERE vehicle_id = ? FOR UPDATE";
        
        String updateVehicleSql = "UPDATE vehicle SET exit_time = ?, final_amount = ? WHERE vehicle_id = ? AND exit_time IS NULL";
        
        String updateBookingSql = "UPDATE booking SET status = 'COMPLETED', final_amount = ? WHERE booking_id = ? AND status = 'ACTIVE'";
        
        String freeSlotSql = "UPDATE parking_slot SET status = 'FREE' WHERE slot_id = ? AND status = 'OCCUPIED'";

        try (Connection con = GetConnection.getConnection()) {
            con.setAutoCommit(false);

            Integer bookingId = null;
            Integer slotId = null;

            //  Lock vehicle row and fetch booking + slot
            try (PreparedStatement ps = con.prepareStatement(lockVehicleSql)) {
                ps.setInt(1, vehicleId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        throw new SQLException("Vehicle not found or already exited");
                    }
                    bookingId = rs.getObject("booking_id", Integer.class);
                    slotId = rs.getInt("slot_id");
                }
            }

            //Update vehicle exit time & final amount
            try (PreparedStatement ps = con.prepareStatement(updateVehicleSql)) {
                ps.setTimestamp(1, Timestamp.valueOf(exitTime));
                ps.setDouble(2, finalAmount);
                ps.setInt(3, vehicleId);
                if (ps.executeUpdate() == 0) {
                    throw new SQLException("Vehicle exit already processed");
                }
            }
            
            //  Update booking if pre booked
            if (bookingId != null) {
                try (PreparedStatement ps = con.prepareStatement(updateBookingSql)) {
                    ps.setDouble(1, finalAmount);
                    ps.setInt(2, bookingId);
                    ps.executeUpdate();
                }
            }

            // Free the slot
            if (slotId != null) {
                try (PreparedStatement ps = con.prepareStatement(freeSlotSql)) {
                    ps.setInt(1, slotId);
                    int rows = ps.executeUpdate();
                    if (rows == 0) {
                        throw new SQLException("Slot release failed or already free");
                    }
                }
            }

            con.commit();
        } catch (SQLException e) {
            throw e; 
        }
    }


    public VehicleExitViewDTO getVehicleExitDetails(int vehicleId) throws SQLException {

        String sql =
            "SELECT v.entry_time, v.final_amount, v.type AS vehicle_type"
            + ", v.number_plate, " +
            "b.booking_type, b.end_time AS booking_end_time " +
            "FROM vehicle v " +
            "LEFT JOIN booking b ON v.booking_id = b.booking_id " +
            "WHERE v.vehicle_id = ? AND v.exit_time IS NULL";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, vehicleId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) return null;

            VehicleExitViewDTO dto = new VehicleExitViewDTO();
            dto.setVehicleId(vehicleId);
            dto.setNumberPlate(rs.getString("number_plate"));
            dto.setVehicleType(VehicleType.valueOf(rs.getString("vehicle_type")));

            // Entry time
            Timestamp entryTs = rs.getTimestamp("entry_time");
            if (entryTs != null) {
                dto.setEntryTime(entryTs.toLocalDateTime());
            }

            // Booking type
            String bt = rs.getString("booking_type");
            dto.setBookingType(bt == null ? BookingType.WALKIN : BookingType.valueOf(bt));

            // Booking end time & overstay
            Timestamp bookingEndTs = rs.getTimestamp("booking_end_time");
            if (bookingEndTs != null) {
                LocalDateTime bookingEnd = bookingEndTs.toLocalDateTime();
                dto.setBookingEndTime(bookingEnd);

                // Calculate over stay for pre book
                if (dto.getBookingType() == BookingType.PREBOOK) {
                    dto.setOverstay(LocalDateTime.now().isAfter(bookingEnd.plusMinutes(15)));
                } else {
                    dto.setOverstay(false);
                }
            } else {
                dto.setOverstay(false);
            }

            return dto;
        }
    }


    public VehicleExitViewDTO getExitViewByBookingId(Connection con, int bookingId) throws SQLException {

        String sql =
            "SELECT v.vehicle_id, v.number_plate, v.type AS vehicle_type," +
            " v.entry_time, v.exit_time, v.final_amount," +
            " b.booking_id, b.booking_type, b.start_time, b.end_time AS booking_end_time, b.status AS booking_status, b.estimated_amount," +
            " u.name AS user_name, s.floor, s.slot_number, s.slot_id" +
            " FROM vehicle v" +
            " JOIN parking_slot s ON v.slot_id = s.slot_id" +
            " LEFT JOIN users u ON v.user_id = u.id" +
            " LEFT JOIN booking b ON v.booking_id = b.booking_id" +
            " WHERE b.booking_id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    VehicleExitViewDTO dto = new VehicleExitViewDTO();
                    dto.setVehicleId(rs.getInt("vehicle_id"));
                    dto.setBookingId(rs.getInt("booking_id"));
                    dto.setNumberPlate(rs.getString("number_plate"));
                    dto.setVehicleType(VehicleType.valueOf(rs.getString("vehicle_type")));

                    Timestamp entryTs = rs.getTimestamp("entry_time");
                    dto.setEntryTime(entryTs != null ? entryTs.toLocalDateTime() : null);

                    Timestamp startTs = rs.getTimestamp("start_time");
                    dto.setBookingStartTime(startTs != null ? startTs.toLocalDateTime() : null);

                    Timestamp endTs = rs.getTimestamp("booking_end_time");
                    dto.setBookingEndTime(endTs != null ? endTs.toLocalDateTime() : null);

                    String status = rs.getString("booking_status");
                    dto.setBookingStatus(status != null ? status : "ACTIVE");

                    String bt = rs.getString("booking_type");
                    dto.setBookingType(bt == null ? BookingType.WALKIN : BookingType.valueOf(bt));

                    dto.setEstimatedAmount(rs.getDouble("estimated_amount"));
                    dto.setFinalAmount(rs.getObject("final_amount", Double.class));

                    dto.setUserName(rs.getString("user_name"));
                    dto.setFloor(rs.getInt("floor"));
                    dto.setSlotNumber(rs.getString("slot_number"));
                    dto.setSlotId(rs.getInt("slot_id")); 
                    


                    // Flags
                    if (entryTs != null && dto.getBookingType() == BookingType.WALKIN) {
                        long hours = Duration.between(entryTs.toLocalDateTime(), LocalDateTime.now()).toHours();
                        dto.setLongStay(hours >= 6);
                    }
                    if (dto.getBookingType() == BookingType.PREBOOK && endTs != null) {
                        dto.setOverstay(LocalDateTime.now().isAfter(endTs.toLocalDateTime().plusMinutes(15)));
                    }

                    return dto;
                }
            }
        }
        return null;
    }

    
    public void updateVehicleExit(Connection con, int vehicleId, LocalDateTime exitTime, double finalAmount) throws SQLException {
        String sql = "UPDATE vehicle SET exit_time = ?, final_amount = ? WHERE vehicle_id = ? AND exit_time IS NULL";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(exitTime));
            ps.setDouble(2, finalAmount);
            ps.setInt(3, vehicleId);
            int updated = ps.executeUpdate();
            if (updated == 0) {
                throw new SQLException("Vehicle already exited or not found");
            }
        }
    }
    
    
    public void updateBookingCompleted(Connection con, int bookingId, double finalAmount) throws SQLException {
        String sql = "UPDATE booking SET status = 'COMPLETED', final_amount = ? WHERE booking_id = ? AND status = 'ACTIVE'";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDouble(1, finalAmount);
            ps.setInt(2, bookingId);
            ps.executeUpdate();
        }
    }


    public void updateSlotStatus(Connection con, int slotId, String status) throws SQLException {
        String sql = "UPDATE parking_slot SET status = ? WHERE slot_id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, slotId);
            ps.executeUpdate();
        }
    }
    
    public double getTodayRevenue() throws SQLException {

        String sql =
            "SELECT COALESCE(SUM(final_amount), 0) " +
            "FROM vehicle " +
            "WHERE exit_time IS NOT NULL " +
            "AND DATE(exit_time) = CURDATE()";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }
            return 0;
        }
    }


    
    public List<VehicleExitViewDTO> getRevenueByDate(LocalDate fromDate, LocalDate toDate, BookingType type) {
        if (fromDate == null) fromDate = LocalDate.of(1970, 1, 1); // earliest date
        if (toDate == null) toDate = LocalDate.now();              // today

        List<VehicleExitViewDTO> list = new ArrayList<VehicleExitViewDTO>();

        String sql =
            "SELECT v.exit_time, v.final_amount, v.number_plate, v.entry_time, " +
            "b.booking_type, s.slot_number " +
            "FROM vehicle v " +
            "JOIN parking_slot s ON v.slot_id = s.slot_id " +
            "LEFT JOIN booking b ON v.booking_id = b.booking_id " +
            "WHERE v.exit_time IS NOT NULL " +
            "AND DATE(v.exit_time) BETWEEN ? AND ? ";

        if (type != null) {
            if (type == BookingType.PREBOOK) sql += "AND b.booking_type = 'PREBOOK' ";
            else if (type == BookingType.WALKIN) sql += "AND (b.booking_type IS NULL OR b.booking_type = 'WALKIN') ";
        }

        sql += "ORDER BY v.exit_time DESC";

        try (
            Connection con = GetConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {
            ps.setDate(1, java.sql.Date.valueOf(fromDate));
            ps.setDate(2, java.sql.Date.valueOf(toDate));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    VehicleExitViewDTO dto = new VehicleExitViewDTO();
                    dto.setNumberPlate(rs.getString("number_plate"));

                    String bookingTypeStr = rs.getString("booking_type");
                    if (bookingTypeStr == null) dto.setBookingType(BookingType.WALKIN);
                    else dto.setBookingType(BookingType.valueOf(bookingTypeStr));

                    dto.setSlotNumber(rs.getString("slot_number"));

                    java.sql.Timestamp exitTs = rs.getTimestamp("exit_time");
                    if (exitTs != null) dto.setExitTime(exitTs.toLocalDateTime());

                    java.sql.Timestamp entryTs = rs.getTimestamp("entry_time");
                    if (entryTs != null) dto.setEntryTime(entryTs.toLocalDateTime());

                    dto.setFinalAmount(rs.getDouble("final_amount"));

                    list.add(dto);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public RevenueStatsDTO getRevenueStatsByDate(LocalDate fromDate, LocalDate toDate) {
        RevenueStatsDTO stats = new RevenueStatsDTO();

        // Fetch all exits in the date range
        List<VehicleExitViewDTO> allExits = getRevenueByDate(fromDate, toDate, null);

        LocalDate today = LocalDate.now();
        LocalDate weekStart = today.minusDays(6);
        LocalDate monthStart = today.minusDays(29);

        double preToday = 0, preWeek = 0, preMonth = 0, preTotal = 0;
        double walkToday = 0, walkWeek = 0, walkMonth = 0, walkTotal = 0;

        for (VehicleExitViewDTO v : allExits) {
            if (v.getExitTime() == null) continue;

            LocalDate exitDate = new java.sql.Timestamp(v.getExitTime().getTime())
                                    .toLocalDateTime()
                                    .toLocalDate();
            double amt = v.getFinalAmount();

            if (v.getBookingType() == BookingType.PREBOOK) {
                preTotal += amt;
                if (exitDate.isEqual(today)) preToday += amt;
                if (!exitDate.isBefore(weekStart)) preWeek += amt;
                if (!exitDate.isBefore(monthStart)) preMonth += amt;
            } else {
                walkTotal += amt;
                if (exitDate.isEqual(today)) walkToday += amt;
                if (!exitDate.isBefore(weekStart)) walkWeek += amt;
                if (!exitDate.isBefore(monthStart)) walkMonth += amt;
            }
        }

        stats.setPreBookToday(preToday);
        stats.setPreBookWeek(preWeek);
        stats.setPreBookMonth(preMonth);
        stats.setPreBookTotal(preTotal);

        stats.setWalkinToday(walkToday);
        stats.setWalkinWeek(walkWeek);
        stats.setWalkinMonth(walkMonth);
        stats.setWalkinTotal(walkTotal);

        return stats;
    }


    



  
}
