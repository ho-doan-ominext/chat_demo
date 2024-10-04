package com.example.chat_app

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationCompat.PRIORITY_DEFAULT
import androidx.core.app.NotificationManagerCompat
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import org.json.JSONObject
import java.io.OutputStreamWriter
import java.net.Socket
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val bundle = intent.extras

        if (bundle?.getString("payload") != null) {
            android.util.Log.e(
                MainActivity::class.simpleName,
                "onCreate: ${bundle.getString("payload")}",
            )

            flutterEngine?.dartExecutor?.executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault())
            flutterEngine?.dartExecutor?.let {
                MethodChannel(it.binaryMessenger, "com.example.chat_app.native")
                    .invokeMethod("nativeCallback", bundle.getString("payload"))
            }
        }

        val intent = Intent(this, PushNotificationService::class.java)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }
}

class PushNotificationService : Service() {
    private val context = this
    private var notifyManagerId = 1

    override fun onCreate() {
        super.onCreate()
        startForeground()
    }

    private fun startForeground() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createNotificationChannel(context)
        }
        createSocket()
    }

    private fun connectSocket() {
        try {
            val serverIp = "10.99.62.215"
            val port = 2909

            val socket = Socket(serverIp, port)
            val writer = OutputStreamWriter(socket.getOutputStream())

            // Register device
            val registerMessage = JSONObject()
            /**
             * "content": "string",
             *   "sendId": "4",
             *   "reciveId": "6",
             *   "token": "string"
             */
            registerMessage.put("Message", "register")
            // ID user
            registerMessage.put("SendId", "6")
            registerMessage.put("ReceiveId", "")
            writer.write(registerMessage.toString())
            android.util.Log.e("////////", "connectSocket: ${registerMessage.toString()}")
            writer.flush()

            var str = ""
            while (true) {
                val data = socket.getInputStream().read()
//                if(str == "" && socket.getInputStream().available() == 0)return;
                str += data.toChar()
                if (socket.getInputStream().available() == 0) {
                    android.util.Log.e("///", "onReceive: $str")
                    if(str.isNotBlank()) {
                        showNotification(str)
                        str = ""
                    }
                }
            }
        } catch (e: Exception) {
            Log.e("PushNotificationReceiver", "Socket communication error", e)
            Log.e("PushNotificationReceiver", "reconnect socket")
            Thread.sleep(5000)
            createSocket()
        }
    }

    private fun showNotification(str: String) {
        val channelId = createNotificationChannel(applicationContext)

        val notificationBuilder = NotificationCompat.Builder(applicationContext, channelId)

        val activityIntent = Intent(applicationContext, MainActivity::class.java)

        activityIntent.putExtra("payload", str)
        val pendingIntent = PendingIntent.getActivity(
            applicationContext,
            0,
            activityIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = notificationBuilder
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(PRIORITY_DEFAULT)
            .setChannelId(channelId)
            .setContentTitle("New message")
            .setContentText(str)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .build()

        with(NotificationManagerCompat.from(this)) {
            if (ActivityCompat.checkSelfPermission(
                    context,
                    Manifest.permission.POST_NOTIFICATIONS
                ) != PackageManager.PERMISSION_GRANTED
            ) {
                android.util.Log.e(
                    PushNotificationService::class.simpleName,
                    "showNotification: PERMISSION DENIED",
                )
                return
            }
            notify(notifyManagerId, notification)
            notifyManagerId++
        }

//        startForeground(101, notification)
    }

    private fun createSocket() {

        val thread = Thread {
            android.util.Log.e("///////", "onReceive: start thread")
            connectSocket()
        }

        thread.start()
    }

    companion object {
        fun createNotificationChannel(context: Context): String {
            val channelId = "com.example.chat_app"
            val channelName = "My Background Service"
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val channel = NotificationChannel(
                    channelId,
                    channelName, NotificationManager.IMPORTANCE_DEFAULT
                )
                val notificationManager: NotificationManager =
                    context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                notificationManager.createNotificationChannel(channel)
            }
            return channelId
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)

        val channelId = createNotificationChannel(applicationContext)

        val notificationBuilder = NotificationCompat.Builder(applicationContext, channelId)

        val notification = notificationBuilder
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(PRIORITY_DEFAULT)
            .setChannelId(channelId)
            .setContentTitle("Service Running")
            .setContentText("This is a foreground service")
            .setAutoCancel(true)
            .build()

        startForeground(101, notification)

        return START_NOT_STICKY
    }
}
