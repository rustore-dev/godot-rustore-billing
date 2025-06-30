# RuStoreProductSubscription
# @brief Информация о подписке.
class_name RuStoreProductSubscription extends RefCounted

# @brief Период подписки.
var subscriptionPeriod: RuStoreSubscriptionPeriod = null

# @brief Пробный период подписки.
var freeTrialPeriod: RuStoreSubscriptionPeriod = null

# @brief Льготный период подписки.
var gracePeriod: RuStoreSubscriptionPeriod = null

# @brief Отформатированная вступительная цена подписки, включая знак валюты, на языке RuStoreProduct.language.
var introductoryPrice: String = ""

# @brief Вступительная цена в минимальных единицах валюты (напрмер в копейках).
var introductoryPriceAmount: String = ""

# @brief Расчётный период вступительной цены.
var introductoryPricePeriod: RuStoreSubscriptionPeriod = null

func _init(json: String = ""):
	if json != "":
		var obj = JSON.parse_string(json)
		
		if obj.has("subscriptionPeriod"):
			subscriptionPeriod = RuStoreSubscriptionPeriod.new(str(obj["subscriptionPeriod"]))
		
		if obj.has("freeTrialPeriod"):
			freeTrialPeriod = RuStoreSubscriptionPeriod.new(obj["freeTrialPeriod"])
		
		if obj.has("gracePeriod"):
			gracePeriod = RuStoreSubscriptionPeriod.new(obj["gracePeriod"])
		
		if obj.has("introductoryPrice"):
			introductoryPrice = obj["introductoryPrice"]
		
		if obj.has("introductoryPriceAmount"):
			introductoryPriceAmount = obj["introductoryPriceAmount"]
		
		if obj.has("introductoryPricePeriod"):
			introductoryPricePeriod = RuStoreSubscriptionPeriod.new(obj["introductoryPricePeriod"])
