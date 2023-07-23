package ru.rustore.billing

import android.util.ArraySet
import android.util.Log
import org.godotengine.godot.Dictionary
import org.godotengine.godot.Godot
import org.godotengine.godot.plugin.GodotPlugin
import org.godotengine.godot.plugin.SignalInfo
import org.godotengine.godot.plugin.UsedByGodot
import ru.rustore.sdk.billingclient.RuStoreBillingClient
import ru.rustore.sdk.billingclient.RuStoreBillingClientFactory
import ru.rustore.sdk.billingclient.model.purchase.PaymentResult
import ru.rustore.sdk.core.feature.model.FeatureAvailabilityResult

class RustoreBilling(godot: Godot?) : GodotPlugin(godot) {
    lateinit var client: RuStoreBillingClient

    override fun getPluginName(): String {
        return "RustoreBilling"
    }

    @UsedByGodot
    fun init(id: String, scheme: String) {
        client = RuStoreBillingClientFactory.create(
            context = godot.requireContext(),
            consoleApplicationId = id,
            deeplinkScheme = scheme,
            internalConfig = mapOf(
                "type" to "godot"
            )
        )
    }

    override fun getPluginSignals(): Set<SignalInfo> {
        val signals: MutableSet<SignalInfo> = ArraySet()
        signals.add(SignalInfo(CHANNEL_IS_AVAILABLE, Dictionary::class.java))
        signals.add(SignalInfo(CHANNEL_PURCHASE_PRODUCT, Dictionary::class.java))
        signals.add(SignalInfo(CHANNEL_DELETE_PURCHASE, Dictionary::class.java))
        signals.add(SignalInfo(CHANNEL_CONFIRM_PURCHASE, Dictionary::class.java))
        signals.add(SignalInfo(CHANNEL_GET_PURCHASES, Dictionary::class.java))
        signals.add(SignalInfo(CHANNEL_GET_PURCHASE, Dictionary::class.java))
        signals.add(SignalInfo(CHANNEL_GET_PROUCTS, Dictionary::class.java))
        return signals
    }

    @UsedByGodot
    fun isAvailable() {
        val response = Dictionary()

        client.purchases.checkPurchasesAvailability().addOnSuccessListener { result ->
            when (result) {
                is FeatureAvailabilityResult.Available -> {
                    response.put("result", "available")
                }

                is FeatureAvailabilityResult.Unavailable -> {
                    response.put("result", "unavailable")
                }

                else -> Unit
            }

            response.put("status", SUCCESS)
            emitSignal(CHANNEL_IS_AVAILABLE, response)
        }.addOnFailureListener { throwable ->
            Log.w("RustoreBilling.isAvailable", throwable.message.orEmpty())

            response.put("status", FAILURE)
            emitSignal(CHANNEL_IS_AVAILABLE, response)
        }
    }

