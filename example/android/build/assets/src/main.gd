extends Node2D

@onready var products = $CanvasLayer/TabContainer/Products/Products/ProductsList
@onready var purchases = $CanvasLayer/TabContainer/Purchases/Purchases/PurchasesList
@onready var productsButton = $CanvasLayer/TabContainer/Products/Products/ProductsButton
@onready var purchasesButton = $CanvasLayer/TabContainer/Purchases/Purchases/PurchasesButton
@onready var checkButton = $CanvasLayer/Check
@onready var closeAvailabilityButton = $CanvasLayer/Availability/CloseAvailable
@onready var closeInfoButton = $CanvasLayer/PurchaseInfo/CloseInfo

var billing: Object


func _close_availability():
	$CanvasLayer/Availability.hide()
	$CanvasLayer/Availability/Label.text = ""


func _close_info():
	$CanvasLayer/PurchaseInfo.hide()
	$CanvasLayer/Availability/Label.text = ""


func _ready():
	productsButton.pressed.connect(_get_products)
	purchasesButton.pressed.connect(_get_purchases)
	checkButton.pressed.connect(_availability)
	closeAvailabilityButton.pressed.connect(_close_availability)
	closeInfoButton.pressed.connect(_close_info)
	
	
	if Engine.has_singleton("RustoreBilling"):
		billing = Engine.get_singleton("RustoreBilling")
		
		billing.init("183586", "example")
		
		billing.rustore_is_available.connect(_on_availability)
		billing.rustore_purchase_product.connect(_on_purchase)
		billing.rustore_delete_purchase.connect(_on_delete)
		billing.rustore_confirm_purchase.connect(_on_confirm)
		billing.rustore_get_purchases.connect(_on_get_purchases)
		billing.rustore_get_purchase.connect(_on_get_purchase_info)
		billing.rustore_get_products.connect(_on_get_products)


func _availability():
	if billing != null:
		billing.isAvailable()
	
	
func _on_availability(data: Dictionary):
	if data.has('status') and data['status'] == 'success':
		print('success')
		print(data['result'])
		
		$CanvasLayer/Availability.show()
		$CanvasLayer/Availability/Label.text = "Availability: " + data['result']
	elif data.has('status') and data['status'] == 'failure':
		print('failure')
		print(data)
		
		$CanvasLayer/Availability.show()
		$CanvasLayer/Availability/Label.text = data


func _purchase(id: String):
	if billing != null:
		billing.purchaseProduct(id, {})


func _on_purchase(data: Dictionary):
	if data.has('status') and data['status'] == 'cancelled':
		print('cancelled')
		if data.has('purchase') && data['purchase'] != '':
			_delete(data['purchase'])
	elif data.has('status') and data['status'] == 'success':
		print('success')
		print(data)
		
		$CanvasLayer/Availability.show()
		$CanvasLayer/Availability/Label.text = data
	elif data.has('status') and data['status'] == 'failure':
		print('failure')
		print(data)
		
		$CanvasLayer/Availability.show()
		$CanvasLayer/Availability/Label.text = data


func _delete(id: String):
	if billing != null:
		billing.deletePurchase(id)


func _on_delete(data: Dictionary):
	print(data)
	if data.has('status') and data['status'] == 'success':
		print('success')
		_get_purchases()
	else:
		print('failure')
		print(data)
		
		$CanvasLayer/Availability.show()
		$CanvasLayer/Availability/Label.text = data


func _confirm(id: String):
	if billing != null:
		billing.confirmPurchase(id, {})


func _on_confirm(data: Dictionary):
	print(data)
	if data.has('status') and data['status'] == 'success':
		print('success')
		_get_purchases()
	else:
		print('failure')
		print(data)
		
		$CanvasLayer/Availability.show()
		$CanvasLayer/Availability/Label.text = data


func _get_purchases():
	if billing != null:
		billing.getPurchases()


func _on_get_purchases(data: Dictionary):
	for child in purchases.get_children():
		child.queue_free()
		
	if data.has('status') and data['status'] == 'success' and data.has('items'):
		var items = data['items']
		for key in items:
			print(items[key])
			var purchase: Purchase = load("res://scenes/purchase.tscn").instantiate()
			purchase.set_purchase_id(items[key].purchase_id)
			purchase.set_time(items[key].purchase_time)
			purchase.set_type(items[key].product_type)
			purchase.set_state(items[key].purchase_state)
			purchase.set_amount(items[key].amount_label)
			purchase.set_invoice_id(items[key].invoice_id)
			purchase.set_order_id(items[key].order_id)
			
			purchase.delete.connect(_delete)
			purchase.confirm.connect(_confirm)
			purchase.info.connect(_info)
			
			purchases.add_child(purchase)
	else:
		print('failure')
		print(data)
		
		$CanvasLayer/Availability.show()
		$CanvasLayer/Availability/Label.text = data


func _info(id: String):
	if billing != null:
		billing.purchaseInfo(id)
		

func _on_get_purchase_info(data: Dictionary):
	if data.has('status') and data['status'] == 'success':
		print('success')
		print(data['purchase'])
		
		$CanvasLayer/PurchaseInfo.show()
		$CanvasLayer/PurchaseInfo/Label.text = data
	else:
		print('failure')
		print(data)
		
		$CanvasLayer/PurchaseInfo.show()
		$CanvasLayer/PurchaseInfo/Label.text = data


func _get_products():
	if billing != null:
		billing.getProducts([
			"SDK_sampleRN_con_280723_1",
			"SDK_sampleRN_con_280723_2",
			"SDK_sampleGodot_non_con_280223_1",
			"SDK_sampleGodot_non_con_280723_22",
			"SDK_sampleGodot_sub_280723_1",
			"SDK_sampleGodot_sub_280723_2"
		])


func _on_get_products(data: Dictionary):
	
	for child in products.get_children():
		child.queue_free()
		
	if data.has('status') and data['status'] == 'success' and data.has('items'):
		var items = data['items']
		for key in items:
			print(items[key])
			var product: Product = load("res://scenes/product.tscn").instantiate()
			product.set_product_id(items[key].product_id)
			product.set_title(items[key].title)
			product.set_type(items[key].product_type)
			product.set_status(items[key].product_status)
			product.set_price(items[key].price_label)
			
			product.purchase.connect(_purchase)
				
			products.add_child(product)
	else:
		print('failure')
		print(data)
		
		$CanvasLayer/PurchaseInfo.show()
		$CanvasLayer/PurchaseInfo/Label.text = data

