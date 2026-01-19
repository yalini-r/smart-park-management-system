package com.smartpark.dto;

public class ExitStats {

    private int total;
    private int longStay;
    private int overstay;
    private double revenue;
    private int exited;

    public int getExited() { return exited; }
    public void setExited(int exited) { this.exited = exited; }


    public int getTotal() { return total; }
    public void setTotal(int total) { this.total = total; }

    public int getLongStay() { return longStay; }
    public void setLongStay(int longStay) { this.longStay = longStay; }

    public int getOverstay() { return overstay; }
    public void setOverstay(int overstay) { this.overstay = overstay; }

    public double getRevenue() { return revenue; }
    public void setRevenue(double revenue) { this.revenue = revenue; }
}
