class_name RuStorePurchase extends Node

var purchaseId: String = ""
var productId: String = ""
var productType: ERuStoreProductType.Item = ERuStoreProductType.Item.NON_CONSUMABLE
var invoiceId: String = ""
var description: String = ""
var language: String = ""
var purchaseTime: String = ""
var orderId: String = ""
var amountLabel: String = ""
var amount: int = 0
var currency: String = ""
var quantity: int = 0
var purchaseState: ERuStorePurchaseState.Item = ERuStorePurchaseState.Item.CANCELLED
var developerPayload: String = ""
var subscriptionToken: String = ""

func _init(json: String = ""):
	if json != "":
		var obj = JSON.parse_string(json)
		if obj.has("purchaseId"): purchaseId = obj["purchaseId"]
		productId = obj["productId"]
		if obj.has("productType"): productType = ERuStoreProductType.Item.get(obj["productType"])
		if obj.has("invoiceId"): invoiceId = obj["invoiceId"]
		if obj.has("description"): description = obj["description"]
		if obj.has("language"): language = obj["language"]
		if obj.has("purchaseTime"): purchaseTime = obj["purchaseTime"]#RuStoreDateTime
		if obj.has("orderId"): orderId = obj["orderId"]
		if obj.has("amountLabel"): amountLabel = obj["amountLabel"]
		if obj.has("amount"): amount = int(obj["amount"])
		if obj.has("currency"): currency = obj["currency"]
		if obj.has("quantity"): quantity = int(obj["quantity"])
		if obj.has("purchaseState"): purchaseState = ERuStorePurchaseState.Item.get(obj["purchaseState"])
		if obj.has("developerPayload"): developerPayload = obj["developerPayload"]
		if obj.has("subscriptionToken"): subscriptionToken = obj["subscriptionToken"]
