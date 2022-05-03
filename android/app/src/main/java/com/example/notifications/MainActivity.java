package com.example.notifications;

import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.work.OneTimeWorkRequest;
import androidx.work.WorkManager;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import android.util.Log;
import okhttp3.WebSocket;

public class MainActivity extends FlutterActivity {
    private OkHttpClient client;
    private static final String CHANNEL = "one.two.dev/battery";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                ((call, result) -> {
                    if (call.method.equals("run_code")) {
                        Log.d("start", "going to start service");
                        Intent intent = new Intent(getApplicationContext(), Services.class);
                        startService(intent);
                        // final OneTimeWorkRequest workRequest = new OneTimeWorkRequest.Builder(MyWorker.class).build();
                        // WorkManager.getInstance().enqueue(workRequest);
                        result.success("found");
                    }
                })
        );
    }


}

