package com.smartpark.dao;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.smartpark.dto.Booking;
import com.smartpark.dto.BookingStatus;
import com.smartpark.dto.BookingViewDTO;
import com.smartpark.dto.SlotStatus;
import com.smartpark.dto.VehicleType;

import com.smartpark.dto.BookingType;


import com.smartpark.util.GetConnection;

public class BookingDAO {

	public boolean createBooking(Booking booking) throws SQLException {

	    try (Connection con = GetConnection.getConnection()) {
	        con.setAutoCommit(false);

	        
	        if (booking.getStartTime().isBefore(LocalDateTime.now().plusMinutes(30))) {
	            con.rollback();
	            return false;
	        }

	       
	        if (hasOverlap(con,
	                       booking.getSlotId(),
	                       booking.getStartTime(),
	                       booking.getEndTime())) {
	            con.rollback();
	            return false;
	        }

	       
	        String sql = " INSERT INTO booking "
	        		     + "(start_time, end_time, status, alert_sent, user_id, slot_id, vehicle_number, vehicle_type, estimated_amount)"
	                     +"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	       

	        try (PreparedStatement ps =
	                 con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

	            ps.setTimestamp(1, Timestamp.valueOf(booking.getStartTime()));
	            ps.setTimestamp(2, Timestamp.valueOf(booking.getEndTime()));
	            ps.setString(3, BookingStatus.BOOKED.name());
	            ps.setBoolean(4, false);
	            ps.setInt(5, booking.getUserId());
	            ps.setInt(6, booking.getSlotId());
	            ps.setString(7, booking.getVehicleNumber());
	            ps.setString(8, booking.getVehicleType().name());
	            ps.setDouble(9, booking.getEstimatedAmount());

	            ps.executeUpdate();

	            ResultSet rs = ps.getGeneratedKeys();
	            if (rs.next()) booking.setBookingId(rs.getInt(1));
	        }

	   
	        new ParkingSlotDAO().syncSlotStatus(con, booking.getSlotId());

	        con.commit();
	        return true;
	    }
	}


	
	public int createWalkInBooking(Connection con, int slotId,  String vehicleNumber, VehicleType type, String guestName,String guestPhone) throws SQLException {

	    String sql = "INSERT INTO booking (booking_type, start_time, status, slot_id, vehicle_number, vehicle_type, guest_name, guest_phone)"
	       +" VALUES ('WALKIN', NOW(), 'ACTIVE', ?, ?, ?, ?, ?)";

	    try (PreparedStatement ps =
	            con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

	        ps.setInt(1, slotId);
	        ps.setString(2, vehicleNumber);
	        ps.setString(3, type.name());
	        ps.setString(4, guestName);
	        ps.setString(5, guestPhone);

	        ps.executeUpdate();
	        ResultSet rs = ps.getGeneratedKeys();
	        rs.next();
	        return rs.getInt(1);
	    }
	}



