package com.example.nikhil.wifiauditor;


import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;

import java.io.BufferedReader;
import java.io.FileInputStream;
//import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;


//import static com.example.nikhil.firstapp.StartWifiAuditing.FILENAME;

public class LoadPreviousScores extends AppCompatActivity {

    private static final String TAG = "LoadPreviousScores";

    ArrayList<String> mScore_values = new ArrayList<>();
    ArrayList<String> mScore_name = new ArrayList<>();
    ArrayList<String> mScore_security = new ArrayList<>();


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_load_previous_scores);
        Log.d(TAG, "onCreate: started");
        initValues();

    }

    private void initValues(){
        Log.d(TAG, "initRecyclerView: preparing views");

        String[] filelist = fileList();

        for(String files: filelist){
            System.out.println("These are the files  "+files);

            Log.d(TAG, "initValues: These are the files  "+files);
        }

        Log.d(TAG, " filelist is : "+filelist);
        for (String aFilelist : filelist) {

            String filename = aFilelist;
            Log.d(TAG, " filename  "+filename);
            System.out.println("filename is  : "+filename);
            FileInputStream fis = null;

            try {
                fis = openFileInput(filename);
                InputStreamReader isr = new InputStreamReader(fis);
                BufferedReader br = new BufferedReader(isr);
                StringBuilder sb = new StringBuilder();
                String text;

                while ((text = br.readLine()) != null) {
                    sb.append(text).append("\n");
                }

                Log.d(TAG, "initValues: read string is : "+sb.toString());
                //displayPrevScores.setText(sb.toString());
                String[] indivDataVals = sb.toString().split("\\.");
                Log.d(TAG, "initValues: indiv vals : "+indivDataVals);
                mScore_values.add(indivDataVals[0]);
                mScore_name.add(indivDataVals[8]);
                mScore_security.add(indivDataVals[9]);


            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (fis != null) {
                    try {
                        fis.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        initRecyclerView();
    }

    private void initRecyclerView() {
        Log.d(TAG, "initRecyclerView: init recycler view");
        RecyclerView recyclerView = findViewById(R.id.recycler_view);
        RecyclerViewAdapter adapter = new RecyclerViewAdapter(mScore_values, mScore_name, mScore_security, this);
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(recyclerView.getContext()));
        DividerItemDecoration itemDecor = new DividerItemDecoration(recyclerView.getContext(), DividerItemDecoration.VERTICAL);
        //itemDecor.setDrawable(ContextCompat.getDrawable(this,R.drawable.border));
        recyclerView.addItemDecoration(itemDecor);
    }


}

