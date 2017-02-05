package me.snadeem.howmuch;

import java.util.ArrayList;

/**
 * Created by Subhan Nadeem on 2017-02-04.
 */

public class RestaurantModel {
    private String lon;
    private String lat;
    private String phone;
    private String restaurant_name;
    private ArrayList<String> address;
    private ArrayList<MenuItemModel> menu_items;
    private double distanceToMyLocation;

    public ArrayList<MenuItemModel> getMenu_items() {
        return menu_items;
    }

    public void setMenu_items(ArrayList<MenuItemModel> menu_items) {
        this.menu_items = menu_items;
    }

    public double getDistanceToMyLocation() {
        return distanceToMyLocation;
    }

    public void setDistanceToMyLocation(double distanceToMyLocation) {
        this.distanceToMyLocation = distanceToMyLocation;
    }

    public String getLon() {
        return lon;
    }

    public void setLon(String lon) {
        this.lon = lon;
    }

    public String getLat() {
        return lat;
    }

    public void setLat(String lat) {
        this.lat = lat;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRestaurant_name() {
        return restaurant_name;
    }

    public void setRestaurant_name(String restaurant_name) {
        this.restaurant_name = restaurant_name;
    }

    public ArrayList<String> getAddress() {
        return address;
    }

    public void setAddress(ArrayList<String> address) {
        this.address = address;
    }

    public ArrayList<MenuItemModel> etMenu_items() {
        return menu_items;
    }
}
