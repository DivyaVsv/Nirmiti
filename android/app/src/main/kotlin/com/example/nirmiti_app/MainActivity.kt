package com.example.nirmiti_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.os.Build
import android.os.Bundle
import androidx.core.content.ContextCompat
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.Intent
import android.app.Service
import android.provider.Settings
import android.view.WindowManager
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.widget.Toast
import android.view.Gravity
import android.view.LayoutInflater
import android.telephony.TelephonyManager
import android.telephony.PhoneStateListener
import android.content.ContentResolver
import android.provider.MediaStore
import java.io.File
import android.util.Log 
import android.content.ContentUris
import android.database.Cursor
import android.media.MediaMetadataRetriever
import android.Manifest


class MainActivity : FlutterActivity() {
private val CHANNEL = "com.example.nirmiti_app/callRecording"
private val recorder = CallReceiver()
 private val REQUEST_OVERLAY_PERMISSION = 1234

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestOverlayPermission()
    }

    private fun requestOverlayPermission() {
        if (!Settings.canDrawOverlays(this)) {
            val intent = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:$packageName")
            )
            startActivityForResult(intent, REQUEST_OVERLAY_PERMISSION)
        }
    }
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    super.onActivityResult(requestCode, resultCode, data)
    if (requestCode == REQUEST_OVERLAY_PERMISSION) {
        if (!Settings.canDrawOverlays(this)) {
            // Permission not granted, handle the case
        }
    }
}
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "backToForeground"->{
                 startOverlayAfterDelay()
                result.success("Open app ")
                }
                "getCallRecordings"->{
                    val recordings = getCallRecordings()
                result.success(recordings)
                }
                 
                else -> result.notImplemented()
            }
        }
    }
     private fun getCallRecordings(): List<String> {
        val recordingsList = mutableListOf<String>()
        val projection = arrayOf(MediaStore.Audio.Media._ID, MediaStore.Audio.Media.DISPLAY_NAME)
        val selection = "${MediaStore.Audio.Media.IS_MUSIC} = 0" // Adjust if needed

        val cursor: Cursor? = contentResolver.query(
            MediaStore.Audio.Media.EXTERNAL_CONTENT_URI,
            projection,
            selection,
            null,
            null
        )

        cursor?.use {
            while (it.moveToNext()) {
                val id = it.getLong(it.getColumnIndexOrThrow(MediaStore.Audio.Media._ID))
                val displayName = it.getString(it.getColumnIndexOrThrow(MediaStore.Audio.Media.DISPLAY_NAME))
                recordingsList.add(displayName) // Add recording name to list
            }
        }
        return recordingsList
    }
   


    private fun listenToCallState() {
        val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        telephonyManager.listen(object : PhoneStateListener() {
            override fun onCallStateChanged(state: Int, phoneNumber: String? ) {
                super.onCallStateChanged(state, phoneNumber)

                // When the call ends, start a 15-second delay for the overlay and the app
                if (state == TelephonyManager.CALL_STATE_IDLE) {
                    startOverlayAfterDelay()
                }
            }
        }, PhoneStateListener.LISTEN_CALL_STATE)
    }
     private fun startOverlayAfterDelay() {
        // Delay the overlay by 15 seconds using Handler
        Handler(Looper.getMainLooper()).postDelayed({
            //showOverlay()
            bringFlutterAppToForeground()
        }, 15000) // 15,000 ms = 15 seconds
    }
    private fun showOverlay() {
        // Display a simple toast message as an example overlay
        Toast.makeText(this, "Overlay started after 15 seconds", Toast.LENGTH_LONG).show()

        // Inflate your overlay layout (if necessary)
        val inflater = getSystemService(LAYOUT_INFLATER_SERVICE) as LayoutInflater
        val overlayView = inflater.inflate(R.layout.overlay_layout, null)

        // Setup WindowManager to display the overlay
        val wm = getSystemService(WINDOW_SERVICE) as WindowManager
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
            android.graphics.PixelFormat.TRANSLUCENT
        )

        params.gravity = Gravity.CENTER
        wm.addView(overlayView, params)
    }

    private fun bringFlutterAppToForeground() {
        // Intent to bring the Flutter app to the foreground
        val intent = Intent(this, MainActivity::class.java)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.addFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT)
        startActivity(intent)
    } 
    
}

