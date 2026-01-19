package com.smartpark.dto;

public class VehicleRate {

    private VehicleType vehicleType;
    private double hourlyRate;
    private double nightMultiplier;
    private double weekendMultiplier;

    public VehicleRate(VehicleType type, double hourly, double night, double weekend) {
        this.vehicleType = type;
        this.hourlyRate = hourly;
        this.nightMultiplier = night;
        this.weekendMultiplier = weekend;
    }


    public VehicleType getVehicleType() {
        return vehicleType;
    }

    public double getHourlyRate() {
        return hourlyRate;
    }

    public double getNightMultiplier() {
        return nightMultiplier;
    }

    public double getWeekendMultiplier() {
        return weekendMultiplier;
    }
}
