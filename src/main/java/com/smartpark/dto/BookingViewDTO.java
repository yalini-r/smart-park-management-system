package com.smartpark.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class BookingViewDTO {

    private int bookingId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private BookingStatus status;

    private String userName;
    private String vehicleNumber;
    private String slotNumber;

    private String vehicleType;
    private Double estimatedAmount;
    private Double finalAmount;
    private String bookingType;  
    
   

	private String guestName;  

    private double hourlyRate;
    
    private boolean penaltyApplicable;
    private int penaltyAmount;    
    
    public int getPenaltyAmount() {
        return penaltyAmount;
    }

    public void setPenaltyAmount(int penaltyAmount) {
        this.penaltyAmount = penaltyAmount;
    }

    public boolean isPenaltyApplicable() {
        return penaltyApplicable;
    }

    public void setPenaltyApplicable(boolean penaltyApplicable) {
        this.penaltyApplicable = penaltyApplicable;
    }

    
 

    public String getGuestName() {
		return guestName;
	}
	public void setGuestName(String guestName) {
		this.guestName = guestName;
	}
	public double getHourlyRate() {
		return hourlyRate;
	}
	public void setHourlyRate(double hourlyRate) {
		this.hourlyRate = hourlyRate;
	}
    
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
    public void setStatus(BookingStatus status) {
        this.status = status;
    }

    public String getUserName() {
        return userName;
    }
    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getVehicleNumber() {
        return vehicleNumber;
    }
    public void setVehicleNumber(String vehicleNumber) {
        this.vehicleNumber = vehicleNumber;
    }

    public String getSlotNumber() {
        return slotNumber;
    }
    public void setSlotNumber(String slotNumber) {
        this.slotNumber = slotNumber;
    }
    
    public String getStartTimeFormatted() {
	    if (startTime == null) return "--";
	    return startTime.format(DateTimeFormatter.ofPattern("hh:mm a"));
	}

	public String getEndTimeFormatted() {
	    if (endTime == null) return "--";
	    return endTime.format(DateTimeFormatter.ofPattern("hh:mm a"));
	}
	
	public String getStartDate() {
	    if (startTime == null) return "--";
	    return startTime.toLocalDate()
	                    .format(DateTimeFormatter.ofPattern("dd MMM yyyy"));
	}
	
	
	public String getVehicleType() {
	    return vehicleType;
	}
	public void setVehicleType(String vehicleType) {
	    this.vehicleType = vehicleType;
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

	
	   public String getBookingType() {
	        return bookingType;
	    }

	    public void setBookingType(String bookingType) {
	        this.bookingType = bookingType;
	    }
	
}
