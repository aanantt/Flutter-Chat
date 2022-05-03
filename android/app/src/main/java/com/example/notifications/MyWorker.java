package com.example.notifications;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

import okhttp3.OkHttpClient;
import okhttp3.Request;

public class MyWorker extends Worker {
    // public Context context;
     

    public MyWorker(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
        // this.context = context;
    }

    @NonNull
    @Override
    public Result doWork() {
        // SharedPreferences sh = context.getSharedPreferences("MySharedPref", 0);
        // SharedPreferences.Editor editor = sh.edit();
        for (int i = 0; i < 900; i++) {
            try {
                Thread.sleep(1000);
                // if (!sh.getBoolean("isConnected", false)) {
                //     OkHttpClient client = new OkHttpClient();
                //     Request request = new Request.Builder().url("ws://localhost:8080").build();
                //     CustomWebSocket listener = new CustomWebSocket(context);
                //     client.newWebSocket(request, listener);
                //     client.dispatcher().executorService().shutdown();
                // }
            } catch (Exception e) {
                Log.d("error", "Error in work manager loop");
            }

        }

        return Result.success();
    }
}