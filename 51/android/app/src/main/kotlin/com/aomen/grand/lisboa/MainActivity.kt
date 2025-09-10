package com.aomen.grand.lisboa

import android.content.Context
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle
import io.flutter.embedding.engine.FlutterEngine
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor

class MainActivity: FlutterActivity() {

  private val CHANNEL = "native_webview_channel"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
        /*
    CoroutineScope(Dispatchers.IO).launch {
      try {
        OpenShare.getInstance().init(applicationContext)
        // Log.d("XXXYYY", "OpenShare 初始化成功")
      } catch (e: Exception) {
        // Log.d("XXXYYY", "OpenShare 初始化失败")
        e.printStackTrace()
      }
    }

    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "open_share_plugin")
    .setMethodCallHandler { call, result ->
      if (call.method == "getInstallParams") {
        val installParams = OpenShare.getInstance().installParams
        if (installParams != null && installParams.ret == "C2") {
          // Log.d("XXXYYY", "安装数据: ${installParams.data.params}")
          result.success(installParams.data.params)
        } else {
          // Log.d("XXXYYY", "安装数据为空")
          result.success("")
        }
      } else {
        result.notImplemented()
      }
    }
    */
  }
  override fun provideFlutterEngine(context: Context): FlutterEngine? {
    val engine = FlutterEngine(context)
    engine.dartExecutor.executeDartEntrypoint(
      DartExecutor.DartEntrypoint.createDefault()
    )
    FlutterEngineCache.getInstance().put("my_engine_id", engine)
    return engine
  }
  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    flutterEngine?.let { engine ->
      MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
        .setMethodCallHandler { call, result ->
          if (call.method == "openWebView") {
            val url = call.argument<String>("urlString") ?: ""
            val title = call.argument<String>("titleString") ?: ""
            openWebView(url, title)
            result.success(null)
          } else {
            result.notImplemented()
          }
        }
    }
  }

  private fun openWebView(url: String, title: String) {
    val intent = Intent(this, NativeWebViewActivity::class.java).apply {
      putExtra("urlString", url)
      putExtra("titleString", title)
    }
    startActivity(intent)
  }
}
