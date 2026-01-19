package com.smartpark.dto;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class VehicleExitViewDTO {

    private int vehicleId;
    private String numberPlate;
    private VehicleType vehicleType;

    private LocalDateTime entryTime;
    private LocalDateTime bookingEndTime;
    private LocalDateTime exitTime;

    private BookingType bookingType;   
    private String userName;

    private int floor;
    private String slotNumber;

 
    private Double estimatedAmount;   
    private Double finalAmount;         


    private boolean overstay;
    private boolean longStay;
    
    private LocalDateTime bookingStartTime;
    private String bookingStatus;
    

    private int slotId;
    private int bookingId;


    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    
    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }


   
    public LocalDateTime getBookingStartTime() { return bookingStartTime; }
    public void setBookingStartTime(LocalDateTime bookingStartTime) { this.bookingStartTime = bookingStartTime; }

    public String getBookingStatus() { return bookingStatus; }
    public void setBookingStatus(String bookingStatus) { this.bookingStatus = bookingStatus; }


    // =================== GETTERS & SETTERS ===================

    public int getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(int vehicleId) {
        this.vehicleId = vehicleId;
    }

    public String getNumberPlate() {
        return numberPlate;
    }

    public void setNumberPlate(String numberPlate) {
        this.numberPlate = numberPlate;
    }

    public VehicleType getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(VehicleType vehicleType) {
        this.vehicleType = vehicleType;
    }

    /*
     * =========================================================
     * JSP-FRIENDLY TIME GETTERS
     * These return Timestamp so <fmt:formatDate> works
     * =========================================================
     */

    public Timestamp getEntryTime() {
        return entryTime == null ? null : Timestamp.valueOf(entryTime);
    }

    public Timestamp getBookingEndTime() {
        return bookingEndTime == null ? null : Timestamp.valueOf(bookingEndTime);
    }

    public Timestamp getExitTime() {
        return exitTime == null ? null : Timestamp.valueOf(exitTime);
    }

    /*
     * =========================================================
     * INTERNAL SETTERS (use LocalDateTime)
     * =========================================================
     */

    public void setEntryTime(LocalDateTime entryTime) {
        this.entryTime = entryTime;
    }

    public void setBookingEndTime(LocalDateTime bookingEndTime) {
        this.bookingEndTime = bookingEndTime;
    }

    public void setExitTime(LocalDateTime exitTime) {
        this.exitTime = exitTime;
    }

    public BookingType getBookingType() {
        return bookingType;
    }

    public void setBookingType(BookingType bookingType) {
        this.bookingType = bookingType;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getFloor() {
        return floor;
    }

    public void setFloor(int floor) {
        this.floor = floor;
    }

    public String getSlotNumber() {
        return slotNumber;
    }

    public void setSlotNumber(String slotNumber) {
        this.slotNumber = slotNumber;
    }

    public Double getEstimatedAmount() {
        return estimatedAmount;
    }

    public void setEstimatedAmount(Double estimatedAmount) {
        this.estimatedAmount = estimatedAmount;
    }

    public Double getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(Double finalAmount) {
        this.finalAmount = finalAmount;
    }

    public boolean isOverstay() {
        return overstay;
    }

    public void setOverstay(boolean overstay) {
        this.overstay = overstay;
    }

    public boolean isLongStay() {
        return longStay;
    }

    public void setLongStay(boolean longStay) {
        this.longStay = longStay;
    }

 
    LocalDateTime getBookingEndTimeInternal() {
        return bookingEndTime;
    }
    
    public LocalDateTime getEntryTimeLocal() {
        return entryTime;
    }

    public LocalDateTime getBookingEndTimeLocal() {
        return bookingEndTime;
    }
}
