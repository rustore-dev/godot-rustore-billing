# RuStorePurchase
# @brief Информация о покупке.
class_name RuStorePurchase extends Node

# @brief Идентификатор покупки.
var purchaseId = null

# @brief Идентификатор продукта, который был присвоен продукту в консоли RuStore.
var productId: String = ""

# @brief Тип продукта.
var productType = null

# @brief Идентификатор счёта.
var invoiceId = null

# @brief Язык, указанный с помощью BCP 47 кодирования.
var language = null

# @brief Время покупки.
var purchaseTime = null

# @brief
#	Уникальный идентификатор оплаты, сформированный приложением (опциональный параметр).
#	Если вы укажете этот параметр в вашей системе, вы получите его в ответе при работе с API.
#	Если не укажете, он будет сгенерирован автоматически (uuid).
#	Максимальная длина 150 символов.
var orderId = null

# @brief Отформатированная цена покупки, включая валютный знак.
var amountLabel = null

# @brief Цена в минимальных единицах валюты (например в копейках).
var amount = null

# @brief Код валюты ISO 4217.
var currency = null

# @brief Количество продукта.
var quantity = null

# @brief Состояние покупки.
var purchaseState = null

# @brief
#	Строка с дополнительной информацией о заказе,
#	которую вы можете установить при инициализации процесса покупки.
var developerPayload = null

# @brief Токен для валидации покупки на сервере.
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
