# RuStorePaymentResult
# @brief Родительский класс результатов покупки.
class_name RuStorePaymentResult extends Object

# @brief Результат успешного завершения покупки цифрового товара.
class Success extends RuStorePaymentResult:
	# @brief
	#	Уникальный идентификатор оплаты, сформированный приложением (опциональный параметр).
	#	Если вы укажете этот параметр в вашей системе, вы получите его в ответе при работе с API.
	#	Если не укажете, он будет сгенерирован автоматически (uuid).
	#	Максимальная длина 150 символов.
	var orderId = null
	
	# @brief Идентификатор покупки.
	var purchaseId: String = ""
	
	# @brief Идентификатор продукта, который был присвоен продукту в консоли RuStore.
	var productId: String = ""
	
	# @brief Идентификатор счёта.
	var invoiceId: String = ""
	
	# @brief Токен для валидации покупки на сервере.
	var subscriptionToken = null
	
	# @brief
	#	Определяет, является ли платёж тестовым.
	#	Значения могут быть true или false, где true обозначает тестовый платёж, а false – реальный.
	var sandbox: bool = false
	
	func _init(json: String = ""):
		if json != "":
			var obj = JSON.parse_string(json)
			if obj.has("orderId"):
				orderId = obj["orderId"]
			
			purchaseId = obj["purchaseId"]
			productId = obj["productId"]
			invoiceId = obj["invoiceId"]
			sandbox = obj["sandbox"]
			
			if obj.has("subscriptionToken"):
				subscriptionToken = obj["subscriptionToken"]

# @brief
#	Запрос на покупку отправлен,
#	при этом пользователь закрыл «платёжную шторку» на своём устройстве,
#	и результат оплаты неизвестен.
class Cancelled extends RuStorePaymentResult:
	# @brief Идентификатор покупки.
	var purchaseId: String
	
	# @brief
	#	Определяет, является ли платёж тестовым.
	#	Значения могут быть true или false,
	#	где true обозначает тестовый платёж, а false – реальный.
	var sandbox: bool = false
	
	func _init(json: String = ""):
		if json != "":
			var obj = JSON.parse_string(json)
			purchaseId = obj["purchaseId"]
			sandbox = obj["sandbox"]

# @brief
#	При отправке запроса на оплату или получения статуса оплаты возникла проблема,
#	невозможно установить статус покупки.
class Failure extends RuStorePaymentResult:
	# @brief Идентификатор покупки.
	var purchaseId = null
	
	# @brief Идентификатор счёта.
	var invoiceId = null
	
	# @brief
	#	Уникальный идентификатор оплаты, сформированный приложением (необязательный параметр).
	#	Если вы укажете этот параметр в вашей системе, вы получите его в ответе при работе с API.
	#	Если не укажете, он будет сгенерирован автоматически (uuid).
	#	Максимальная длина 150 символов.
	var orderId = null
	
	# @brief Количество продукта (необязательный параметр).
	var quantity = null
	
	# @brief Идентификатор продукта, который был присвоен продукту в консоли RuStore.
	var productId = null
	
	# @brief Код ошибки.
	var errorCode = null
	
	# @brief
	#	Определяет, является ли платёж тестовым.
	#	Значения могут быть true или false,
	#	где true обозначает тестовый платёж, а false – реальный.
	var sandbox: bool = false
	
	func _init(json: String = ""):
		if json != "":
			var obj = JSON.parse_string(json)
			if obj.has("purchaseId"): purchaseId = obj["purchaseId"]
			if obj.has("invoiceId"): invoiceId = obj["invoiceId"]
			if obj.has("orderId"): orderId = obj["orderId"]
			if obj.has("quantity"): quantity = int(obj["quantity"])
			if obj.has("productId"): productId = obj["productId"]
			if obj.has("errorCode"): errorCode = int(obj["errorCode"])
			sandbox = obj["sandbox"]

# @brief
#	Ошибка работы SDK платежей.
#	Может возникнуть, в случае некорректного обратного deeplink.
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
