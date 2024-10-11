class_name RuStorePurchase extends Node

var purchaseId = null
var productId: String = ""
var productType = null
var invoiceId = null
var language = null
var purchaseTime = null
var orderId = null
var amountLabel = null
var amount = null
var currency = null
var quantity = null
var purchaseState = null
var developerPayload = null
var subscriptionToken = null

func _init(json: String = ""):
	if json != "":
		var obj = JSON.parse_string(json)
		if obj.has("purchaseId"): purchaseId = obj["purchaseId"]
		productId = obj["productId"]
		if obj.has("productType"): productType = ERuStoreProductType.Item.get(obj["productType"])
		if obj.has("invoiceId"): invoiceId = obj["invoiceId"]
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
