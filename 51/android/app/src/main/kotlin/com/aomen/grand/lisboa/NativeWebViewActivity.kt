package com.aomen.grand.lisboa
import android.annotation.SuppressLint
import android.graphics.Color
import android.os.Bundle
import android.view.Gravity
import android.view.MotionEvent
import android.view.View
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.*
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class NativeWebViewActivity : AppCompatActivity() {

    private lateinit var webView: WebView
    private lateinit var closeButton: ImageView
    private var dX = 0f
    private var dY = 0f
    private var urlString: String = ""
    private var titleString: String = ""

    companion object {
        private const val CHANNEL = "native_webview_callback"
        private const val ENGINE_ID = "my_engine_id"
    }

    @SuppressLint("SetJavaScriptEnabled")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        urlString = intent.getStringExtra("urlString") ?: ""
        titleString = intent.getStringExtra("titleString") ?: ""

        val rootLayout = FrameLayout(this).apply {
            setBackgroundColor(Color.BLACK)
        }

        webView = WebView(this).apply {
            layoutParams = FrameLayout.LayoutParams(
                FrameLayout.LayoutParams.MATCH_PARENT,
                FrameLayout.LayoutParams.MATCH_PARENT
            )
            webViewClient = WebViewClient()
            webChromeClient = WebChromeClient()
            settings.javaScriptEnabled = true
            settings.domStorageEnabled = true
            settings.mediaPlaybackRequiresUserGesture = false
            settings.loadWithOverviewMode = true
            settings.useWideViewPort = true
        }

        if (urlString.startsWith("http://") || urlString.startsWith("https://")) {
            webView.loadUrl(urlString)
        } else {
            webView.loadDataWithBaseURL(null, urlString, "text/html", "UTF-8", null)
        }

        closeButton = ImageView(this).apply {
            setImageResource(R.mipmap.icon_game_back)
            layoutParams = FrameLayout.LayoutParams(180, 180).apply {
                gravity = Gravity.TOP or Gravity.START
                topMargin = 200
                leftMargin = 40
            }
            setOnTouchListener(dragListener)
            setOnClickListener { showExitDialog() }
        }

        rootLayout.addView(webView)
        rootLayout.addView(closeButton)

        setContentView(rootLayout)
    }

    private val dragListener = View.OnTouchListener { view, event ->
        when (event.actionMasked) {
            MotionEvent.ACTION_DOWN -> {
                dX = view.x - event.rawX
                dY = view.y - event.rawY
                view.tag = System.currentTimeMillis()
            }
            MotionEvent.ACTION_MOVE -> {
                val parent = view.parent as View
                val screenWidth = parent.width
                val screenHeight = parent.height

                val viewWidth = view.width
                val viewHeight = view.height

                val marginRight = 40
                val marginBottom = 40

                var newX = event.rawX + dX
                var newY = event.rawY + dY

                newX = newX.coerceIn(
                    0f,
                    (screenWidth - viewWidth - marginRight).toFloat()
                )
                newY = newY.coerceIn(
                    0f,
                    (screenHeight - viewHeight - marginBottom).toFloat()
                )

                view.animate().x(newX).y(newY).setDuration(0).start()
            }
            MotionEvent.ACTION_UP -> {
                val clickThreshold = 200
                val timeDown = view.tag as? Long ?: 0
                val timeDiff = System.currentTimeMillis() - timeDown
                if (timeDiff < clickThreshold) {
                    view.performClick()
                }
            }
        }
        true
    }
    override fun onBackPressed() {//屏蔽系统返回
    }
    private fun showExitDialog() {
        var dialog: ExitConfirmDialog? = null

        dialog = ExitConfirmDialog(this, titleString = titleString) {
            MethodChannel(
                FlutterEngineCache.getInstance()
                    .get(ENGINE_ID)!!.dartExecutor.binaryMessenger,
                CHANNEL
            ).invokeMethod("onExitConfirmed", null)

            clearWebViewCache {
                dialog?.dismiss()
                finish()
            }
        }
        dialog.show()
    }

    private fun clearWebViewCache(onFinish: () -> Unit) {
        webView.clearCache(true)
        webView.clearHistory()
        onFinish()
    }
}

