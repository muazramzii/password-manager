package com.muazramzii.password_manager

import android.os.Bundle
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity

// Blocks screenshots and screen recording of this app. A password manager
// showing decrypted vault entries is exactly the kind of screen that
// shouldn't be capturable by other apps or leak into the recent-apps thumbnail.
class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        window.setFlags(WindowManager.LayoutParams.FLAG_SECURE, WindowManager.LayoutParams.FLAG_SECURE)
        super.onCreate(savedInstanceState)
    }
}
