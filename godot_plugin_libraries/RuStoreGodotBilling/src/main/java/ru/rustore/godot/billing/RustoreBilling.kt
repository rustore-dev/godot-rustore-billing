package ru.rustore.godot.billing

import android.content.Intent
import android.util.ArraySet
import com.google.gson.Gson
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot
import ru.rustore.sdk.billingclient.RuStoreBillingClient
import ru.rustore.sdk.billingclient.RuStoreBillingClientFactory
import ru.rustore.sdk.billingclient.provider.logger.ExternalPaymentLogger
import ru.rustore.sdk.core.feature.model.FeatureAvailabilityResult

class RuStoreGodotBilling(godot: Godot?) : GodotPlugin(godot), ExternalPaymentLogger {
    private companion object {
        const val CHANNEL_CHECK_PURCHASES_AVAILABLE_SUCCESS = "rustore_check_purchases_available_success"
        const val CHANNEL_CHECK_PURCHASES_AVAILABLE_FAILURE = "rustore_check_purchases_available_failure"
        const val CHANNEL_ON_GET_PRODUCTS_SUCCESS = "rustore_on_get_products_success"
        const val CHANNEL_ON_GET_PRODUCTS_FAILURE = "rustore_on_get_products_failure"
        const val CHANNEL_ON_PURCHASE_PRODUCT_SUCCESS = "rustore_on_purchase_product_success"
        const val CHANNEL_ON_PURCHASE_PRODUCT_FAILURE = "rustore_on_purchase_product_failure"
        const val CHANNEL_ON_GET_PURCHASES_SUCCESS = "rustore_on_get_purchases_success"
        const val CHANNEL_ON_GET_PURCHASES_FAILURE = "rustore_on_get_purchases_failure"
        const val CHANNEL_ON_CONFIRM_PURCHASE_SUCCESS = "rustore_on_confirm_purchase_success"
        const val CHANNEL_ON_CONFIRM_PURCHASE_FAILURE = "rustore_on_confirm_purchase_failure"
        const val CHANNEL_ON_DELETE_PURCHASE_SUCCESS = "rustore_on_delete_purchase_success"
        const val CHANNEL_ON_DELETE_PURCHASE_FAILURE = "rustore_on_delete_purchase_failure"
        const val CHANNEL_ON_GET_PURCHASE_INFO_SUCCESS = "rustore_on_get_purchase_info_success"
        const val CHANNEL_ON_GET_PURCHASE_INFO_FAILURE = "rustore_on_get_purchase_info_failure"
        const val CHANNEL_ON_PAYMENT_LOGGER_DEBUG = "rustore_on_payment_logger_debug"
        const val CHANNEL_ON_PAYMENT_LOGGER_ERROR = "rustore_on_payment_logger_error"
        const val CHANNEL_ON_PAYMENT_LOGGER_INFO = "rustore_on_payment_logger_info"
        const val CHANNEL_ON_PAYMENT_LOGGER_VERBOSE = "rustore_on_payment_logger_verbose"
        const val CHANNEL_ON_PAYMENT_LOGGER_WARNING = "rustore_on_payment_logger_warning"
    }

    override fun getPluginName(): String {
        return javaClass.simpleName
    }

    override fun getPluginSignals(): Set<SignalInfo> {
        val signals: MutableSet<SignalInfo> = ArraySet()
        signals.add(SignalInfo(CHANNEL_CHECK_PURCHASES_AVAILABLE_SUCCESS, String::class.java))
        signals.add(SignalInfo(CHANNEL_CHECK_PURCHASES_AVAILABLE_FAILURE, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_GET_PRODUCTS_SUCCESS, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_GET_PRODUCTS_FAILURE, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_PURCHASE_PRODUCT_SUCCESS, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_PURCHASE_PRODUCT_FAILURE, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_GET_PURCHASES_SUCCESS, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_GET_PURCHASES_FAILURE, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_CONFIRM_PURCHASE_SUCCESS, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_CONFIRM_PURCHASE_FAILURE, String::class.java, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_DELETE_PURCHASE_SUCCESS, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_DELETE_PURCHASE_FAILURE, String::class.java, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_GET_PURCHASE_INFO_SUCCESS, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_GET_PURCHASE_INFO_FAILURE, String::class.java, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_PAYMENT_LOGGER_DEBUG, String::class.java, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_PAYMENT_LOGGER_ERROR, String::class.java, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_PAYMENT_LOGGER_INFO, String::class.java, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_PAYMENT_LOGGER_VERBOSE, String::class.java, String::class.java))
        signals.add(SignalInfo(CHANNEL_ON_PAYMENT_LOGGER_WARNING, String::class.java, String::class.java))

        return signals
    }

    private var client: RuStoreBillingClient? = null
    private val gson = Gson()
    private var tag: String = ""

    @UsedByGodot
    fun init(id: String, scheme: String, debugLogs: Boolean, externalPaymentLogger: Boolean) {
        godot.getActivity()?.let { activity ->
            client = RuStoreBillingClientFactory.create(
                context = activity.application,
                consoleApplicationId = id,
                deeplinkScheme = scheme,
                internalConfig = mapOf(
                    "type" to "godot"
                ),
                themeProvider = RuStoreBillingClientThemeProviderImpl,
                debugLogs = debugLogs,
                externalPaymentLoggerFactory = if (externalPaymentLogger) { tag -> this.tag = tag; this } else null
            )
        }
    }

