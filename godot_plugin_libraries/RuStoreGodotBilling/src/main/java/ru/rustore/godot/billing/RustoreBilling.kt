package ru.rustore.godot.billing

import android.content.Intent
import android.util.ArraySet
import android.util.Log
import com.google.gson.Gson
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot
import ru.rustore.sdk.billingclient.RuStoreBillingClient
import ru.rustore.sdk.billingclient.RuStoreBillingClientFactory
import ru.rustore.sdk.billingclient.model.product.Product
import ru.rustore.sdk.billingclient.model.purchase.PaymentResult
import ru.rustore.sdk.billingclient.model.purchase.Purchase
import ru.rustore.sdk.core.feature.model.FeatureAvailabilityResult
import ru.rustore.sdk.core.tasks.OnCompleteListener

class RuStoreGodotBilling(godot: Godot?) : GodotPlugin(godot) {
    private companion object {
        const val CANCELLED = "cancelled"
        const val SUCCESS = "success"
        const val FAILURE = "failure"

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

        return signals
    }

    private var client: RuStoreBillingClient? = null
    private val gson = Gson()

    @UsedByGodot
    fun init(id: String, scheme: String) {
        client = RuStoreBillingClientFactory.create(
            context = godot.requireContext(),
            consoleApplicationId = id,
            deeplinkScheme = scheme,
            internalConfig = mapOf(
                "type" to "godot"
            ),
            themeProvider = RuStoreBillingClientThemeProviderImpl
        )
    }

    @UsedByGodot
    fun checkPurchasesAvailability() {
        client?.let {
            it.purchases.checkPurchasesAvailability()
                .addOnCompleteListener(object : OnCompleteListener<FeatureAvailabilityResult> {
                    override fun onSuccess(result: FeatureAvailabilityResult) {
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

                    override fun onFailure(throwable: Throwable) {
                        emitSignal(CHANNEL_CHECK_PURCHASES_AVAILABLE_FAILURE, gson.toJson(throwable))
                    }
                })
        }
    }

    @UsedByGodot
    fun getProducts(productIds: Array<String>) {
        client?.let {
            it.products.getProducts(
                productIds = productIds.asList()
            ).addOnCompleteListener(object : OnCompleteListener<List<Product>> {
                override fun onSuccess(result: List<Product>) {
                    emitSignal(CHANNEL_ON_GET_PRODUCTS_SUCCESS, gson.toJson(result))
                }

                override fun onFailure(throwable: Throwable) {
                    emitSignal(CHANNEL_ON_GET_PRODUCTS_FAILURE, gson.toJson(throwable))
                }
            })
        }
    }

    @UsedByGodot
    fun purchaseProduct(productId: String, params: Dictionary) {
        val orderId = params["order_id"]?.toString()
        val quantity = params["quantity"] as? Int
        val payload = params["payload"]?.toString()

        client?.let {
            Log.w("ssss", productId)
            it.purchases.purchaseProduct(
                productId = productId,
                orderId = orderId,
                quantity = quantity,
                developerPayload = payload
            ).addOnCompleteListener(object : OnCompleteListener<PaymentResult> {
                override fun onSuccess(result: PaymentResult) {
                    val json = """{"type":"${result.javaClass.simpleName}","data":${gson.toJson(result)}}"""
                    emitSignal(CHANNEL_ON_PURCHASE_PRODUCT_SUCCESS, json)
                }

                override fun onFailure(throwable: Throwable) {
                    emitSignal(CHANNEL_ON_PURCHASE_PRODUCT_FAILURE, gson.toJson(throwable))
                }
            })
        }
    }

    @UsedByGodot
    fun getPurchases() {
        client?.let {
            it.purchases.getPurchases()
                .addOnCompleteListener(object : OnCompleteListener<List<Purchase>> {
                    override fun onSuccess(result: List<Purchase>) {
                        emitSignal(CHANNEL_ON_GET_PURCHASES_SUCCESS, gson.toJson(result))
                    }

                    override fun onFailure(throwable: Throwable) {
                        emitSignal(CHANNEL_ON_GET_PURCHASES_FAILURE, gson.toJson(throwable))
                    }
                })
        }
    }

    @UsedByGodot
    fun confirmPurchase(purchaseId: String) {
        client?.let {
            it.purchases.confirmPurchase(
                purchaseId = purchaseId
            ).addOnCompleteListener(object : OnCompleteListener<Unit> {
                override fun onSuccess(result: Unit) {
                    emitSignal(CHANNEL_ON_CONFIRM_PURCHASE_SUCCESS, purchaseId)
                }

                override fun onFailure(throwable: Throwable) {
                    emitSignal(CHANNEL_ON_CONFIRM_PURCHASE_FAILURE, purchaseId, gson.toJson(throwable))
                }
            })
        }
    }

    @UsedByGodot
    fun deletePurchase(purchaseId: String) {
        client?.let {
            it.purchases.deletePurchase(
                purchaseId = purchaseId
            ).addOnCompleteListener(object : OnCompleteListener<Unit> {
                override fun onSuccess(result: Unit) {
                    emitSignal(CHANNEL_ON_DELETE_PURCHASE_SUCCESS, purchaseId)
                }

                override fun onFailure(throwable: Throwable) {
                    emitSignal(CHANNEL_ON_DELETE_PURCHASE_FAILURE, purchaseId, gson.toJson(throwable))
                }
            })
        }
    }

    @UsedByGodot
    fun getPurchaseInfo(purchaseId: String) {
        client?.let {
            it.purchases.getPurchaseInfo(purchaseId)
                .addOnCompleteListener(object : OnCompleteListener<Purchase> {
                    override fun onSuccess(result: Purchase) {
                        emitSignal(CHANNEL_ON_GET_PURCHASE_INFO_SUCCESS, gson.toJson(result))
                    }

                    override fun onFailure(throwable: Throwable) {
                        emitSignal(CHANNEL_ON_GET_PURCHASE_INFO_FAILURE, purchaseId, gson.toJson(throwable))
                    }
                })
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
}
