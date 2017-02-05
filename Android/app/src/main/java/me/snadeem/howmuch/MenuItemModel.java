package me.snadeem.howmuch;

/**
 * Created by Subhan Nadeem on 2017-02-05.
 */

public class MenuItemModel {
    public String getFood_price() {
        return food_price;
    }

    public void setFood_price(String food_price) {
        this.food_price = food_price;
    }

    public String getFood_name() {
        return food_name;
    }

    public void setFood_name(String food_name) {
        this.food_name = food_name;
    }

    private String food_price;
    private String food_name;
}
