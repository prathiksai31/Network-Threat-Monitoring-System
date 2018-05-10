package com.example.nikhil.wifiauditor;

import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import java.util.ArrayList;

public class RecyclerViewAdapter extends RecyclerView.Adapter<RecyclerViewAdapter.ViewHolder> {

    private static final String TAG = "RecyclerViewAdapter";

    ArrayList<String> mScoreValues = new ArrayList<>();
    ArrayList<String> mScorename;
    ArrayList<String> mScoreSecurity = new ArrayList<>();
    Context mContext;

    public RecyclerViewAdapter(ArrayList<String> mScoreValues, ArrayList<String> mScorename, ArrayList<String> mScoreSecurity, Context mContext) {
        this.mScoreValues = mScoreValues;
        this.mScorename = mScorename;
        this.mScoreSecurity = mScoreSecurity;
        this.mContext = mContext;
    }

    @NonNull
    @Override
    public ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.layout_listitem, parent, false);
        ViewHolder holder = new ViewHolder(view);
        return holder;
    }

    @Override
    public void onBindViewHolder(@NonNull ViewHolder holder, final int position) {
        Log.d(TAG, "onBindViewHolder: called");
        holder.scoreValue.setText(mScoreValues.get(position));
        holder.scoreName.setText(mScorename.get(position));
        holder.scoreSecurity.setText(mScoreSecurity.get(position));
        Log.d(TAG, "onBindViewHolder: Score Security names :"+mScoreSecurity.get(position));
        if(mScoreSecurity.get(position).equals("Secure")){
            holder.scoreSecurity.setTextColor(0xFF64DD17);
            holder.scoreValue.setBackground(ContextCompat.getDrawable(mContext, R.drawable.rounded_textview));
        }

        else if(mScoreSecurity.get(position).equals("Not Secure")){
            holder.scoreSecurity.setTextColor(0xFFF44336);
            holder.scoreValue.setBackground(ContextCompat.getDrawable(mContext, R.drawable.rounded_textview_red));
        }
        else{
            holder.scoreSecurity.setTextColor(0xFFff8000);
            holder.scoreValue.setBackground(ContextCompat.getDrawable(mContext, R.drawable.rounded_textview_yellow));
        }


        holder.parentLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Log.d(TAG, "onClick: clicked on"+mScorename.get(position));
                Intent intent = new Intent(mContext, LoadPieChart.class);
                intent.putExtra("scoreName", mScorename.get(position));
                mContext.startActivity(intent);
            }
        });


    }

    @Override
    public int getItemCount() {
        return mScorename.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder{

        TextView scoreValue;
        TextView scoreName;
        TextView scoreSecurity;
        RelativeLayout parentLayout;

        public ViewHolder(View itemView) {
            super(itemView);
            scoreName = itemView.findViewById(R.id.score_name);
            scoreValue = itemView.findViewById(R.id.score_value);
            scoreSecurity = itemView.findViewById(R.id.score_security);
            parentLayout = itemView.findViewById(R.id.parent_layout);
        }
    }
}

