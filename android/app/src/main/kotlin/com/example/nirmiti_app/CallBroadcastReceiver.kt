package com.example.nirmiti_app

import android.util.Log
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.TelephonyManager
import android.media.MediaRecorder
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import android.os.Environment


class CallReceiver : BroadcastReceiver() {
    private var recorder: MediaRecorder? = null
    private var isRecording: Boolean = false

    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == TelephonyManager.ACTION_PHONE_STATE_CHANGED) {
            val state = intent.getStringExtra(TelephonyManager.EXTRA_STATE)
             if (state == TelephonyManager.EXTRA_STATE_OFFHOOK) {
                // Call is ongoing, start recording
               // startRecording(context)
            }else if (state == TelephonyManager.EXTRA_STATE_IDLE) {
                //stopRecording() 
                // Call ended, now launch or bring your Flutter app to the foreground
                val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
                launchIntent?.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                context.startActivity(launchIntent)  
                              
            }
        }
    }
    fun startRecording(context: Context?) {
          if (isRecording || context == null) return
    val fileName = "recorded_call.3gp"
    
    // Construct the file path
    val filePath = context.getExternalFilesDir(null)?.absolutePath + "/$fileName"

    // Initialize MediaRecorder to record in MP4 format with AAC encoding
    recorder = MediaRecorder().apply {
        setAudioSource(MediaRecorder.AudioSource.VOICE_COMMUNICATION)  // Best for call recording
        setOutputFormat(MediaRecorder.OutputFormat.THREE_GPP)             // Output in MP4 format
        setAudioEncoder(MediaRecorder.AudioEncoder.AMR_NB)                // Use AAC audio encoding
        setOutputFile(filePath)
        
        try {
            prepare()
            start()
            isRecording = true
            Log.d("CallRecorder", "Recording started, saving to: $filePath")
        } catch (e: Exception) {
            e.printStackTrace()
            Log.e("CallRecorder", "Error starting recording: ${e.message}")
        }
    }

}

    fun stopRecording() {
        if (!isRecording) return

        recorder?.apply {
            stop()
            reset()
            release()
        }
        isRecording = false
        Log.d("CallRecorder", "Recording stopped")
    }
}




