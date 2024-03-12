extends Node2D

@onready var _products_list = $CanvasLayer/VBoxContainer/TabContainer/Products/Products/ProductsList
@onready var _purchases_list = $CanvasLayer/VBoxContainer/TabContainer/Purchases/Purchases/PurchasesList

const APPLICATION_ID = "184062"
const DEEPLINK_SCHEME = "example"
const PRODUCT_IDS = [
	"ue_non_con2",
	"ue_non_con1",
	"ue_con2",
	"ue_con1",
	"ue_sub2",
	"ue_sub1"]

var _core_client: RuStoreGodotCoreUtils = null
var _billing_client: RuStoreGodotBillingClient = null

func _ready():
	_core_client = RuStoreGodotCoreUtils.get_instance()
	
	_billing_client = RuStoreGodotBillingClient.get_instance()
	_billing_client.on_check_purchases_availability_success.connect(_on_check_purchases_availability_success)
	_billing_client.on_check_purchases_availability_failure.connect(_on_check_purchases_availability_failure)
	_billing_client.on_get_products_success.connect(_on_get_products_success)
	_billing_client.on_get_products_failure.connect(_on_get_products_failure)
	_billing_client.on_purchase_product_success.connect(_on_purchase_product_success)
	_billing_client.on_purchase_product_failure.connect(_on_purchase_product_failure)
	_billing_client.on_get_purchases_success.connect(_on_get_purchases_success)
	_billing_client.on_get_purchases_failure.connect(_on_get_purchases_failure)
	_billing_client.on_confirm_purchase_success.connect(_on_confirm_purchase_success)
	_billing_client.on_confirm_purchase_failure.connect(_on_confirm_purchase_failure)
	_billing_client.on_delete_purchase_success.connect(_on_delete_purchase_success)
	_billing_client.on_delete_purchase_failure.connect(_on_delete_purchase_failure)
	_billing_client.on_get_purchase_info_success.connect(_on_get_purchase_info_success)
	_billing_client.on_get_purchase_info_failure.connect(_on_get_purchase_info_failure)
	_billing_client.on_payment_logger_debug.connect(_on_payment_logger_debug)
	_billing_client.on_payment_logger_error.connect(_on_payment_logger_error)
	_billing_client.on_payment_logger_info.connect(_on_payment_logger_info)
	_billing_client.on_payment_logger_verbose.connect(_on_payment_logger_verbose)
	_billing_client.on_payment_logger_warning.connect(_on_payment_logger_warning)
	
	_billing_client.set_error_handling(true)
	_billing_client.init(APPLICATION_ID, DEEPLINK_SCHEME, false)
	_billing_client.set_theme(ERuStoreTheme.Item.DARK)


# Check purchase availability
func _on_check_purchases_availability_button_pressed():
	_billing_client.check_purchases_availability()

func _on_check_purchases_availability_success(result: RuStoreFeatureAvailabilityResult):
	if result.isAvailable:
		_core_client.show_toast("Purchases are available")

func _on_check_purchases_availability_failure(error: RuStoreError):
	_core_client.show_toast(error.description)


# Update products list
func _on_update_products_list_button_pressed():
	_billing_client.get_products(PRODUCT_IDS)

func _on_get_products_success(products: Array):
	for product_panel in _products_list.get_children():
		product_panel.queue_free()
	
	for product in products:
		var product_panel: ProductPanel = load("res://scenes/product.tscn").instantiate()
		_products_list.add_child(product_panel)
		product_panel.set_product(product)
		product_panel.on_purchase_product_pressed.connect(_on_purchase_product_pressed)

func _on_get_products_failure(error: RuStoreError):
	_core_client.show_toast(error.description)


# Purchase product
func _on_purchase_product_pressed(product: RuStoreProduct):
	_billing_client.purchase_product(product.productId)

func _on_purchase_product_success(result: RuStorePaymentResult):
	if result is RuStorePaymentResult.Success:
		_core_client.show_toast("Success")
	elif result is RuStorePaymentResult.Cancelled:
		_core_client.show_toast("Cancelled")
	elif result is RuStorePaymentResult.Failure:
		_core_client.show_toast("Failure")
	elif result is RuStorePaymentResult.InvalidPaymentState:
		_core_client.show_toast("InvalidPaymentState")
	else:
		_core_client.show_toast("RuStorePaymentResult")

func _on_purchase_product_failure(error: RuStoreError):
	_core_client.show_toast(error.description)


# Update purchases list
func _on_update_purchases_list_button_pressed():
	_billing_client.get_purchases()

func _on_get_purchases_success(purchases: Array):
	for purchase_panel in _purchases_list.get_children():
		purchase_panel.queue_free()

	for purchase in purchases:
		var purchase_panel: PurchasePanel = load("res://scenes/purchase.tscn").instantiate()
		_purchases_list.add_child(purchase_panel)
		purchase_panel.set_purchase(purchase)
		purchase_panel.on_confirm_purchase_pressed.connect(_on_confirm_purchase_pressed)
		purchase_panel.on_delete_purchase_pressed.connect(_on_delete_purchase_pressed)
		purchase_panel.on_get_purchase_info_pressed.connect(_on_get_purchase_info_pressed)

func _on_get_purchases_failure(error: RuStoreError):
	_core_client.show_toast(error.description)


# Confirm purchase
func _on_confirm_purchase_pressed(purchase: RuStorePurchase):
	_billing_client.confirm_purchase(purchase.purchaseId, purchase.developerPayload)

func _on_confirm_purchase_success(purchase_id: String):
	_billing_client.get_purchases()
	_core_client.show_toast("Confirm " + purchase_id)

func _on_confirm_purchase_failure(purchase_id: String, error: RuStoreError):
	_core_client.show_toast(purchase_id + " " + error.description)


# Delete purchase
func _on_delete_purchase_pressed(purchase: RuStorePurchase):
	_billing_client.delete_purchase(purchase.purchaseId)

func _on_delete_purchase_success(purchase_id: String):
	_billing_client.get_purchases()
	_core_client.show_toast("Delete " + purchase_id)

func _on_delete_purchase_failure(purchase_id: String, error: RuStoreError):
	_core_client.show_toast(purchase_id + " " + error.description)


# Get purchase info
func _on_get_purchase_info_pressed(purchase: RuStorePurchase):
	_billing_client.get_purchase_info(purchase.purchaseId)

func _on_get_purchase_info_success(purchase: RuStorePurchase):
	OS.alert(purchase.language + "\n" + purchase.amountLabel, purchase.productId)

func _on_get_purchase_info_failure(purchase_id: String, error: RuStoreError):
	_core_client.show_toast(purchase_id + " " + error.description)


# Debug logs
func _on_payment_logger_debug(error: RuStoreError, message: String, tag: String):
	_core_client.show_toast(tag + ": " + message)

func _on_payment_logger_error(error: RuStoreError, message: String, tag: String):
	_core_client.show_toast(tag + ": " + message)
	
func _on_payment_logger_info(error: RuStoreError, message: String, tag: String):
	_core_client.show_toast(tag + ": " + message)
	
func _on_payment_logger_verbose(error: RuStoreError, message: String, tag: String):
	_core_client.show_toast(tag + ": " + message)
	
func _on_payment_logger_warning(error: RuStoreError, message: String, tag: String):
	_core_client.show_toast(tag + ": " + message)
