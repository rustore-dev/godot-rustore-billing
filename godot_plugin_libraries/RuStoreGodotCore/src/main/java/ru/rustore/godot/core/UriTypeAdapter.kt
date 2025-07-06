package ru.rustore.godot.core

import android.net.Uri
import com.google.gson.TypeAdapter
import com.google.gson.stream.JsonReader
import com.google.gson.stream.JsonWriter

class UriTypeAdapter : TypeAdapter<Uri>() {
    override fun write(out: JsonWriter?, value: Uri?) {
        out?.value(value?.toString())
    }

    override fun read(`in`: JsonReader?): Uri {
        val uriString = `in`?.nextString()
        return Uri.parse(uriString)
    }
}
