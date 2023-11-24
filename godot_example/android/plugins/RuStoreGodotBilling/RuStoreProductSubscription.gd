class_name RuStoreProductSubscription extends Object

var subscriptionPeriod: RuStoreSubscriptionPeriod = null
var freeTrialPeriod: RuStoreSubscriptionPeriod = null
var gracePeriod: RuStoreSubscriptionPeriod = null
var introductoryPrice: String = ""
var introductoryPriceAmount: String = ""
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
