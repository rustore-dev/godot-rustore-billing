# RuStoreProduct
# @brief Информация о продукте.
class_name RuStoreProduct extends Object

# @brief Идентификатор продукта, который был присвоен продукту в консоли RuStore.
var productId: String = ""

# @brief Отформатированная цена товара, включая валютный знак на языке language.
var productStatus: ERuStoreProductStatus.Item = 0

# @brief Тип продукта (необязательный параметр).
var productType = null

# @brief Отформатированная цена товара, включая валютный знак на языке language.
var priceLabel = null

# @brief Цена в минимальных единицах (например в копейках) (необязательный параметр).
var price = null

# @brief Код валюты ISO 4217.
var currency = null

# @brief Язык, указанный с помощью BCP 47 кодирования.
var language = null

# @brief Название продукта на языке language.
var title = null

# @brief Описание на языке language.
var description = null

# @brief Ссылка на картинку.
var imageUrl = null

# @brief Ссылка на промокартинку.
var promoImageUrl = null

# @brief Описание подписки, возвращается только для продуктов с типом SUBSCRIPTION.
var subscription: RuStoreProductSubscription = null

func _init(json: String = ""):
	if json != "":
		var obj = JSON.parse_string(json)
		productId = obj["productId"]
		productStatus = ERuStoreProductStatus.Item.get(obj["productStatus"])
		
		if obj.has("productType"):
			productType = ERuStoreProductType.Item.get(obj["productType"])
		
		if obj.has("priceLabel"):
			priceLabel = obj.get("priceLabel")
		
		if obj.has("price"):
			price = int(obj["price"])
		
		if obj.has("currency"):
			currency = obj.get("currency")
		
		if obj.has("language"):
			language = obj.get("language")
		
		if obj.has("title"):
			title = obj.get("title")
		
		if obj.has("description"):
			description = obj.get("description")
		
		if obj.has("imageUrl"):
			imageUrl = obj["imageUrl"]
		
		if obj.has("promoImageUrl"):
			promoImageUrl = obj["promoImageUrl"]
		
		if obj.has("subscription"):
			subscription = RuStoreProductSubscription.new(str(obj["subscription"]))
