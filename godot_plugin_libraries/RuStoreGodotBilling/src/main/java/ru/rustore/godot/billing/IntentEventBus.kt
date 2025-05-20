package ru.rustore.godot.billing

import android.content.Intent
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.launch

object IntentEventBus {
    private const val REPLAY_COUNT = 1

    private val _intents = MutableSharedFlow<Intent?>(replay = REPLAY_COUNT)
    val intents = _intents.asSharedFlow()

    fun emit(intent: Intent?) {
        CoroutineScope(Dispatchers.Default).launch {
            _intents.emit(intent)
        }
    }
}
