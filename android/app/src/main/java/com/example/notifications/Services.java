package com.example.notifications;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;
import okhttp3.OkHttpClient;
import okhttp3.Request;

public class Services extends Service {
    public Services() {
    }

    @Override
    public void onTaskRemoved(Intent rootIntent) {
        super.onTaskRemoved(rootIntent);
    }

    @Override
    public IBinder onBind(Intent intent) {
        // TODO: Return the communication channel to the service.
        throw new UnsupportedOperationException("Not yet implemented");
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        OkHttpClient client = new OkHttpClient();
        Request request = new Request.Builder().url("ws://192.168.43.86:8080/5").build();
        CustomWebSocket listener = new CustomWebSocket();
        client.newWebSocket(request, listener);
        client.dispatcher().executorService().shutdown();
        return START_STICKY;

    }
   
}