    @UsedByGodot
    fun getProducts(ids: Array<String>) {
        val response = Dictionary()

        client.products.getProducts(ids.asList()).addOnSuccessListener { products ->
            Log.w("getProducts", products.toString())

            val data = Dictionary()

            products.forEach { product ->
                val item = Dictionary()
                item.put("product_id", product.productId)
                item.put("title", product.title.orEmpty())
                item.put("description", product.description.orEmpty())
                item.put("image_url", product.imageUrl.toString())
                item.put("promo_image_url", product.promoImageUrl.toString())
                item.put("price", product.price)
                item.put("price_label", product.priceLabel.orEmpty())
                item.put("currency", product.currency.orEmpty())
                item.put("product_status", product.productStatus.toString())
                item.put("product_type", product.productType.toString())

                if (product.subscription != null) {
                    val subscription = Dictionary()

                    if (product.subscription?.freeTrialPeriod != null) {
                        val period = Dictionary()
                        period.put("days", product.subscription?.freeTrialPeriod?.days ?: 0)
                        period.put("month", product.subscription?.freeTrialPeriod?.months ?: 0)
                        period.put("years", product.subscription?.freeTrialPeriod?.years ?: 0)

                        subscription.put("free_trial_period", period)
                    }

                    if (product.subscription?.gracePeriod != null) {
                        val period = Dictionary()
                        period.put("days", product.subscription?.gracePeriod?.days ?: 0)
                        period.put("month", product.subscription?.gracePeriod?.months ?: 0)
                        period.put("years", product.subscription?.gracePeriod?.years ?: 0)

                        subscription.put("grace_period", period)
                    }

                    if (product.subscription?.introductoryPricePeriod != null) {
                        val period = Dictionary()
                        period.put("days", product.subscription?.introductoryPricePeriod?.days ?: 0)
                        period.put(
                            "month",
                            product.subscription?.introductoryPricePeriod?.months ?: 0
                        )
                        period.put(
                            "years",
                            product.subscription?.introductoryPricePeriod?.years ?: 0
                        )

                        subscription.put("introductory_price_period", period)
                    }

                    if (product.subscription?.subscriptionPeriod != null) {
                        val period = Dictionary()
                        period.put("days", product.subscription?.subscriptionPeriod?.days ?: 0)
                        period.put("month", product.subscription?.subscriptionPeriod?.months ?: 0)
                        period.put("years", product.subscription?.subscriptionPeriod?.years ?: 0)

                        subscription.put("subscription_period", period)
                    }

                    subscription.put(
                        "introductory_price",
                        product.subscription?.introductoryPrice.orEmpty()
                    )
                    subscription.put(
                        "introductory_price_amount",
                        product.subscription?.introductoryPriceAmount.orEmpty()
                    )

                    item.put("subscription", subscription)
                }

                data.put(product.productId, item)
            }

            response.put("status", SUCCESS)
            response.put("items", data)

            emitSignal(CHANNEL_GET_PROUCTS, response)
        }.addOnFailureListener { throwable ->
            Log.w("RustoreBilling.getProducts", throwable.message.orEmpty())

            response.put("status", FAILURE)
            response.put("message", throwable.message.orEmpty())

            emitSignal(CHANNEL_GET_PURCHASES, response)
        }
    }

    @UsedByGodot
    fun getPurchases() {
        val response = Dictionary()

        client.purchases.getPurchases().addOnSuccessListener { purchases ->
            val data = Dictionary()

            purchases.forEach { purchase ->
                val item = Dictionary()
                item.put("purchase_id", purchase.purchaseId.orEmpty())
                item.put("amount", purchase.amount ?: 0)
                item.put("amount_label", purchase.amountLabel.orEmpty())
                item.put("currency", purchase.currency.orEmpty())
                item.put("description", purchase.description.orEmpty())
                item.put("developer_payload", purchase.developerPayload.orEmpty())
                item.put("invoice_id", purchase.invoiceId.orEmpty())
                item.put("language", purchase.language.orEmpty())
                item.put("order_id", purchase.orderId.orEmpty())
                item.put("product_id", purchase.productId)
                item.put("product_type", purchase.productType.toString())
                item.put("purchase_state", purchase.purchaseState.toString())
                item.put("purchase_time", purchase.purchaseTime.toString())
                item.put("quantity", purchase.quantity ?: 0)
                item.put("subscription_token", purchase.subscriptionToken.orEmpty())

                data.put(purchase.purchaseId, item)
            }

            response.put("status", SUCCESS)
            response.put("items", data)

            emitSignal(CHANNEL_GET_PURCHASES, response)
        }.addOnFailureListener { throwable ->
            Log.w("RustoreBilling.getPurchases", throwable.message.orEmpty())

            response.put("status", FAILURE)
            response.put("message", throwable.message.orEmpty())

            emitSignal(CHANNEL_GET_PURCHASES, response)
        }
    }

