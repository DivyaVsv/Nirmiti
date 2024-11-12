package com.example.nirmiti_app

import android.app.Service
import android.content.Intent
import android.os.IBinder
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.FrameLayout
import android.os.FileObserver
import java.io.File
class OverlayService : Service() {

    private lateinit var windowManager: WindowManager
    private lateinit var overlayView: View
    private var fileObserver: FileObserver? = null

     override fun onCreate() {
        super.onCreate()

        // Initialize WindowManager and inflate the overlay layout
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager

        val layoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            android.graphics.PixelFormat.TRANSLUCENT
        )

        layoutParams.gravity = Gravity.TOP or Gravity.LEFT
        layoutParams.x = 0
        layoutParams.y = 0

        // Inflate the overlay layout and add it to the window manager
        overlayView = LayoutInflater.from(this).inflate(R.layout.overlay_layout, null)

        // Set an OnClickListener to handle clicks on the overlay
        overlayView.setOnClickListener {
             val directory = File("/storage/emulated/0/Nirmiti/")
        fileObserver = object : FileObserver(directory.path, FileObserver.CREATE) {
            override fun onEvent(event: Int, path: String?) {
                if (event == FileObserver.CREATE && path != null) {
                    // File created
                    val launchIntent = Intent(applicationContext, MainActivity::class.java)
                    launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
                    startActivity(launchIntent)
                    stopSelf()
                }
            }
        }
        fileObserver?.startWatching()
    
            // Bring the app to the foreground when the overlay is clicked
           // val intent = Intent(this, MainActivity::class.java)
           // intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
           // startActivity(intent)

            // Stop the service after bringing the app to the foreground
            //stopSelf()
        }

        windowManager.addView(overlayView, layoutParams)
    } 


    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val directory = File("/storage/emulated/0/Nirmiti/")
        fileObserver = object : FileObserver(directory.path, FileObserver.CREATE) {
            override fun onEvent(event: Int, path: String?) {
                if (event == FileObserver.CREATE && path != null) {
                    // File created
                    val launchIntent = Intent(applicationContext, MainActivity::class.java)
                    launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(launchIntent)
                }
            }
        }
        fileObserver?.startWatching()
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        if (::overlayView.isInitialized) {
            windowManager.removeView(overlayView)
        }
        fileObserver?.stopWatching()
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}
