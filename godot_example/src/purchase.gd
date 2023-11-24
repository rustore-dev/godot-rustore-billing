class_name PurchasePanel extends MarginContainer

@onready var _purchaseId = $PurchasePanel/MarginContainer/VBoxContainer/PurchaseId
@onready var _purchaseTime = $PurchasePanel/MarginContainer/VBoxContainer/PurchaseTime
@onready var _purchaseType = $PurchasePanel/MarginContainer/VBoxContainer/PurchaseType
@onready var _purchaseState = $PurchasePanel/MarginContainer/VBoxContainer/PurchaseState
@onready var _purchaseAmount = $PurchasePanel/MarginContainer/VBoxContainer/PurchaseAmount
@onready var _purchaseInvoiceId = $PurchasePanel/MarginContainer/VBoxContainer/PurchaseInvoiceId
@onready var _purchaseOrderId = $PurchasePanel/MarginContainer/VBoxContainer/PurchaseOrderId

const ID_LABEL = "Purchase Id: "
const TIME_LABEL = "Time: "
const TYPE_LABEL = "Type: "
const STATE_LABEL = "State: "
const AMOUNT_LABEL = "Price: "
const INVOICE_ID_LABEL = "Invoice Id: "
const ORDER_ID_LABEL = "Order Id: "

signal on_delete_purchase_pressed
signal on_confirm_purchase_pressed
signal on_get_purchase_info_pressed

var _purchase: RuStorePurchase = null

func set_purchase(purchase: RuStorePurchase):
	_purchase = purchase
	_purchaseId.text = ID_LABEL + _purchase.purchaseId
	_purchaseTime.text = TIME_LABEL + _purchase.purchaseTime
	_purchaseType.text = TYPE_LABEL + ERuStoreProductType.Item.find_key(_purchase.productType)
	_purchaseState.text = STATE_LABEL + ERuStorePurchaseState.Item.find_key(_purchase.purchaseState)
	_purchaseAmount.text = AMOUNT_LABEL + _purchase.amountLabel
	_purchaseInvoiceId.text = INVOICE_ID_LABEL + _purchase.invoiceId
	_purchaseOrderId.text = ORDER_ID_LABEL + _purchase.orderId


func _on_delete_pressed():
	on_delete_purchase_pressed.emit(_purchase)

func _on_confirm_pressed():
	on_confirm_purchase_pressed.emit(_purchase)

func _on_info_pressed():
	on_get_purchase_info_pressed.emit(_purchase)