    public Booking getBookingById(int id) throws SQLException {
        String sql = "SELECT * FROM booking WHERE booking_id = ?";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapResultSetToBooking(rs) : null;
            }
        }
    }

    
    public boolean updateStatus(int bookingId, BookingStatus status) throws SQLException {

        try (Connection con = GetConnection.getConnection()) {
            con.setAutoCommit(false);

            ParkingSlotDAO slotDAO = new ParkingSlotDAO();
            boolean ok = updateStatus(con, bookingId, status, slotDAO);

            if (ok) con.commit();
            else con.rollback();

            return ok;
        }
    }


    
    public boolean adminCancelBooking(int bookingId) throws SQLException {
        return updateStatus(bookingId, BookingStatus.CANCELLED);
    }


    public List<Booking> getBookingsByUserId(int userId) throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM booking WHERE user_id = ? ORDER BY start_time DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapResultSetToBooking(rs));
            }
        }
        return list;
    }

    public List<Booking> getBookingsForToday() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM booking WHERE DATE(start_time) = CURDATE() AND status = 'BOOKED'";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapResultSetToBooking(rs));
        } catch (Exception e) { e.printStackTrace(); }

        return list;
    }

    public Booking getActiveOrBookedBookingBySlot(int slotId) throws SQLException {
        Booking active = getActiveBookingBySlot(slotId);
        return active != null ? active : getUpcomingBookingBySlot(slotId);
    }

    public Booking getActiveBookingBySlot(int slotId) throws SQLException {
        String sql = "SELECT * FROM booking WHERE slot_id = ? AND status='ACTIVE' AND start_time <= NOW() AND end_time >= NOW() LIMIT 1";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, slotId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapResultSetToBooking(rs) : null;
            }
        }
    }

    public Booking getUpcomingBookingBySlot(int slotId) throws SQLException {

        String sql = "SELECT * FROM booking " +
                     "WHERE slot_id = ? " +
                     "AND status = ? " +
                     "AND start_time > NOW() " +
                     "ORDER BY start_time ASC LIMIT 1";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, slotId);
            ps.setString(2, BookingStatus.BOOKED.name());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapResultSetToBooking(rs) : null;
            }
        }
    }


    public Booking getActiveBookingByUserSlot(int userId, int slotId) throws SQLException {

        String sql = "SELECT * FROM booking WHERE user_id=? AND slot_id=? AND status=? LIMIT 1";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, slotId);
            ps.setString(3, BookingStatus.ACTIVE.name());

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapResultSetToBooking(rs) : null;
            }
        }
    }

    public List<Booking> getAllBookings() throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM booking ORDER BY start_time DESC";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapResultSetToBooking(rs));
        }
        return list;
    }

    public int getCountByStatus(BookingStatus status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM booking WHERE status = ?";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status.name());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public int getActiveBookingsCount() { 
    	try {
    		return getCountByStatus(BookingStatus.ACTIVE);
    		} 
    	catch (SQLException e)
    	{ 
    		return 0; 
    		} 
    	}

    public int getTodaysBookingsCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM booking WHERE DATE(start_time)=CURDATE()";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getTotalBookings() throws SQLException {
        String sql = "SELECT COUNT(*) FROM booking";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public int getCancelledBookingsCount() throws SQLException { return getCountByStatus(BookingStatus.CANCELLED); }

    // Helper
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {

        Booking b = new Booking();

        b.setBookingId(rs.getInt("booking_id"));

        Timestamp st = rs.getTimestamp("start_time");
        Timestamp et = rs.getTimestamp("end_time");

        if (st != null) b.setStartTime(st.toLocalDateTime());
        if (et != null) b.setEndTime(et.toLocalDateTime());

        b.setStatus(BookingStatus.valueOf(rs.getString("status")));
        b.setAlertSent(rs.getBoolean("alert_sent"));
        b.setUserId(rs.getInt("user_id"));
        b.setSlotId(rs.getInt("slot_id"));
        b.setVehicleNumber(rs.getString("vehicle_number"));

        // booking type
        String bt = rs.getString("booking_type");
        b.setBookingType(bt != null ? BookingType.valueOf(bt) : BookingType.PREBOOK);

        // vehicle type
        String vt = rs.getString("vehicle_type");
        b.setVehicleType(vt != null ? VehicleType.valueOf(vt) : null);

     // estimated_amount
        Object estObj = rs.getObject("estimated_amount");
        b.setEstimatedAmount(estObj != null ? ((Number) estObj).doubleValue() : 0.0);

        // final_amount
        Object finalObj = rs.getObject("final_amount");
        b.setFinalAmount(finalObj != null ? ((Number) finalObj).doubleValue() : 0.0);


        return b;
    }

    public Booking getActivePreBookingByVehicle(String vehicleNumber) throws SQLException {
        String sql = "SELECT * FROM booking " +
                     "WHERE vehicle_number = ? " +
                     "AND status = 'BOOKED' " +
                     "AND end_time >= NOW() " +  
                     "ORDER BY start_time ASC " +
                     "LIMIT 1";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, vehicleNumber);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapResultSetToBooking(rs) : null;
            }
        }
    }

    public Booking getBookingByVehicle(String vehicleNumber) throws SQLException {
        String sql = "SELECT * FROM booking WHERE vehicle_number = ? ORDER BY start_time DESC LIMIT 1";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, vehicleNumber);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapResultSetToBooking(rs) : null;
            }
        }
    }

    public List<BookingViewDTO> getAllBookingsForAdmin() throws SQLException {

        List<BookingViewDTO> list = new ArrayList<>();

        String sql =
            "SELECT " +
            " b.booking_id, " +
            " b.booking_type, " +
            " b.status, " +
            " b.start_time, " +
            " b.end_time, " +
            " b.vehicle_number, " +
            " b.vehicle_type, " +
            " b.guest_name, " +
            " ps.slot_number, " +
            " vr.hourly_rate, " +
            " u.name AS user_name " +
            "FROM booking b " +
            "JOIN parking_slot ps ON b.slot_id = ps.slot_id " +
            "LEFT JOIN users u ON b.user_id = u.id " +    
            "LEFT JOIN vehicle_rate vr ON b.vehicle_type = vr.vehicle_type " +
            "ORDER BY b.start_time DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                BookingViewDTO dto = new BookingViewDTO();

                dto.setBookingId(rs.getInt("booking_id"));
                dto.setBookingType(rs.getString("booking_type"));
                dto.setStatus(BookingStatus.valueOf(rs.getString("status")));

                dto.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());

                Timestamp exitTs = rs.getTimestamp("end_time");
                dto.setEndTime(exitTs != null ? exitTs.toLocalDateTime() : null);

                dto.setVehicleNumber(rs.getString("vehicle_number"));
                dto.setVehicleType(rs.getString("vehicle_type"));
                dto.setSlotNumber(rs.getString("slot_number"));

                // ⭐ PREBOOK vs WALKIN
                dto.setUserName(rs.getString("user_name"));
                dto.setGuestName(rs.getString("guest_name"));

                // ⭐ RATE
                dto.setHourlyRate(rs.getDouble("hourly_rate"));

                list.add(dto);
            }
        }

        return list;
    }

    
    
    public List<BookingViewDTO> getBookingForAdminById(int bookingId) throws SQLException {

        List<BookingViewDTO> list = new ArrayList<>();

        String sql =
            "SELECT b.booking_id, b.start_time, b.end_time, b.status, " +
            "b.vehicle_number, u.name AS user_name, s.slot_number " +
            "FROM booking b " +
            "JOIN users u ON b.user_id = u.id " +
            "JOIN parking_slot s ON b.slot_id = s.slot_id " +
            "WHERE b.booking_id = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BookingViewDTO dto = new BookingViewDTO();
                    dto.setBookingId(rs.getInt("booking_id"));
                    dto.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                    dto.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
                    dto.setStatus(BookingStatus.valueOf(rs.getString("status")));
                    dto.setUserName(rs.getString("user_name"));
                    dto.setVehicleNumber(rs.getString("vehicle_number"));
                    dto.setSlotNumber(rs.getString("slot_number"));
                    list.add(dto);
                }
            }
        }
        return list;
    }

    
    
    public List<BookingViewDTO> getBookingByIdForAdmin(int bookingId)
            throws SQLException {

        List<BookingViewDTO> list = new ArrayList<>();

        String sql =
            "SELECT b.booking_id, b.start_time, b.end_time, b.status, " +
            "b.vehicle_number, u.name AS user_name, s.slot_number " +
            "FROM booking b " +
            "JOIN users u ON b.user_id = u.id " +
            "JOIN parking_slot s ON b.slot_id = s.slot_id " +
            "WHERE b.booking_id = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BookingViewDTO dto = new BookingViewDTO();

                    dto.setBookingId(rs.getInt("booking_id"));
                    dto.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                    dto.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
                    dto.setStatus(BookingStatus.valueOf(rs.getString("status")));
                    dto.setVehicleNumber(rs.getString("vehicle_number"));
                    dto.setUserName(rs.getString("user_name"));
                    dto.setSlotNumber(rs.getString("slot_number"));

                    list.add(dto);
                }
            }
        }

        return list;
    }

    public Map<Integer, Booking> getAllUpcomingBookingsBySlot() throws SQLException {
        Map<Integer, Booking> map = new HashMap<>();

        String sql =
            "SELECT * FROM booking " +
            "WHERE status = 'BOOKED' " +
            "AND start_time > NOW() " +
            "ORDER BY start_time ASC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Booking b = mapResultSetToBooking(rs);
                map.put(b.getSlotId(), b);
            }
        }
        return map;
    }

    
    public Map<Integer, Booking> getAllActiveBookingsBySlot() throws SQLException {
        Map<Integer, Booking> map = new HashMap<>();

        String sql = "SELECT * FROM booking WHERE status = 'ACTIVE'";


        try (Connection con =GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
            	Booking b = mapResultSetToBooking(rs);

                map.put(b.getSlotId(), b);
            }
        }
        return map;
    }



	
    public List<BookingViewDTO> getBookingsForUserView(int userId) throws SQLException {
        List<BookingViewDTO> list = new ArrayList<>();

        String sql =
            "SELECT b.booking_id, b.start_time, b.end_time, b.status, " +
            "b.vehicle_number, b.vehicle_type, " +
            "b.estimated_amount, b.final_amount, " +
            "s.slot_number " +
            "FROM booking b " +
            "JOIN parking_slot s ON b.slot_id = s.slot_id " +
            "WHERE b.user_id = ? " +
            "ORDER BY b.start_time DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingViewDTO dto = new BookingViewDTO();
                    dto.setBookingId(rs.getInt("booking_id"));
                    String statusStr = rs.getString("status");
                    dto.setStatus(BookingStatus.valueOf(statusStr));
                    dto.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                    dto.setEndTime(rs.getTimestamp("end_time") != null
                            ? rs.getTimestamp("end_time").toLocalDateTime()
                            : null);
                    dto.setVehicleNumber(rs.getString("vehicle_number"));
                    dto.setSlotNumber(rs.getString("slot_number"));
                    dto.setVehicleType(rs.getString("vehicle_type"));
                    dto.setEstimatedAmount(rs.getDouble("estimated_amount"));

                    Double finalAmount = rs.getObject("final_amount") != null
                            ? rs.getDouble("final_amount")
                            : null;
                    dto.setFinalAmount(finalAmount);

                   
                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    Timestamp endTime = rs.getTimestamp("end_time");

                    if ((statusStr.equalsIgnoreCase("BOOKED") || statusStr.equalsIgnoreCase("ACTIVE"))
                            && endTime != null
                            && now.after(endTime)) {

                        dto.setStatus(BookingStatus.EXPIRED); 

                        
                        try (PreparedStatement upd = con.prepareStatement(
                                "UPDATE booking SET status = ? WHERE booking_id = ?")) {
                            upd.setString(1, "EXPIRED");
                            upd.setInt(2, dto.getBookingId());
                            upd.executeUpdate();
                        }
                    }
                   
                    if ("BOOKED".equalsIgnoreCase(statusStr)) {
                        Timestamp startTime = rs.getTimestamp("start_time");
                        long minutesLeft = (startTime.getTime() - now.getTime()) / (1000 * 60);
                        boolean penalty = minutesLeft < 30;
                        dto.setPenaltyApplicable(penalty);
                        dto.setPenaltyAmount(penalty ? 10 : 0);
                    } else {
                        dto.setPenaltyApplicable(false);
                        dto.setPenaltyAmount(0);
                    }

                    list.add(dto);
                }
            }
        }

        return list;
    }


    
    public boolean hasOverlap(
            Connection con,
            int slotId,
            LocalDateTime start,
            LocalDateTime end
    ) throws SQLException {

        String sql = "SELECT 1 FROM booking WHERE slot_id = ? AND status IN ('BOOKED', 'ACTIVE')" 
                    + " AND NOT (end_time <= ? OR start_time >= ?) LIMIT 1";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, slotId);
            ps.setTimestamp(2, Timestamp.valueOf(start));
            ps.setTimestamp(3, Timestamp.valueOf(end));

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    
    public boolean updateStatus(
            Connection con,
            int bookingId,
            BookingStatus newStatus,
            ParkingSlotDAO slotDAO
    ) throws SQLException {

        
        String updateSql = "UPDATE booking SET status=? WHERE booking_id=?";
        try (PreparedStatement ps = con.prepareStatement(updateSql)) {
            ps.setString(1, newStatus.name());
            ps.setInt(2, bookingId);

            if (ps.executeUpdate() == 0) {
                return false;
            }
        }

       
        int slotId;
        try (PreparedStatement ps =
                 con.prepareStatement("SELECT slot_id FROM booking WHERE booking_id=?")) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) return false;
            slotId = rs.getInt("slot_id");
        }

       
        slotDAO.syncSlotStatus(con, slotId);

        return true;
    }

  

    public Booking getActivePreBookingByVehicleForUpdate( Connection con,String vehicleNumber) throws SQLException {

        String sql =
            "SELECT * FROM booking " +
            "WHERE vehicle_number = ? " +
            "AND status = 'BOOKED' " +
            "AND start_time <= NOW() " +
            "AND end_time >= NOW() " +
            "FOR UPDATE";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, vehicleNumber);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? mapResultSetToBooking(rs) : null;
            }
        }
    }
    
    public List<BookingViewDTO> getBookingViewsByUserId(int userId) throws SQLException {

        List<BookingViewDTO> list = new ArrayList<>();

        String sql =
            "SELECT b.booking_id AS booking_id, " +
            "       b.start_time, b.end_time, b.status, " +
            "       b.vehicle_number, b.vehicle_type, " +
            "       b.estimated_amount, b.final_amount, " +
            "       p.slot_number, " +
            "       u.name AS user_name " +
            "FROM booking b " +
            "JOIN parking_slot p ON b.slot_id = p.slot_id " +
            "JOIN users u ON b.user_id = u.id " +
            "WHERE b.user_id = ? " +
            "ORDER BY b.start_time DESC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    BookingViewDTO dto = new BookingViewDTO();

                    dto.setBookingId(rs.getInt("booking_id"));
                    dto.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                    dto.setEndTime(rs.getTimestamp("end_time") != null
                            ? rs.getTimestamp("end_time").toLocalDateTime()
                            : null);

                    dto.setStatus(BookingStatus.valueOf(rs.getString("status")));

                    dto.setUserName(rs.getString("user_name"));
                    dto.setVehicleNumber(rs.getString("vehicle_number"));
                    dto.setVehicleType(rs.getString("vehicle_type"));

                    dto.setSlotNumber(rs.getString("slot_number"));

                    dto.setEstimatedAmount(rs.getDouble("estimated_amount"));
                    dto.setFinalAmount(
                            rs.getObject("final_amount") != null
                                    ? rs.getDouble("final_amount")
                                    : null
                    );

                    list.add(dto);
                }
            }
        }

        return list;
    }

   
   
    
    public Booking getBookingById(Connection con, int bookingId) throws SQLException {

        String sql = "SELECT * FROM booking WHERE booking_id = ? FOR UPDATE";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) return null;

            Booking b = new Booking();
            b.setBookingId(rs.getInt("booking_id"));
            b.setSlotId(rs.getInt("slot_id"));
            b.setBookingType(BookingType.valueOf(rs.getString("booking_type")));
            b.setStatus(BookingStatus.valueOf(rs.getString("status")));
            b.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
            b.setEndTime(rs.getTimestamp("end_time").toLocalDateTime());
            b.setVehicleType(VehicleType.valueOf(rs.getString("vehicle_type")));
            return b;
        }
    }

    
    public List<Booking> getExpiredBookings() throws SQLException {
        List<Booking> expiredBookings = new ArrayList<>();

        String sql = "SELECT * FROM booking " +
                     "WHERE status = 'BOOKED' " +
                     "AND start_time < NOW() - INTERVAL 15 MINUTE";

        try (Connection conn = GetConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setStartTime(rs.getTimestamp("start_time").toLocalDateTime());
                b.setEndTime(rs.getTimestamp("end_time") != null ? rs.getTimestamp("end_time").toLocalDateTime() : null);
                b.setStatus(BookingStatus.valueOf(rs.getString("status")));
                b.setUserId(rs.getInt("user_id"));
                b.setSlotId(rs.getInt("slot_id"));
                b.setEstimatedAmount(rs.getDouble("estimated_amount"));
                b.setFinalAmount(rs.getDouble("final_amount"));
                b.setVehicleNumber(rs.getString("vehicle_number"));
                b.setVehicleType(VehicleType.valueOf(rs.getString("vehicle_type")));
                b.setBookingType(BookingType.valueOf(rs.getString("booking_type")));
                expiredBookings.add(b);
            }
        }

        return expiredBookings;
    }

    
    public boolean updateBookingAfterExpiry(Booking b) throws SQLException {
        String sql = "UPDATE booking SET status = ?, final_amount = ? WHERE booking_id = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, b.getStatus().name());
            ps.setDouble(2, b.getFinalAmount());
            ps.setInt(3, b.getBookingId());

            return ps.executeUpdate() > 0;
        }
    }

    
    public void expireBookingWithPenalty(Booking b) throws SQLException {
        try (Connection conn = GetConnection.getConnection()) {
            conn.setAutoCommit(false); 

            try {
             
                String bookingSql = "UPDATE booking SET status=?, final_amount=? WHERE booking_id=?";
                try (PreparedStatement ps = conn.prepareStatement(bookingSql)) {
                    ps.setString(1, BookingStatus.EXPIRED.name());
                    ps.setDouble(2, b.getEstimatedAmount() * 0.5);
                    ps.setInt(3, b.getBookingId());
                    ps.executeUpdate();
                }

              
                String slotSql = "UPDATE parking_slot SET status=? WHERE slot_id=?";
                try (PreparedStatement ps2 = conn.prepareStatement(slotSql)) {
                    ps2.setString(1, SlotStatus.FREE.name());
                    ps2.setInt(2, b.getSlotId());
                    ps2.executeUpdate();
                }

                conn.commit();
            } catch (SQLException e) {
                conn.rollback(); 
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public int processExpiredBookings() throws SQLException {
        List<Booking> expiredBookings = getExpiredBookings();
        int count = 0;

        for (Booking b : expiredBookings) {
            expireBookingWithPenalty(b);
            count++;
        }

        return count;
    }

    
    public int cancelBookingWithPolicy(int bookingId, int userId)
            throws SQLException {

        String selectSql =
            "SELECT start_time, status, slot_id " +
            "FROM booking " +
            "WHERE booking_id = ? AND user_id = ?";

        String updateBookingSql =
            "UPDATE booking SET status = ?, final_amount = ? WHERE booking_id = ?";

        String freeSlotSql =
            "UPDATE parking_slot SET status = 'FREE' WHERE slot_id = ?";

        try (Connection con = GetConnection.getConnection()) {

            con.setAutoCommit(false);

            Timestamp startTime;
            String status;
            int slotId;

           
            try (PreparedStatement ps = con.prepareStatement(selectSql)) {
                ps.setInt(1, bookingId);
                ps.setInt(2, userId);

                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    return -2; 
                }

                startTime = rs.getTimestamp("start_time");
                status = rs.getString("status");
                slotId = rs.getInt("slot_id");
            }

           
            if (!"BOOKED".equalsIgnoreCase(status)) {
                return -2; 
            }

           
            Timestamp now = new Timestamp(System.currentTimeMillis());

          
            if (now.after(startTime) || now.equals(startTime)) {
                return -1; // too late
            }

            
            long diffMillis = startTime.getTime() - now.getTime();
            long minutesLeft = diffMillis / (1000 * 60);

           
            int penalty = (minutesLeft < 30) ? 10 : 0;


           
            try (PreparedStatement ps = con.prepareStatement(updateBookingSql)) {
            	ps.setString(1, BookingStatus.CANCELLED.name());

                ps.setInt(2, penalty);
                ps.setInt(3, bookingId);
                ps.executeUpdate();
            }

           
            try (PreparedStatement ps = con.prepareStatement(freeSlotSql)) {
                ps.setInt(1, slotId);
                ps.executeUpdate();
            }

            con.commit();

           
            return (penalty > 0) ? 2 : 1;

        } catch (SQLException e) {
            throw e;
        }
    }

  
    
    
}
