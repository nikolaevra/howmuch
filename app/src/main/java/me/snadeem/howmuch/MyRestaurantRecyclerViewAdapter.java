package me.snadeem.howmuch;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.List;

import de.hdodenhof.circleimageview.CircleImageView;


/**
 * specified {@link OnHistoryItemClickListener}.
 * TODO: Replace the implementation with code for your data type.
 */
public class MyRestaurantRecyclerViewAdapter extends RecyclerView.Adapter<MyRestaurantRecyclerViewAdapter.ViewHolder> {

    private final List<RestaurantModel> mValues;
    private final OnRestaurantItemClickListener mListener;

    public MyRestaurantRecyclerViewAdapter(List items, OnRestaurantItemClickListener listener) {
        mValues = items;
        mListener = listener;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.restaurant_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {

        RestaurantModel currentModel = mValues.get(position);
        holder.restaurantNameText.setText(currentModel.getRestaurant_name());
        holder.distanceText.setText(String.valueOf(currentModel.getDistanceToMyLocation()));


        /*holder.mItem = mValues.get(position);
        holder.mIdView.setText(mValues.get(position).id);
        holder.mContentView.setText(mValues.get(position).content);

        holder.mView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null != mListener) {
                    // Notify the active callbacks interface (the activity, if the
                    // fragment is attached to one) that an item has been selected.
                    mListener.onHistoryItemClick(holder.mItem);
                }
            }
        });*/
    }

    @Override
    public int getItemCount() {
        if (mValues == null) return 0;
        return mValues.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        public final View mView;
        public final TextView restaurantNameText;
        public final TextView distanceText;
        public final CircleImageView restaurantPicture;

        public ViewHolder(View view) {
            super(view);
            mView = view;
            restaurantNameText = (TextView) view.findViewById(R.id.restaurantName);
            distanceText = (TextView) view.findViewById(R.id.distanceNum);
            restaurantPicture = (CircleImageView) view.findViewById(R.id.restaurantImage);
        }

        @Override
        public String toString() {
            return super.toString() + " '";
        }
    }
}
