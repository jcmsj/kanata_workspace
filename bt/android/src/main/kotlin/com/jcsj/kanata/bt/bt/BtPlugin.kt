package com.jcsj.kanata.bt.bt

//Flutter related

// for bt stuff
import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.bluetooth.BluetoothManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.work.ListenableWorker
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import java.util.concurrent.TimeUnit.MINUTES

/** BtPlugin */
class BtPlugin: FlutterPlugin, MethodCallHandler, ActivityAware,
  PluginRegistry.RequestPermissionsResultListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel

  //  https://stackoverflow.com/a/70802179
  private lateinit var context: Context
  private lateinit var activity: Activity
  private final var REQUEST_ENABLE_BT = 42
  private var duration = -1;
  private var result: Result? = null;
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bt")
    context = flutterPluginBinding.applicationContext
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")

      }

      "hello" -> {
        result.success("hello")
      }

      "scheduleBtDeactivation" -> {
        call.argument<Int>("timeInMinutes")?.let {
//          if (//ContextCompat.checkSelfPermission(activity, Manifest.permission.BLUETOOTH) == PackageManager.PERMISSION_DENIED
//            ContextCompat.checkSelfPermission(activity, Manifest.permission.BLUETOOTH_CONNECT) == PackageManager.PERMISSION_DENIED
//            || ContextCompat.checkSelfPermission(activity, Manifest.permission.BLUETOOTH_ADMIN) == PackageManager.PERMISSION_DENIED
//            || ContextCompat.checkSelfPermission(activity, Manifest.permission.SCHEDULE_EXACT_ALARM) == PackageManager.PERMISSION_DENIED
//          )
//          {
             ActivityCompat.requestPermissions(
               activity,
               arrayOf(
                Manifest.permission.BLUETOOTH,
                Manifest.permission.BLUETOOTH_CONNECT,
                Manifest.permission.BLUETOOTH_ADMIN,
                Manifest.permission.SCHEDULE_EXACT_ALARM), REQUEST_ENABLE_BT)
//              return
//          }
            this.result = result
            duration = it
//          val enableBtIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
//          val b = Bundle(1)
//          b.putInt("duration", it)
//          startActivityForResult(activity, enableBtIntent, REQUEST_ENABLE_BT, b)
        }
      }

      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onDetachedFromActivity() {}
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity
//    binding.addActivityResultListener(this)
    binding.addRequestPermissionsResultListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onRequestPermissionsResult(
    requestCode: Int,
    permissions: Array<out String>,
    grantResults: IntArray
  ): Boolean {
    if (requestCode == REQUEST_ENABLE_BT) {
      if (grantResults.size > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
        // The user has granted the permission.
        // Start scanning for Bluetooth devices.
        Log.d("NATIVE", "$duration")
        scheduleBtDeactivation(context)(duration)
        result?.success(null)
        result = null
        return true
      } else {
        // The user has denied the permission.
        // Display an error message.
        return false
      }
    }
    return false
  }
  fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    Log.d("ACTIVITY RESULT", "$requestCode | $resultCode")
    if (requestCode == REQUEST_ENABLE_BT && resultCode == Activity.RESULT_OK) {
      Log.d("BLUETOOTH ACCEPTED", "$duration")

      if (duration > 0) {
        scheduleBtDeactivation(context)(duration)
        Log.d("NATIVE", "$duration")
        return true
      }
    }
    return false
  }
}
private fun sched(w: Class<out ListenableWorker>): (Context) -> (Int) -> Unit {
  return fun(context: Context): (Int) -> Unit {
    return fun(minutes:Int) {
      val workRequest = OneTimeWorkRequest.Builder(w)
        .setInitialDelay(minutes.toLong(), MINUTES)
        .build()

      WorkManager.getInstance(context).enqueue(workRequest)
    }
  }
}

val scheduleBtDeactivation= sched(BluetoothOffWorker::class.java)


class BluetoothOffWorker(context: Context, workerParameters: WorkerParameters) : Worker(context, workerParameters) {
  @SuppressLint("MissingPermission")
  override fun doWork(): Result {
    val btMgr = applicationContext.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    // Disable Bluetooth
    btMgr.adapter.disable()
    return Result.success()
  }
}
