package com.detection.emotion.emotionrecognition;

import android.content.pm.PackageManager;
import android.hardware.Camera;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.JsonHttpResponseHandler;
import com.loopj.android.http.TextHttpResponseHandler;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import cz.msebera.android.httpclient.Header;
import cz.msebera.android.httpclient.entity.ByteArrayEntity;


public class MainActivity extends AppCompatActivity implements SurfaceHolder.Callback {

    private Camera camera;
    SurfaceHolder holder;
    SurfaceView surfaceView;
    TextView myTextView;
    boolean running = false;
    Thread myThread;


    Camera.PictureCallback jpegCallback = new Camera.PictureCallback() {
        @Override
        public void onPictureTaken(byte[] data, Camera camera) {
            AsyncHttpClient client = new AsyncHttpClient();
            client.addHeader("Ocp-Apim-Subscription-Key", "e9100617078f4454a9d132b8ff4d930f");
            client.post(getApplicationContext(), "https://westus.api.cognitive.microsoft.com/emotion/v1.0/recognize", null, new ByteArrayEntity(data), "application/octet-stream", new JsonHttpResponseHandler() {

                @Override
                public void onFailure(int statusCode, Header[] headers, String responseString, Throwable throwable) {
                    myTextView.setText("Error");
                }

                @Override
                public void onSuccess(int statusCode, Header[] headers, JSONArray responseString) {
                    try {
                        Map<Double,String> emotions = new HashMap<Double, String>();
                        emotions.put(responseString.getJSONObject(0).getJSONObject("scores").getDouble("disgust"),"Disgust");
                        emotions.put(responseString.getJSONObject(0).getJSONObject("scores").getDouble("sadness"),"Sad");
                        emotions.put(responseString.getJSONObject(0).getJSONObject("scores").getDouble("contempt"), "Contempt");
                        emotions.put(responseString.getJSONObject(0).getJSONObject("scores").getDouble("anger"), "Angry");
                        emotions.put(responseString.getJSONObject(0).getJSONObject("scores").getDouble("happiness"), "Happy");
                        emotions.put(responseString.getJSONObject(0).getJSONObject("scores").getDouble("neutral"), "Neutral");
                        emotions.put(responseString.getJSONObject(0).getJSONObject("scores").getDouble("surprise"), "Surprise");
                        emotions.put(responseString.getJSONObject(0).getJSONObject("scores").getDouble("fear"), "Fear");

                        myTextView.setText(emotions.get(Collections.max(emotions.keySet())));


                    } catch (JSONException e) {
                        //emotion not recognised
                        myTextView.setText("Emotion Undetected");
                        Log.d("Here", "Here");
                    }
                }
            });
            refreshCamera();
        }
    };


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        if(!getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA)){
            Toast.makeText(this, "No Camera Detected", Toast.LENGTH_LONG).show();
        } else {

            if(Camera.getNumberOfCameras() < 2){
                Toast.makeText(this, "No Front Facing Camera Detected", Toast.LENGTH_LONG).show();
            }

        }

        surfaceView = (SurfaceView) findViewById(R.id.surfaceView);
        holder = surfaceView.getHolder();
        holder.addCallback(this);
        holder.setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS);

        myTextView = (TextView) findViewById(R.id.textView);



    }

    public void refreshCamera() {
        if (holder.getSurface() == null) {
            return;
        }
        try {
            camera.stopPreview();
        } catch (Exception e) {
            // ignore: tried to stop a non-existent preview
        }

        try {
            camera.setPreviewDisplay(holder);
            camera.startPreview();
        } catch (Exception e) {

        }
    }

    public void Start(View view) {

        Runnable autoCamera = new Runnable() {
            @Override
            public void run() {
                while (running){
                    try {
                        camera.takePicture(null, null, jpegCallback);
                        Thread.sleep(3000);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                        running = false;
                    }
                }
            }
        };

        myThread = new Thread(autoCamera);
        myThread.start();
        running = true;

    }

    public void Stop(View view) {
        if(myThread != null)
            myThread.interrupt();

    }

    @Override
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height) {

        refreshCamera();
    }

    @Override
    public void surfaceCreated(SurfaceHolder holder) {

        try {
            camera = Camera.open(2);
            camera.setPreviewDisplay(holder);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void surfaceDestroyed(SurfaceHolder holder) {
        camera.stopPreview();
        camera.release();
    }



}
