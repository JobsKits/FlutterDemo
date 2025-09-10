package com.aomen.grand.lisboa
import android.app.Dialog
import android.content.Context
import android.content.res.Resources
import android.graphics.Color
import android.graphics.PorterDuff
import android.graphics.drawable.GradientDrawable
import android.util.DisplayMetrics
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.*

class ExitConfirmDialog(
    context: Context,
    private val titleString: String,
    private val onConfirm: () -> Unit
) : Dialog(context, R.style.CustomDialog) {

    private lateinit var confirmButton: TextView

    init {
        setCancelable(true)
        setCanceledOnTouchOutside(false)

        val dialogLayout = LinearLayout(context).apply {
            orientation = LinearLayout.VERTICAL
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            setPadding(60, 40, 60, 40)
            background = GradientDrawable().apply {
                setColor(Color.WHITE)
                cornerRadius = 40f
            }
        }
        val closeButton = ImageView(context).apply {
            setImageResource(android.R.drawable.ic_menu_close_clear_cancel)
            setColorFilter(Color.BLACK, PorterDuff.Mode.SRC_IN)
            layoutParams = FrameLayout.LayoutParams(60, 60, Gravity.END)
            setOnClickListener { dismiss() }
        }

        val closeWrapper = FrameLayout(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            addView(closeButton)
        }

        val title = TextView(context).apply {
            text = "确定退出$titleString"
            textSize = 20f
            setTextColor(Color.BLACK)
            gravity = Gravity.CENTER
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = 50.dp
                bottomMargin = 50.dp
            }
        }

        val cancelButton = TextView(context).apply {
            text = "取消"
            textSize = 18f
            gravity = Gravity.CENTER
            setTextColor(Color.parseColor("#CECECE"))
            background = GradientDrawable().apply {
                setStroke(2, Color.parseColor("#F4F4F4"))
                cornerRadius = 30f
            }
            setPadding(0, 30, 0, 30)
            layoutParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            setOnClickListener { dismiss() }
        }
        val buttonSpacer = View(context).apply {
            layoutParams = LinearLayout.LayoutParams(
                20.dp,
                LinearLayout.LayoutParams.MATCH_PARENT
            )
        }
        confirmButton = TextView(context).apply {
            text = "确定"
            textSize = 18f
            gravity = Gravity.CENTER
            setTextColor(Color.WHITE)
            background = GradientDrawable().apply {
                setColor(0xFF10C8E3.toInt()) // 蓝色
                cornerRadius = 30f
            }
            setPadding(0, 30, 0, 30)
            layoutParams = LinearLayout.LayoutParams(0, LinearLayout.LayoutParams.WRAP_CONTENT, 1f)
            setOnClickListener {
                onConfirm()
                dismiss()
            }
        }

        val buttonLayout = LinearLayout(context).apply {
            orientation = LinearLayout.HORIZONTAL
            weightSum = 2f
            layoutParams = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            ).apply {
                topMargin = 60
            }
            addView(cancelButton)
            addView(buttonSpacer) // 在中间插入间距
            addView(confirmButton)
        }

        dialogLayout.addView(closeWrapper)
        dialogLayout.addView(title)
        dialogLayout.addView(buttonLayout)

        setContentView(dialogLayout)

        val displayMetrics = DisplayMetrics()
        window?.windowManager?.defaultDisplay?.getMetrics(displayMetrics)
        window?.setLayout(
            (displayMetrics.widthPixels * 0.8).toInt(),
            WindowManager.LayoutParams.WRAP_CONTENT
        )
    }
    val Int.dp: Int
        get() = (this * Resources.getSystem().displayMetrics.density).toInt()
}
