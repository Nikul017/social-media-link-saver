package com.example.link_saver

import android.app.Activity
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.os.Bundle
import android.widget.Toast
import java.io.File

/**
 * QuickSaveActivity — Transparent, no-UI activity.
 * Catches ACTION_SEND share intents, saves the URL directly to SQLite
 * (same database that Drift/Flutter uses), and closes immediately.
 * The user never sees the app open.
 */
class QuickSaveActivity : Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val url = intent?.getStringExtra(Intent.EXTRA_TEXT)?.trim()

        if (url.isNullOrBlank()) {
            Toast.makeText(this, "No URL found", Toast.LENGTH_SHORT).show()
            finish()
            return
        }

        try {
            saveToDatabase(url)
            Toast.makeText(this, "✓ Saved to LinkSaver", Toast.LENGTH_SHORT).show()
        } catch (e: Exception) {
            Toast.makeText(this, "Could not save: ${e.localizedMessage}", Toast.LENGTH_LONG).show()
        }

        finish() // Close immediately — no UI ever shown
    }

    private fun saveToDatabase(url: String) {
        // Drift uses path_provider's getApplicationDocumentsDirectory() which on
        // Android resolves to: /data/data/<package>/app_flutter/
        val appFlutterDir = File(filesDir.parent, "app_flutter")
        val dbPath = File(appFlutterDir, "db.sqlite").absolutePath

        if (!File(dbPath).exists()) {
            // DB doesn't exist yet (app never opened) — create it
            appFlutterDir.mkdirs()
        }

        val db = SQLiteDatabase.openOrCreateDatabase(dbPath, null)

        // Ensure tables exist (in case Quick Save runs before Flutter ever opens)
        db.execSQL(
            """
            CREATE TABLE IF NOT EXISTS bookmarks (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                url TEXT NOT NULL,
                title TEXT NOT NULL,
                description TEXT,
                thumbnail_url TEXT,
                favicon_url TEXT,
                created_at INTEGER NOT NULL,
                updated_at INTEGER NOT NULL,
                notes TEXT,
                category TEXT,
                folder_id INTEGER,
                is_favorite INTEGER NOT NULL DEFAULT 0,
                is_archived INTEGER NOT NULL DEFAULT 0
            )
            """.trimIndent()
        )

        val now = System.currentTimeMillis() / 1000 // Drift expects seconds for DateTime

        // Trim the URL to a short title (domain only)
        val title = extractDomain(url).ifBlank { url }

        db.execSQL(
            """
            INSERT INTO bookmarks (url, title, created_at, updated_at, is_favorite, is_archived)
            VALUES (?, ?, ?, ?, 0, 0)
            """.trimIndent(),
            arrayOf(url, title, now, now)
        )

        db.close()
    }

    private fun extractDomain(url: String): String {
        return try {
            val uri = android.net.Uri.parse(url)
            uri.host?.removePrefix("www.") ?: url
        } catch (_: Exception) {
            url
        }
    }
}