    @UsedByGodot
    fun checkPurchasesAvailability() {
        client?.let {
            it.purchases.checkPurchasesAvailability()
                .addOnSuccessListener { result ->
                    when (result) {
                        is FeatureAvailabilityResult.Available -> {
                            emitSignal(
                                CHANNEL_CHECK_PURCHASES_AVAILABLE_SUCCESS,
                                "{\"isAvailable\": true, \"detailMessage\": \"\"}"
                            )
                        }
                        is FeatureAvailabilityResult.Unavailable -> {
                            emitSignal(
                                CHANNEL_CHECK_PURCHASES_AVAILABLE_SUCCESS,
                                "{\"isAvailable\": false, \"detailMessage\": \"${result.cause.message}\"}"
                            )
                        }
                    }
                }
                .addOnFailureListener { throwable ->
                    emitSignal(CHANNEL_CHECK_PURCHASES_AVAILABLE_FAILURE, gson.toJson(throwable))
                }
        }
    }

    @UsedByGodot
    fun getProducts(productIds: Array<String>) {
        client?.let {
            it.products.getProducts(
                productIds = productIds.asList()
            )
                .addOnSuccessListener { result ->
                    emitSignal(CHANNEL_ON_GET_PRODUCTS_SUCCESS, gson.toJson(result))
                }
                .addOnFailureListener { throwable ->
                    emitSignal(CHANNEL_ON_GET_PRODUCTS_FAILURE, gson.toJson(throwable))
                }
        }
    }

    @UsedByGodot
    fun purchaseProduct(productId: String, params: Dictionary) {
        val orderId = params["order_id"]?.toString()
        val quantity = params["quantity"] as? Int
        val payload = params["payload"]?.toString()

        client?.let {
            it.purchases.purchaseProduct(
                productId = productId,
                orderId = orderId,
                quantity = quantity,
                developerPayload = payload
            )
                .addOnSuccessListener { result ->
                    val json = """{"type":"${result.javaClass.simpleName}","data":${gson.toJson(result)}}"""
                    emitSignal(CHANNEL_ON_PURCHASE_PRODUCT_SUCCESS, json)
                }
                .addOnFailureListener { throwable ->
                    emitSignal(CHANNEL_ON_PURCHASE_PRODUCT_FAILURE, gson.toJson(throwable))
                }
        }
    }

    @UsedByGodot
    fun getPurchases() {
        client?.let {
            it.purchases.getPurchases()
                .addOnSuccessListener { result ->
                    emitSignal(CHANNEL_ON_GET_PURCHASES_SUCCESS, gson.toJson(result))
                }
                .addOnFailureListener { throwable ->
                    emitSignal(CHANNEL_ON_GET_PURCHASES_FAILURE, gson.toJson(throwable))
                }
        }
    }

    @UsedByGodot
    fun confirmPurchase(purchaseId: String) {
        client?.let {
            it.purchases.confirmPurchase(purchaseId)
                .addOnSuccessListener {
                    emitSignal(CHANNEL_ON_CONFIRM_PURCHASE_SUCCESS, purchaseId)
                }
                .addOnFailureListener { throwable ->
                    emitSignal(CHANNEL_ON_CONFIRM_PURCHASE_FAILURE, purchaseId, gson.toJson(throwable))
                }
        }
    }

    @UsedByGodot
    fun deletePurchase(purchaseId: String) {
        client?.let {
            it.purchases.deletePurchase(purchaseId)
                .addOnSuccessListener {
                    emitSignal(CHANNEL_ON_DELETE_PURCHASE_SUCCESS, purchaseId)
                }
                .addOnFailureListener { throwable ->
                    emitSignal(CHANNEL_ON_DELETE_PURCHASE_FAILURE, purchaseId, gson.toJson(throwable))
                }
        }
    }

    @UsedByGodot
    fun getPurchaseInfo(purchaseId: String) {
        client?.let {
            it.purchases.getPurchaseInfo(purchaseId)
                .addOnSuccessListener { result ->
                    emitSignal(CHANNEL_ON_GET_PURCHASE_INFO_SUCCESS, gson.toJson(result))
                }
                .addOnFailureListener { throwable ->
                    emitSignal(CHANNEL_ON_GET_PURCHASE_INFO_FAILURE, purchaseId, gson.toJson(throwable))
                }
        }
    }

    @UsedByGodot
    fun setTheme(themeCode: Int) {
        RuStoreBillingClientThemeProviderImpl.setTheme(themeCode)
    }

    override fun onMainActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onMainActivityResult(requestCode, resultCode, data)

        if (data != null) {
            client!!.onNewIntent(data)
        }
    }

    override fun d(e: Throwable?, message: () -> String) {
        emitSignal(CHANNEL_ON_PAYMENT_LOGGER_DEBUG, gson.toJson(e) ?: String(), message)
    }

    override fun e(e: Throwable?, message: () -> String) {
        emitSignal(CHANNEL_ON_PAYMENT_LOGGER_ERROR, gson.toJson(e) ?: String(), message)
    }

    override fun i(e: Throwable?, message: () -> String) {
        emitSignal(CHANNEL_ON_PAYMENT_LOGGER_INFO, gson.toJson(e) ?: String(), message)
    }

    override fun v(e: Throwable?, message: () -> String) {
        emitSignal(CHANNEL_ON_PAYMENT_LOGGER_VERBOSE, gson.toJson(e) ?: String(), message)
    }

    override fun w(e: Throwable?, message: () -> String) {
        emitSignal(CHANNEL_ON_PAYMENT_LOGGER_WARNING, gson.toJson(e) ?: String(), message)
    }
}
