package ru.rustore.godot.core

import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
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
        godot.requireActivity().runOnUiThread { Toast.makeText(activity, message, Toast.LENGTH_LONG).show() }
    }

    @UsedByGodot
    fun copyToClipboard(text: String) {
        val clipboard: ClipboardManager = godot.requireActivity().getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip = ClipData.newPlainText(CLIP_DATA_TOOLTIP, text)
        clipboard.setPrimaryClip(clip)
    }

    @UsedByGodot
    fun getFromClipboard(): String {
        val clipboard: ClipboardManager = godot.requireActivity().getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clip: ClipData = clipboard.primaryClip ?: return String()
        val text = clip.getItemAt(0).text ?: return String()
        return text.toString()
    }

    @UsedByGodot
    fun getStringResources(name: String): String {
        val application = godot.requireActivity().application
        val id: Int = application.resources.getIdentifier(name, "string", application.packageName)
        return application.getString(id)
    }
}
