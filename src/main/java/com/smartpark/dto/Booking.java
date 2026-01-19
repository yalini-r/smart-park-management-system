package com.smartpark.dto;

import java.time.LocalDateTime;


public class Booking {
    private int bookingId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private BookingStatus status; // BOOKED, ACTIVE, COMPLETED, CANCELLED , EXPIRED
    private int userId;
    private int slotId;
    private boolean alertSent; 
    private String vehicleNumber;   
      
    private VehicleType vehicleType;
    private double estimatedAmount;
   
	private double finalAmount;
    private BookingType bookingType; //pre-book , walk-in


 
	public int getBookingId() {
        return bookingId;
    }
    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public LocalDateTime getStartTime() {
        return startTime;
    }
    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }

    public LocalDateTime getEndTime() {
        return endTime;
    }
    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }

    public BookingStatus getStatus() {
        return status;
    }
    public void setStatus(BookingStatus booked) {
        this.status = booked;
    }

    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getSlotId() {
        return slotId;
    }
    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public boolean isAlertSent() {
        return alertSent;
    }
    public void setAlertSent(boolean alertSent) {
        this.alertSent = alertSent;
    }
    
    public String getVehicleNumber() {
		return vehicleNumber;
	}
	public void setVehicleNumber(String vehicleNumber) {
		this.vehicleNumber = vehicleNumber;
	}
	

	
	public VehicleType getVehicleType() {
	    return vehicleType;
	}

	public void setVehicleType(VehicleType vehicleType) {
	    this.vehicleType = vehicleType;
	}

	public double getEstimatedAmount() {
	    return estimatedAmount;
	}

	public void setEstimatedAmount(double estimatedAmount) {
	    this.estimatedAmount = estimatedAmount;
	}

	public double getFinalAmount() {
	    return finalAmount;
	}

	public void setFinalAmount(double finalAmount) {
	    this.finalAmount = finalAmount;
	}

	 public BookingType getBookingType() {
			return bookingType;
		}
		public void setBookingType(BookingType bookingType) {
			this.bookingType = bookingType;
		}

	
}