    @UsedByGodot
    fun purchaseProduct(product: String) {
        val response = Dictionary()

        client.purchases.purchaseProduct(product)
            .addOnSuccessListener { payment ->
                when (payment) {
                    is PaymentResult.Cancelled -> {
                        response.put("status", CANCELLED)
                        response.put("purchase", payment.purchaseId)
                    }

                    is PaymentResult.Success -> {
                        response.put("status", SUCCESS)
                        response.put("purchase", payment.purchaseId)
                    }

                    is PaymentResult.Failure -> {
                        response.put("status", FAILURE)
                        response.put("purchase", payment.purchaseId.orEmpty())
                        response.put("error_code", payment.errorCode ?: 0)
                    }

                    else -> Unit
                }

                emitSignal(CHANNEL_PURCHASE_PRODUCT, response)
            }
            .addOnFailureListener { throwable ->
                Log.w("RustoreBilling.purchaseProduct", throwable.message.orEmpty())

                response.put("status", FAILURE)
                response.put("message", throwable.message.orEmpty())

                emitSignal(CHANNEL_PURCHASE_PRODUCT, response)
            }
    }

    @UsedByGodot
    fun deletePurchase(id: String) {
        val response = Dictionary()

        client.purchases.deletePurchase(id)
            .addOnSuccessListener {
                response.put("status", SUCCESS)

                emitSignal(CHANNEL_DELETE_PURCHASE, response)

            }.addOnFailureListener { throwable ->
                Log.w("RustoreBilling.deletePurchase", throwable.message.orEmpty())

                response.put("status", FAILURE)
                response.put("message", throwable.message.orEmpty())

                emitSignal(CHANNEL_DELETE_PURCHASE, response)
            }
    }

    @UsedByGodot
    fun confirmPurchase(id: String) {
        val response = Dictionary()

        client.purchases.confirmPurchase(id)
            .addOnSuccessListener {
                response.put("status", SUCCESS)

                emitSignal(CHANNEL_CONFIRM_PURCHASE, response)
            }.addOnFailureListener { throwable ->
                Log.w("RustoreBilling.confirmPurchase", throwable.message.orEmpty())

                response.put("status", FAILURE)
                response.put("message", throwable.message.orEmpty())

                emitSignal(CHANNEL_CONFIRM_PURCHASE, response)
            }
    }

    @UsedByGodot
    fun purchaseInfo(id: String) {
        val response = Dictionary()

        client.purchases.getPurchaseInfo(id)
            .addOnSuccessListener { purchase ->
                val item = Dictionary()
                item.put("purchase_id", purchase.purchaseId.orEmpty())
                item.put("amount", purchase.amount ?: 0)
                item.put("amount_label", purchase.amountLabel.orEmpty())
                item.put("currency", purchase.currency.orEmpty())
                item.put("description", purchase.description.orEmpty())
                item.put("developer_payload", purchase.developerPayload.orEmpty())
                item.put("invoice_id", purchase.invoiceId.orEmpty())
                item.put("language", purchase.language.orEmpty())
                item.put("order_id", purchase.orderId.orEmpty())
                item.put("product_id", purchase.productId)
                item.put("product_type", purchase.productType.toString())
                item.put("purchase_state", purchase.purchaseState.toString())
                item.put("purchase_time", purchase.purchaseTime.toString())
                item.put("quantity", purchase.quantity ?: 0)
                item.put("subscription_token", purchase.subscriptionToken.orEmpty())

                response.put("purchase", item)
                response.put("status", SUCCESS)

                emitSignal(CHANNEL_GET_PURCHASE, response)
            }.addOnFailureListener { throwable ->
                Log.w("RustoreBilling.purchaseInfo", throwable.message.orEmpty())

                response.put("status", FAILURE)
                response.put("message", throwable.message.orEmpty())

                emitSignal(CHANNEL_GET_PURCHASE, response)
            }
    }

    private companion object {
        const val CANCELLED = "cancelled"
        const val SUCCESS = "success"
        const val FAILURE = "failure"

        const val CHANNEL_IS_AVAILABLE = "rustore_is_available"
        const val CHANNEL_PURCHASE_PRODUCT = "rustore_purchase_product"
        const val CHANNEL_DELETE_PURCHASE = "rustore_delete_purchase"
        const val CHANNEL_CONFIRM_PURCHASE = "rustore_confirm_purchase"
        const val CHANNEL_GET_PURCHASES = "rustore_get_purchases"
        const val CHANNEL_GET_PURCHASE = "rustore_get_purchase"
        const val CHANNEL_GET_PROUCTS = "rustore_get_products"
    }
}
