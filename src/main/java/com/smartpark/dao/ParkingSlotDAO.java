package com.smartpark.dao;

import com.smartpark.dto.ParkingSlot;
import com.smartpark.dto.SlotStatus;
import com.smartpark.util.GetConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ParkingSlotDAO {

    /* =========================
       CHECK IF SLOT EXISTS
       ========================= */
    public boolean slotExists(String slotNumber) throws SQLException {
        String sql = "SELECT 1 FROM parking_slot WHERE slot_number = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, slotNumber);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    /* =========================
       ADD SLOT
       ========================= */
    public boolean addSlot(ParkingSlot slot) throws SQLException {
        if (slotExists(slot.getSlotNumber())) return false;

        String sql = "INSERT INTO parking_slot(slot_number, status, floor) VALUES (?, ?, ?)";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, slot.getSlotNumber());
            ps.setString(2, slot.getStatus().name());
            ps.setInt(3, slot.getFloor());

            return ps.executeUpdate() > 0;
        }
    }

    /* =========================
       UPDATE SLOT
       ========================= */
    public boolean updateSlot(ParkingSlot slot) throws SQLException {
        String sql = "UPDATE parking_slot SET slot_number=?, status=?, floor=? WHERE slot_id=?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, slot.getSlotNumber());
            ps.setString(2, slot.getStatus().name());
            ps.setInt(3, slot.getFloor());
            ps.setInt(4, slot.getSlotId());

            return ps.executeUpdate() > 0;
        }
    }

    /* =========================
       DELETE SLOT
       ========================= */
    public boolean deleteSlot(int slotId) throws SQLException {
        String sql = "DELETE FROM parking_slot WHERE slot_id = ?";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, slotId);
            return ps.executeUpdate() > 0;
        }
    }

    /* =========================
       STATUS HELPERS (Normal)
       ========================= */
    public boolean markSlotReserved(int slotId) throws SQLException {
        return updateSlotStatus(slotId, SlotStatus.RESERVED);
    }

    public boolean markSlotOccupied(int slotId) throws SQLException {
        return updateSlotStatus(slotId, SlotStatus.OCCUPIED);
    }

    public boolean markSlotFree(int slotId) throws SQLException {
        return updateSlotStatus(slotId, SlotStatus.FREE);
    }

    public boolean updateSlotStatus(int slotId, SlotStatus status) throws SQLException {
        try (Connection con = GetConnection.getConnection()) {
            return updateSlotStatus(con, slotId, status);
        }
    }

    /* =========================
       TRANSACTION-SAFE STATUS HELPERS
       ========================= */
    public boolean markSlotReserved(Connection con, int slotId) throws SQLException {
        return updateSlotStatus(con, slotId, SlotStatus.RESERVED);
    }

    public boolean markSlotOccupied(Connection con, int slotId) throws SQLException {
        return updateSlotStatus(con, slotId, SlotStatus.OCCUPIED);
    }

    public boolean markSlotFree(Connection con, int slotId) throws SQLException {
        return updateSlotStatus(con, slotId, SlotStatus.FREE);
    }

    public boolean updateSlotStatus(Connection con, int slotId, SlotStatus status) throws SQLException {
        String sql = "UPDATE parking_slot SET status=? WHERE slot_id=?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setInt(2, slotId);
            return ps.executeUpdate() > 0;
        }
    }

    /* =========================
       GET FREE SLOTS
       ========================= */
    public List<ParkingSlot> getFreeSlots() throws SQLException {
        return getSlotsByStatus(SlotStatus.FREE);
    }

    public int getFreeSlotsCount() throws SQLException {
        return getFreeSlots().size();
    }

    /* =========================
       CHECK IF SPECIFIC SLOT IS FREE
       ========================= */
    public boolean isSlotFree(int slotId) throws SQLException {
        try (Connection con = GetConnection.getConnection()) {
            return isSlotFree(con, slotId);
        }
    }
    

 public boolean isSlotFree(Connection con, int slotId) throws SQLException {
     String sql = "SELECT status FROM parking_slot WHERE slot_id = ? FOR UPDATE";

     try (PreparedStatement ps = con.prepareStatement(sql)) {
         ps.setInt(1, slotId);
         ResultSet rs = ps.executeQuery();
         return rs.next() &&
        	       SlotStatus.FREE.name().equals(rs.getString("status"));

     }
 }


    /* =========================
       GET SLOTS BY STATUS
       ========================= */
    public List<ParkingSlot> getSlotsByStatus(SlotStatus status) throws SQLException {
        List<ParkingSlot> slots = new ArrayList<>();
        String sql = "SELECT * FROM parking_slot WHERE status=? ORDER BY floor ASC, slot_number ASC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status.name());
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                slots.add(new ParkingSlot(
                        rs.getInt("slot_id"),
                        rs.getString("slot_number"),
                        SlotStatus.valueOf(rs.getString("status").toUpperCase()),
                        rs.getInt("floor")
                ));
            }
        }
        return slots;
    }

    /* =========================
       GET ALL SLOTS
       ========================= */
    public List<ParkingSlot> getAllSlots() throws SQLException {
        List<ParkingSlot> slots = new ArrayList<>();
        String sql = "SELECT * FROM parking_slot ORDER BY floor ASC, slot_number ASC";

        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                slots.add(new ParkingSlot(
                        rs.getInt("slot_id"),
                        rs.getString("slot_number"),
                        SlotStatus.valueOf(rs.getString("status").toUpperCase()),
                        rs.getInt("floor")
                ));
            }
        }
        return slots;
    }

    /* =========================
       GET SLOT BY ID
       ========================= */
    public ParkingSlot getParkingSlotById(int slotId) throws SQLException {
        String sql = "SELECT * FROM parking_slot WHERE slot_id=?";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, slotId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new ParkingSlot(
                        rs.getInt("slot_id"),
                        rs.getString("slot_number"),
                        SlotStatus.valueOf(rs.getString("status").toUpperCase()),
                        rs.getInt("floor")
                );
            }
        }
        return null;
    }

    /* =========================
       SLOT COUNTS
       ========================= */
    public int getTotalSlots() throws SQLException {
        return count("SELECT COUNT(*) FROM parking_slot");
    }

    public int getOccupiedSlots() throws SQLException {
        return count("SELECT COUNT(*) FROM parking_slot WHERE status='OCCUPIED'");
    }

    public int getReservedSlots() throws SQLException {
        return count("SELECT COUNT(*) FROM parking_slot WHERE status='RESERVED'");
    }

    private int count(String sql) throws SQLException {
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    /* =========================
       GET SLOT NUMBER BY ID
       ========================= */
    public String getSlotNumberById(int slotId) throws SQLException {
        String sql = "SELECT slot_number FROM parking_slot WHERE slot_id = ?";
        try (Connection con = GetConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, slotId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("slot_number");
        }
        return "N/A";
    }


    /* =========================
    TRANSACTION-SAFE SLOT SYNC
    ========================= */
    public void syncSlotStatus(Connection con, int slotId) throws SQLException {

       
        String lockSql = "SELECT status FROM parking_slot WHERE slot_id=? FOR UPDATE";
        try (PreparedStatement lockPs = con.prepareStatement(lockSql)) {

            lockPs.setInt(1, slotId);
            ResultSet rsLock = lockPs.executeQuery();
            if (!rsLock.next()) return;

          
            SlotStatus current =
                    SlotStatus.valueOf(rsLock.getString("status").toUpperCase());

          
            String bookingSql =
                "SELECT status FROM booking WHERE slot_id=? " +
                "AND status IN ('ACTIVE','BOOKED') " +
                "ORDER BY status='ACTIVE' DESC LIMIT 1";

            try (PreparedStatement ps = con.prepareStatement(bookingSql)) {

                ps.setInt(1, slotId);
                ResultSet rs = ps.executeQuery();

                SlotStatus newStatus;
                if (rs.next()) {
                    newStatus = "ACTIVE".equals(rs.getString("status"))
                            ? SlotStatus.OCCUPIED
                            : SlotStatus.RESERVED;
                } else {
                    newStatus = SlotStatus.FREE;
                }

               
                if (current != newStatus) {
                    updateSlotStatus(con, slotId, newStatus);
                }
            }
        }
    }



    /* =========================
       USER VIEW SLOTS
       ========================= */
    public List<ParkingSlot> getSlotsForUserView() throws SQLException {
        return getAllSlots();
    }
}
