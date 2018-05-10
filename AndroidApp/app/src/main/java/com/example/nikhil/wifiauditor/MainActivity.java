package com.example.nikhil.wifiauditor;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;


public class MainActivity extends AppCompatActivity {

    TextView tvData;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        tvData =  findViewById(R.id.tv_data);
    }



    public void startButton(View v){
        Intent intent = new Intent(this, StartWifiAuditing.class);
        startActivity(intent);
    }

    public void loadButton(View v){
        Intent intent = new Intent(this, LoadPreviousScores.class);
        startActivity(intent);
    }

}
