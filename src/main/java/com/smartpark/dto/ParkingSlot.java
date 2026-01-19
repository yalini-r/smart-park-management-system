package com.smartpark.dto;

public class ParkingSlot {

    private int slotId;
    private String slotNumber;
    private SlotStatus status;   //FREE, RESERVED , OCCUPIED  
    private int floor;             // floor =1 , floor=2 , floor=3 , floor=4.

    public ParkingSlot() {}

    public ParkingSlot(int slotId, String slotNumber, SlotStatus status, int floor) {
        this.slotId = slotId;
        this.slotNumber = slotNumber;
        this.status = status;
        this.floor = floor;
    }

    public ParkingSlot(String slotNumber, SlotStatus status, int floor) {
        this.slotNumber = slotNumber;
        this.status = status;
        this.floor = floor;
    }

    public int getSlotId() {
        return slotId;
    }

    public void setSlotId(int slotId) {
        this.slotId = slotId;
    }

    public String getSlotNumber() {
        return slotNumber;
    }

    public void setSlotNumber(String slotNumber) {
        this.slotNumber = slotNumber;
    }

    public SlotStatus getStatus() {
        return status;
    }

    public void setStatus(SlotStatus status) {
        this.status = status;
    }

    public int getFloor() {
        return floor;
    }

    public void setFloor(int floor) {
        this.floor = floor;
    }
    
    public boolean isFree() {
        return status == SlotStatus.FREE;
    }

}
