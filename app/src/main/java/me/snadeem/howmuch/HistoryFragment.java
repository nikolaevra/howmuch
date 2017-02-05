package me.snadeem.howmuch;

import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.database.DataSnapshot;
import com.google.firebase.database.DatabaseError;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;
import com.google.firebase.database.ValueEventListener;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

/**
 * A fragment representing a list of Items.
 * <p/>
 * Activities containing this fragment MUST implement the {@link OnHistoryItemClickListener}
 * interface.
 */
public class HistoryFragment extends Fragment implements OnHistoryItemClickListener {

    // TODO: Customize parameter argument names
    private static final String ARG_COLUMN_COUNT = "column-count";
    // TODO: Customize parameters
    private int mColumnCount = 1;
    private OnHistoryItemClickListener mListener;
    List<HistoryModel> historyList;
    private MyHistoryRecyclerViewAdapter mAdapter;

    /**
     * Mandatory empty constructor for the fragment manager to instantiate the
     * fragment (e.g. upon screen orientation changes).
     */
    public HistoryFragment() {
    }

    // TODO: Customize parameter initialization
    @SuppressWarnings("unused")
    public static HistoryFragment newInstance(int columnCount) {
        HistoryFragment fragment = new HistoryFragment();
        Bundle args = new Bundle();
        args.putInt(ARG_COLUMN_COUNT, columnCount);
        fragment.setArguments(args);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (getArguments() != null) {
            mColumnCount = getArguments().getInt(ARG_COLUMN_COUNT);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_history, container, false);
        historyList = new ArrayList<>();

        // Set the adapter
            RecyclerView recyclerView = (RecyclerView) view.findViewById(R.id.historyList);
            if (mColumnCount <= 1) {
                recyclerView.setLayoutManager(new LinearLayoutManager(getContext()));
            } else {
                recyclerView.setLayoutManager(new GridLayoutManager(getContext(), mColumnCount));
            }

            mAdapter = new MyHistoryRecyclerViewAdapter(historyList, mListener);
            recyclerView.setAdapter(mAdapter);
            recyclerView.addItemDecoration(new DividerItemDecoration(getActivity(),
                    DividerItemDecoration.VERTICAL));
            retrieveHistoryFromServer();

        return view;
    }

    private void retrieveHistoryFromServer() {
        DatabaseReference mDatabase = FirebaseDatabase.getInstance().getReference();
        DatabaseReference testHistory
                = mDatabase.child("history").child(FirebaseAuth.getInstance().getCurrentUser().getUid()).orderByChild("timestamp").getRef();

        testHistory.addValueEventListener(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                Iterator eventIterator = dataSnapshot.getChildren().iterator();
                while (eventIterator.hasNext()) {
                    DataSnapshot eventSnap = (DataSnapshot) eventIterator.next();

                    Iterator specificEventIterator = eventSnap.getChildren().iterator();

                    HashMap<String, String> map = new HashMap<>();
                    while (specificEventIterator.hasNext()) {
                        DataSnapshot specificEventSnap = (DataSnapshot) specificEventIterator.next();
                        map.put(specificEventSnap.getKey(), specificEventSnap.getValue().toString());
                    }
                    Gson gson = new Gson();
                    String jsonString = gson.toJson(map);
                    HistoryModel historyModel = gson.fromJson(jsonString, HistoryModel.class);
                    historyList.add(historyModel);
                    mAdapter.notifyDataSetChanged();
                }
            }

            @Override
            public void onCancelled(DatabaseError databaseError) {

            }
        });

    }


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof OnHistoryItemClickListener) {
            mListener = (OnHistoryItemClickListener) context;
        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnHistoryItemClickListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    @Override
    public void onHistoryItemClick() {

    }
}
