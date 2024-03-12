package ru.rustore.godot.core

import com.google.gson.Gson

object JsonBuilder {
    private val gson: Gson by lazy { Gson() }

    fun toJson(throwable: Throwable?): String {
        var json = gson.toJson(throwable)

        throwable?.let {
            if (json.isNotEmpty() && json.endsWith("}")) {
                val splitter = if (json.contains(":")) "," else ""
                val simpleName = """"simpleName":"${throwable::class.java.simpleName}""""
                json = json.dropLast(1).plus(splitter).plus(simpleName).plus("}")
            }
        }

        return json
    }
}
