package me.snadeem.howmuch;

import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.List;


/**
 * specified {@link OnHistoryItemClickListener}.
 * TODO: Replace the implementation with code for your data type.
 */
public class MyHistoryRecyclerViewAdapter extends RecyclerView.Adapter<MyHistoryRecyclerViewAdapter.ViewHolder> {

    private final List<HistoryModel> mValues;
    private final OnHistoryItemClickListener mListener;

    public MyHistoryRecyclerViewAdapter(List items, OnHistoryItemClickListener listener) {
        mValues = items;
        mListener = listener;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext())
                .inflate(R.layout.history_item, parent, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {

        HistoryModel currentModel = mValues.get(position);
        holder.restaurantNameText.setText(currentModel.getRestaurantName());
        holder.moneySpentText.setText(currentModel.getMoneySpent());
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
        public final TextView moneySpentText;
        public final TextView typeText;

        public ViewHolder(View view) {
            super(view);
            mView = view;
            restaurantNameText = (TextView) view.findViewById(R.id.restaurantName);
            moneySpentText = (TextView) view.findViewById(R.id.moneySpentText);
            typeText = (TextView) view.findViewById(R.id.restaurantType);
        }

        @Override
        public String toString() {
            return super.toString() + " '";
        }
    }
}
