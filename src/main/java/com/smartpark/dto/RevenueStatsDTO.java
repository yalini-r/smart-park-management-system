package com.smartpark.dto;

public class RevenueStatsDTO {

    // Pre-Booked Stats
    private double preBookToday;
    private double preBookWeek;
    private double preBookMonth;
    private double preBookTotal;

    // Walk-In Stats
    private double walkinToday;
    private double walkinWeek;
    private double walkinMonth;
    private double walkinTotal;



    public double getPreBookToday() {
        return preBookToday;
    }

    public void setPreBookToday(double preBookToday) {
        this.preBookToday = preBookToday;
    }

    public double getPreBookWeek() {
        return preBookWeek;
    }

    public void setPreBookWeek(double preBookWeek) {
        this.preBookWeek = preBookWeek;
    }

    public double getPreBookMonth() {
        return preBookMonth;
    }

    public void setPreBookMonth(double preBookMonth) {
        this.preBookMonth = preBookMonth;
    }

    public double getPreBookTotal() {
        return preBookTotal;
    }

    public void setPreBookTotal(double preBookTotal) {
        this.preBookTotal = preBookTotal;
    }

    public double getWalkinToday() {
        return walkinToday;
    }

    public void setWalkinToday(double walkinToday) {
        this.walkinToday = walkinToday;
    }

    public double getWalkinWeek() {
        return walkinWeek;
    }

    public void setWalkinWeek(double walkinWeek) {
        this.walkinWeek = walkinWeek;
    }

    public double getWalkinMonth() {
        return walkinMonth;
    }

    public void setWalkinMonth(double walkinMonth) {
        this.walkinMonth = walkinMonth;
    }

    public double getWalkinTotal() {
        return walkinTotal;
    }

    public void setWalkinTotal(double walkinTotal) {
        this.walkinTotal = walkinTotal;
    }
}
