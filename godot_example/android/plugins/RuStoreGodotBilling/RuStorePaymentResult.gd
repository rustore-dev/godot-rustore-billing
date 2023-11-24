class_name RuStorePaymentResult extends Object

class Success extends RuStorePaymentResult:
	var orderId: String = ""
	var purchaseId: String = ""
	var productId: String = ""
	var invoiceId: String = ""
	var subscriptionToken: String = ""
	
	func _init(json: String = ""):
		if json != "":
			var obj = JSON.parse_string(json)
			if obj.has("orderId"):
				purchaseId = obj["orderId"]
				
			purchaseId = obj["purchaseId"]
			productId = obj["productId"]
			invoiceId = obj["invoiceId"]
			
			if obj.has("subscriptionToken"):
				purchaseId = obj["subscriptionToken"]


class Cancelled extends RuStorePaymentResult:
	var purchaseId: String
	
	func _init(json: String = ""):
		if json != "":
			var obj = JSON.parse_string(json)
			purchaseId = obj["purchaseId"] 


class Failure extends RuStorePaymentResult:
	var purchaseId: String = ""
	var invoiceId: String = ""
	var orderId: String = ""
	var quantity: int = 0
	var productId: String = ""
	var errorCode: int = 0
	
	func _init(json: String = ""):
		if json != "":
			var obj = JSON.parse_string(json)
			if obj.has("purchaseId"): purchaseId = obj["purchaseId"]
			if obj.has("invoiceId"): invoiceId = obj["invoiceId"]
			if obj.has("orderId"): orderId = obj["orderId"]
			if obj.has("quantity"): quantity = int(obj["quantity"])
			if obj.has("productId"): productId = obj["productId"]
			if obj.has("errorCode"): errorCode = int(obj["errorCode"])


class InvalidPaymentState extends RuStorePaymentResult:
	pass

static func parse(json: String):
	var obj = JSON.parse_string(json)
	var type = obj["type"]
	var data = str(obj["data"])

	if type == "Success":
		return Success.new(data)
	elif type == "Cancelled":
		return Cancelled.new(data)
	elif type == "Failure":
		return Failure.new(data)
	elif type == "InvalidPaymentState":
		return InvalidPaymentState.new()
	else:
		return RuStorePaymentResult.new()
