package me.snadeem.howmuch;

/**
 * Created by Subhan Nadeem on 2017-02-05.
 */

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.text.DecimalFormat;
import java.util.List;

public class MenuAdapter extends RecyclerView.Adapter<MenuAdapter.ViewHolder> {

    private final List<MenuItemModel> mValues;

    public MenuAdapter(List items) {
        mValues = items;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.menu_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {
        MenuItemModel model = mValues.get(position);
        holder.foodName.setText(model.getFood_name());
        holder.foodPrice.setText((new DecimalFormat("0.00")).format(Double.parseDouble(model.getFood_price())));
    }

    @Override
    public int getItemCount() {
        if (mValues == null) return 0;
        return mValues.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        public final View mView;
        public final TextView foodName;
        public final TextView foodPrice;

        public ViewHolder(View view) {
            super(view);
            mView = view;
            foodName = (TextView) view.findViewById(R.id.foodName);
            foodPrice = (TextView) view.findViewById(R.id.foodPrice);
        }

        @Override
        public String toString() {
            return super.toString() + " '";
        }
    }
}

