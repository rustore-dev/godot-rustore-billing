class_name RuStoreGodotBillingClient extends Object

const SINGLETON_NAME = "RuStoreGodotBilling"

var _isInitialized: bool = false
var _clientWrapper: Object = null

var _core_client: RuStoreGodotCoreUtils = null

signal on_check_purchases_availability_success
signal on_check_purchases_availability_failure
signal on_get_products_success
signal on_get_products_failure
signal on_purchase_product_success
signal on_purchase_product_failure
signal on_get_purchases_success
signal on_get_purchases_failure
signal on_confirm_purchase_success
signal on_confirm_purchase_failure
signal on_delete_purchase_success
signal on_delete_purchase_failure
signal on_get_purchase_info_success
signal on_get_purchase_info_failure

static var _instance: RuStoreGodotBillingClient = null


static func get_instance() -> RuStoreGodotBillingClient:
	if _instance == null:
		_instance = RuStoreGodotBillingClient.new()
	return _instance


func init(consoleApplicationId: String, deeplinkScheme: String):
	_core_client = RuStoreGodotCoreUtils.get_instance()
	
	if _isInitialized == false && Engine.has_singleton(SINGLETON_NAME):
		_clientWrapper = Engine.get_singleton(SINGLETON_NAME)
		_clientWrapper.rustore_check_purchases_available_success.connect(_on_check_purchases_availability_success)
		_clientWrapper.rustore_check_purchases_available_failure.connect(_on_check_purchases_availability_failure)
		_clientWrapper.rustore_on_get_products_success.connect(_on_get_products_success)
		_clientWrapper.rustore_on_get_products_failure.connect(_on_get_products_failure)
		_clientWrapper.rustore_on_purchase_product_success.connect(_on_purchase_product_success)
		_clientWrapper.rustore_on_purchase_product_failure.connect(_on_purchase_product_failure)
		_clientWrapper.rustore_on_get_purchases_success.connect(_on_get_purchases_success)
		_clientWrapper.rustore_on_get_purchases_failure.connect(_on_get_purchases_failure)	
		_clientWrapper.rustore_on_confirm_purchase_success.connect(_on_confirm_purchase_success)
		_clientWrapper.rustore_on_confirm_purchase_failure.connect(_on_confirm_purchase_failure)
		_clientWrapper.rustore_on_delete_purchase_success.connect(_on_delete_purchase_success)
		_clientWrapper.rustore_on_delete_purchase_failure.connect(_on_delete_purchase_failure)
		_clientWrapper.rustore_on_get_purchase_info_success.connect(_on_get_purchase_info_success)
		_clientWrapper.rustore_on_get_purchase_info_failure.connect(_on_get_purchase_info_failure)
		
		_clientWrapper.init(consoleApplicationId, deeplinkScheme)
		_isInitialized = true


# Theme switcher
func setTheme(themeCode: int):
	_clientWrapper.setTheme(themeCode)


# Check purchases availability
func check_purchases_availability():
	_clientWrapper.checkPurchasesAvailability()

func _on_check_purchases_availability_success(data: String):
	var obj = RuStoreFeatureAvailabilityResult.new(data)
	on_check_purchases_availability_success.emit(obj)

func _on_check_purchases_availability_failure(data: String):
	var obj = RuStoreError.new(data)
	on_check_purchases_availability_failure.emit(obj)


# Get products
func get_products(productIds: Array):
	_clientWrapper.getProducts(productIds)

func _on_get_products_success(data: String):
	var obj_arr = []
	var str_arr = JSON.parse_string(data)
	for str_item in str_arr:
		var obj_item = RuStoreProduct.new(str(str_item))
		obj_arr.append(obj_item)
	on_get_products_success.emit(obj_arr)

func _on_get_products_failure(data: String):
	var obj = RuStoreError.new(data)
	on_get_products_failure.emit(obj)


# Purchase product
func purchase_product(productId: String, params: Dictionary = {}):
	_clientWrapper.purchaseProduct(productId, params)

func _on_purchase_product_success(data: String):
	var obj = RuStorePaymentResult.parse(data)
	on_purchase_product_success.emit(obj)

func _on_purchase_product_failure(data: String):
	var obj = RuStoreError.new(data)
	on_purchase_product_failure.emit(obj)


# Get purchases
func get_purchases():
	_clientWrapper.getPurchases()

func _on_get_purchases_success(data: String):
	var obj_arr = []
	var str_arr = JSON.parse_string(data)
	for str_item in str_arr:
		var obj_item = RuStorePurchase.new(str(str_item))
		obj_arr.append(obj_item)
	on_get_purchases_success.emit(obj_arr)

func _on_get_purchases_failure(data: String):
	var obj = RuStoreError.new(data)
	on_get_purchases_failure.emit(obj)


# Confirm purchase
func confirm_purchase(purchase_id: String):
	_clientWrapper.confirmPurchase(purchase_id)

func _on_confirm_purchase_success(purchase_id: String):
	on_confirm_purchase_success.emit(purchase_id)

func _on_confirm_purchase_failure(purchase_id: String, data: String):
	var obj = RuStoreError.new(data)
	on_confirm_purchase_failure.emit(purchase_id, obj)


# Delete purchase
func delete_purchase(purchase_id: String):
	_clientWrapper.deletePurchase(purchase_id)

func _on_delete_purchase_success(purchase_id: String):
	on_delete_purchase_success.emit(purchase_id)

func _on_delete_purchase_failure(purchase_id: String, data: String):
	var obj = RuStoreError.new(data)
	on_delete_purchase_failure.emit(purchase_id, obj)


# Get purchase info
func get_purchase_info(purchase_id: String):
	_clientWrapper.getPurchaseInfo(purchase_id)

func _on_get_purchase_info_success(data: String):
	var obj = RuStorePurchase.new(data)
	on_get_purchase_info_success.emit(obj)

func _on_get_purchase_info_failure(purchase_id: String, data: String):
	var obj = RuStoreError.new(data)
	on_get_purchase_info_failure.emit(purchase_id, obj)
