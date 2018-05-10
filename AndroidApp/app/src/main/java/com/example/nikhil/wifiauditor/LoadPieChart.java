package com.example.nikhil.wifiauditor;


import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.data.PieData;
import com.github.mikephil.charting.data.PieDataSet;
import com.github.mikephil.charting.data.PieEntry;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class LoadPieChart extends AppCompatActivity {

    String parsedatavalues;
    ArrayList<Integer> scoreValues = new ArrayList<>();
    ArrayList<String> params = new ArrayList<>();
    private static final String TAG = "LoadPieChart";

    String[] datavalues;

    TextView displayScore;
    TextView securityText;

    ProgressBar EncryptionScore;
    TextView EncryptionScoreText;
    ProgressBar KeystrengthScore;
    TextView KeystrengthScoreText;
    ProgressBar ManufScore;
    TextView ManufScoreText;
    ProgressBar RangeScore;
    TextView RangeScoreText;
    ProgressBar TimingScore;
    TextView TimingScoreText;
    ProgressBar FreqScore;
    TextView FreqScoreText;
    //    ProgressBar SnrScore;
//    TextView SnrScoreText;
    ProgressBar SslScore;
    TextView SslScoreText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_load_pie_chart);
        Log.d(TAG, "onCreate: started");


        displayScore = findViewById(R.id.display_score);
        securityText = findViewById(R.id.security_text);
        EncryptionScore = findViewById(R.id.encryption_score);
        EncryptionScoreText = findViewById(R.id.encryption_score_value);
        KeystrengthScore = findViewById(R.id.keystrength_score);
        KeystrengthScoreText = findViewById(R.id.keystrength_score_value);
        ManufScore = findViewById(R.id.manuf_score);
        ManufScoreText = findViewById(R.id.manuf_score_value);
        RangeScore = findViewById(R.id.range_score);
        RangeScoreText = findViewById(R.id.range_score_value);
        TimingScore = findViewById(R.id.timing_score);
        TimingScoreText = findViewById(R.id.timing_score_value);
        FreqScore = findViewById(R.id.freq_score);
        FreqScoreText = findViewById(R.id.freq_score_value);
