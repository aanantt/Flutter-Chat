package com.example.notifications;

import static android.content.Context.MODE_APPEND;
import static android.content.Context.MODE_PRIVATE;

import android.content.Context;
import android.content.SharedPreferences;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import okhttp3.Response;
import okhttp3.WebSocketListener;
import okio.ByteString;


public class CustomWebSocket extends WebSocketListener {
    // private Context context;

    public CustomWebSocket() {
        super();
        // this.context = context;
    }

    public Boolean isSocketOpen = false;

    // SharedPreferences sh = context.getSharedPreferences("MySharedPref", 0);

    @Override
    public void onClosed(@NonNull okhttp3.WebSocket webSocket, int code, @NonNull String reason) {
        isSocketOpen = false;
        // SharedPreferences.Editor editor = sh.edit();
        // editor.putBoolean("isConnected", false);
        Log.i("SOCKET EVENT", "On closed");
    }

    @Override
    public void onClosing(@NonNull okhttp3.WebSocket webSocket, int code, @NonNull String reason) {
        Log.i("SOCKET EVENT", "On closing");
    }

    @Override
    public void onFailure(@NonNull okhttp3.WebSocket webSocket, @NonNull Throwable t, @Nullable Response response) {
        isSocketOpen = false;
        String message = "";
        if (response == null) {
            message = "Null response";
        } else {
            message = response.message();
        }

        // SharedPreferences.Editor editor = sh.edit();
        // editor.putBoolean("isConnected", false);
        Log.i("SOCKET EVENT", t.getMessage());
    }

    @Override
    public void onMessage(@NonNull okhttp3.WebSocket webSocket, @NonNull String text) {
        // jsonDecode()
        //  showNotification();
        Log.i("SOCKET EVENT", "On message string ${text}" + text);

    }

    @Override
    public void onMessage(@NonNull okhttp3.WebSocket webSocket, @NonNull ByteString bytes) {
        Log.i("SOCKET EVENT", "On message bytes");
    }

    @Override
    public void onOpen(@NonNull okhttp3.WebSocket webSocket, @NonNull Response response) {
        isSocketOpen = true;
        // SharedPreferences.Editor editor = sh.edit();
        // editor.putBoolean("isConnected", true);
        Log.i("SOCKET EVENT", "On open");
    }
}


