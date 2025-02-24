class_name RuStoreBillingJsonParser extends Object

static func ToPurchaseAvailabilityResult(json: String = "") -> RuStorePurchaseAvailabilityResult:
	var result: RuStorePurchaseAvailabilityResult = null
	
	if json != "":
		var obj = JSON.parse_string(json)
		result = RuStorePurchaseAvailabilityResult.new()
		result.isAvailable = obj["isAvailable"]
		
		if obj.has("cause"):
			var jcause = JSON.stringify(obj["cause"])
			result.cause = RuStoreError.new(jcause)
	
	return result

static func ToUserAuthorizationStatus(json: String = "") -> RuStoreBillingUserAuthorizationStatus:
	var result: RuStoreBillingUserAuthorizationStatus = null
	
	if json != "":
		var obj = JSON.parse_string(json)
		result = RuStoreBillingUserAuthorizationStatus.new()
		result.authorized = obj["authorized"]
	
	return result
