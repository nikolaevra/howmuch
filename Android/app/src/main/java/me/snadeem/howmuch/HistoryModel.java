package me.snadeem.howmuch;

/**
 * Created by Subhan Nadeem on 2017-02-04.
 */

public class HistoryModel {
    private String lat;
    private String lng;
    private String restaurantName;
    private String moneySpent;
    private String fullness;
private String type;
    public String getLat() {
        return lat;
    }

    public void setLat(String lat) {
        this.lat = lat;
    }

    public String getLng() {
        return lng;
    }

    public void setLng(String lng) {
        this.lng = lng;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    public String getMoneySpent() {
        return moneySpent;
    }

    public void setMoneySpent(String moneySpent) {
        this.moneySpent = moneySpent;
    }

    public String getFullness() {
        return fullness;
    }

    public void setFullness(String fullness) {
        this.fullness = fullness;
    }
}
