class_name RuStoreProduct extends Object

var productId: String = ""
var productStatus: ERuStoreProductStatus.Item = 0

var productType: ERuStoreProductType.Item = 0
var priceLabel: String = ""
var price: int = 0
var currency: String = ""
var language: String = ""
var title: String = ""
var description: String = ""
var imageUrl: String = ""
var promoImageUrl: String = ""
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
			imageUrl = ""#obj["imageUrl"]
		
		if obj.has("promoImageUrl"):
			promoImageUrl = ""#obj["promoImageUrl"]
		
		if obj.has("subscription"):
			subscription = RuStoreProductSubscription.new(str(obj["subscription"]))
