package ru.rustore.godot.core

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.SharedPreferences
import android.os.Build
import android.widget.Toast
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.UsedByGodot


class RuStoreGodotCore(godot: Godot?): GodotPlugin(godot) {
    private companion object {
        const val PLUGIN_NAME = "RuStoreGodotCore"
        const val CLIP_DATA_TOOLTIP = "Copied Text"
    }

    override fun getPluginName(): String {
        return PLUGIN_NAME
    }

    @UsedByGodot
    fun showToast(message: String) {
        godot.getActivity()?.runOnUiThread { Toast.makeText(activity, message, Toast.LENGTH_LONG).show() }
    }

    @UsedByGodot
    fun copyToClipboard(text: String) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB) return

        godot.getActivity()?.runOnUiThread {
            godot.getActivity()?.run {
                val clipboard: ClipboardManager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                val clip = ClipData.newPlainText(CLIP_DATA_TOOLTIP, text)
                clipboard.setPrimaryClip(clip)
            }
        }
    }

    @UsedByGodot
    fun getFromClipboard(): String {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB) return String()

        return godot.getActivity()?.run {
            val clipboard: ClipboardManager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
            val clip: ClipData = clipboard.primaryClip ?: return String()
            val text = clip.getItemAt(0).text ?: return String()
            text.toString()
        }.orEmpty()
    }

    @UsedByGodot
    fun getStringResources(name: String): String {
        return godot.getActivity()?.run {
            val id: Int = application.resources.getIdentifier(name, "string", application.packageName)
            application.getString(id)
        }.orEmpty()
    }

    @UsedByGodot
    fun getIntResources(name: String?): Int {
        return godot.getActivity()?.run {
            val id: Int = application.resources.getIdentifier(name, "integer", application.packageName)
            application.resources.getInteger(id)
        } ?: 0
    }

    @UsedByGodot
    fun getStringSharedPreferences(
        storageName: String,
        key: String,
        defaultValue: String
    ): String {
        return godot.getActivity()?.run {
            val preferences: SharedPreferences = application.getSharedPreferences(storageName, Context.MODE_PRIVATE)
            preferences.getString(key, defaultValue).orEmpty()
        }.orEmpty()
    }

    @UsedByGodot
    fun getIntSharedPreferences(storageName: String, key: String, defaultValue: Int): Int {
        return godot.getActivity()?.run {
            val preferences: SharedPreferences = application.getSharedPreferences(storageName, Context.MODE_PRIVATE)
            preferences.getInt(key, defaultValue)
        } ?: 0
    }

    @UsedByGodot
    fun setStringSharedPreferences(storageName: String, key: String, value: String) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB) return

        godot.getActivity()?.run {
            val preferences: SharedPreferences = application.getSharedPreferences(storageName, Context.MODE_PRIVATE)
            val editor = preferences.edit()
            editor.putString(key, value)
            editor.apply()
        }
    }

    @UsedByGodot
    fun setIntSharedPreferences(storageName: String, key: String, value: Int) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB) return

        godot.getActivity()?.run {
            val preferences: SharedPreferences = application.getSharedPreferences(storageName, Context.MODE_PRIVATE)
            val editor = preferences.edit()
            editor.putInt(key, value)
            editor.apply()
        }
    }
}
