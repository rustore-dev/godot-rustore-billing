package ru.rustore.godot.billing

import ru.rustore.sdk.billingclient.presentation.BillingClientTheme
import ru.rustore.sdk.billingclient.provider.BillingClientThemeProvider

object RuStoreBillingClientThemeProviderImpl : BillingClientThemeProvider {

    private var theme: BillingClientTheme = BillingClientTheme.Light

    @Synchronized
    fun setTheme(themeCode: Int) {
        theme = when (themeCode) {
            0 -> BillingClientTheme.Dark
            else -> BillingClientTheme.Light
        }
    }

    @Synchronized
    override fun provide(): BillingClientTheme = theme
}