//        SnrScore = findViewById(R.id.snr_score);
//        SnrScoreText = findViewById(R.id.snr_score_value);
        SslScore = findViewById(R.id.ssl_score);
        SslScoreText = findViewById(R.id.ssl_score_value);
        getIncomingIntent();

    }

    public void getIncomingIntent(){
        Log.d(TAG, "getIntent: getting intents");

        if(getIntent().hasExtra("scoreName")){
            String filename = getIntent().getStringExtra("scoreName");
            Log.d(TAG, "getIncomingIntent: file name from intent is "+filename);
            getFileContents(filename);
        }

    }

    public void getFileContents(String filename){
        Log.d(TAG, "getFileContents: in function");
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

            Log.d(TAG, "Load Pie chart: read string is : "+sb.toString());
            //displayPrevScores.setText(sb.toString());
            parsedatavalues = sb.toString();


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
        datavalues = parsedatavalues.split("\\.");
        setPiechart(parsedatavalues);
    }

    public void setPiechart(String requiredData) {
        Log.d(TAG, "setPiechart: in function");
        processData(requiredData);
    }

    public void processData(String inputData){
        String[] indivValues = inputData.split("\\.");
        for (int i = 0; i < indivValues.length; i++) {
            Log.d(TAG, "Values" + indivValues[i]);
        }
        //System.out.println(indivValues);
        scoreValues.add(Integer.parseInt(indivValues[0]));
        for(int i = 1; i < 8; i++){
            scoreValues.add(Integer.parseInt(indivValues[i]));
            System.out.println(scoreValues.get(i-1));
        }

        String setTotalScore = indivValues[8];
        displayScore.setText(setTotalScore);

        String setEncryptionScore = indivValues[1]+"/20";
        EncryptionScoreText.setText(setEncryptionScore);
        EncryptionScore.setProgress(Integer.parseInt(indivValues[1]));

        String setKeystrengthScore = indivValues[2]+"/30";
        KeystrengthScoreText.setText(setKeystrengthScore);
        KeystrengthScore.setProgress(Integer.parseInt(indivValues[2]));

        String setManufScore = indivValues[3]+"/5";
        ManufScoreText.setText(setManufScore);
        ManufScore.setProgress(Integer.parseInt(indivValues[3]));

        String setRangeScore = indivValues[4]+"/10";
        RangeScoreText.setText(setRangeScore);
        RangeScore.setProgress(Integer.parseInt(indivValues[4]));

        String setTimingScore = indivValues[5]+"/15";
        TimingScoreText.setText(setTimingScore);
        TimingScore.setProgress(Integer.parseInt(indivValues[5]));

        String setFreqScore = indivValues[6]+"/10";
        FreqScoreText.setText(setFreqScore);
        FreqScore.setProgress(Integer.parseInt(indivValues[6]));

//        String setSnrScore = indivValues[7]+"/5";
//        SnrScoreText.setText(setSnrScore);
//        SnrScore.setProgress(Integer.parseInt(indivValues[7]));

        String setSslScore = indivValues[7]+"/10";
        SslScoreText.setText(setSslScore);
        SslScore.setProgress(Integer.parseInt(indivValues[7]));

        setupPiechart();
        Drawable draw = getResources().getDrawable(R.drawable.customprogressbar);
        EncryptionScore.setProgressDrawable(draw);

    }

    public void setupPiechart() {
        params.add("Total Score");
        params.add("Encryption Score");
        params.add("Key Strength");
        params.add("Manufacturer");
        params.add("Range");
        params.add("Timing");
        params.add("Frequency");
        //params.add("SNR");
        params.add("SSL");
        List<PieEntry> pieEntries = new ArrayList<>();
        for(int i = 1; i < scoreValues.size(); i++){
            pieEntries.add(new PieEntry(scoreValues.get(i),params.get(i)));
            //System.out.println("scoreValues"+scoreValues.get(i));
            //System.out.println("param values"+params.get(i));
        }

        PieDataSet dataSet = new PieDataSet(pieEntries, "");
        dataSet.setColors(MATERIAL_COLORS);
        dataSet.setSliceSpace(2);
        dataSet.setValueTextSize(12);
        PieData data = new PieData(dataSet);

        PieChart chart = (PieChart) findViewById(R.id.pie_chart);

        chart.getLegend().setWordWrapEnabled(true);
        chart.getLegend().setTextSize(12);
        chart.getLegend().setTextColor(Color.WHITE);
        chart.setDrawSliceText(false);
        chart.getDescription().setEnabled(false);
        chart.setHoleColor(R.color.material_dark);
        chart.setHoleRadius(30f);
        chart.setTransparentCircleAlpha(0);
        chart.setCenterText(datavalues[0]);
        if(datavalues[9].equals("Secure")){
            chart.setCenterTextColor(0xff64DD17);
            securityText.setTextColor(0xff64DD17);
            securityText.setText("Secure");
        }
        else if (datavalues[9].equals("Not Secure")){
            chart.setCenterTextColor(0xffF44336);
            securityText.setTextColor(0xffF44336);
            securityText.setText("Not Secure");
        }
        else{
            chart.setCenterTextColor(0xffff8000);
            securityText.setTextColor(0xffff8000);
            securityText.setText("Moderately Secure");
        }
        chart.setCenterTextSize(40);
        chart.setData(data);
        chart.animateY(1000);
        chart.invalidate();


    }

    public static final int[] MATERIAL_COLORS = {
            rgb("#2ecc71"), rgb("#f1c40f"), rgb("#e74c3c"), rgb("#3498db"),
            rgb("#e91e63"), rgb("##ab47bc"), rgb("#607d8b"), rgb("#558b2f")
    };

    public static int rgb(String hex) {
        int color = (int) Long.parseLong(hex.replace("#", ""), 16);
        int r = (color >> 16) & 0xFF;
        int g = (color >> 8) & 0xFF;
        int b = (color >> 0) & 0xFF;
        return Color.rgb(r, g, b);
    }
}

