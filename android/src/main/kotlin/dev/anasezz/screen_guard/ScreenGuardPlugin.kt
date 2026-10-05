package dev.anasezz.screen_guard

import android.app.Activity
import android.media.AudioAttributes
import android.media.AudioManager
import android.os.Build
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class ScreenGuardPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var isSecure: Boolean = false

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dev.anasezz/screen_guard")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "setSecure" -> {
                val secure = call.argument<Boolean>("secure") ?: false
                setSecureFlag(secure, result)
            }
            else -> result.notImplemented()
        }
    }

    private fun setSecureFlag(secure: Boolean, result: Result) {
        isSecure = secure
        val currentActivity = activity
        if (currentActivity == null) {
            result.error("NO_ACTIVITY", "Plugin is not attached to an activity.", null)
            return
        }

        applyProtection(currentActivity, secure, result)
    }

    private fun applyProtection(activity: Activity, secure: Boolean, result: Result?) {
        activity.runOnUiThread {
            try {
                if (secure) {
                    activity.window.setFlags(
                        WindowManager.LayoutParams.FLAG_SECURE,
                        WindowManager.LayoutParams.FLAG_SECURE
                    )
                } else {
                    activity.window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                }

                setAudioCapturePolicy(activity, secure)

                result?.success(null)
            } catch (e: Exception) {
                result?.error("SET_SECURE_FAILED", e.message, null)
            }
        }
    }

    private fun setAudioCapturePolicy(activity: Activity, secure: Boolean) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val audioManager = activity.getSystemService(Activity.AUDIO_SERVICE) as? AudioManager
            audioManager?.allowedCapturePolicy = if (secure) {
                AudioAttributes.ALLOW_CAPTURE_BY_NONE
            } else {
                AudioAttributes.ALLOW_CAPTURE_BY_ALL
            }
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        if (isSecure) {
            applyProtection(binding.activity, true, null)
        }
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        if (isSecure) {
            applyProtection(binding.activity, true, null)
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }
}
