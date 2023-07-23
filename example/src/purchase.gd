extends MarginContainer

class_name Purchase

var _purchase_id = ""
@onready var deleteButton = $PurchasePanel/Delete
@onready var confirmButton = $PurchasePanel/Confirm
@onready var infoButton = $PurchasePanel/Info

signal delete
signal confirm
signal info

# Called when the node enters the scene tree for the first time.
func _ready():
	deleteButton.pressed.connect(_on_delete)
	confirmButton.pressed.connect(_on_confirm)
	infoButton.pressed.connect(_on_info)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_purchase_id(id: String):
	_purchase_id = id
	$PurchasePanel/MarginContainer/VBoxContainer/PurchaseId.text = "PurchaseId: " + id


func set_time(time: String):
	$PurchasePanel/MarginContainer/VBoxContainer/PurchaseTime.text = "Time: " + time
	

func set_type(type: String):
	$PurchasePanel/MarginContainer/VBoxContainer/PurchaseType.text = "Type: " + type
	

func set_state(state: String):
	$PurchasePanel/MarginContainer/VBoxContainer/PurchaseState.text = "State: " + state


func set_amount(amount: String):
	$PurchasePanel/MarginContainer/VBoxContainer/PurchaseAmount.text = "Price: " + amount


func set_invoice_id(invoice: String):
	$PurchasePanel/MarginContainer/VBoxContainer/PurchaseInvoiceId.text = "InvoiceId: " + invoice


func set_order_id(order: String):
	$PurchasePanel/MarginContainer/VBoxContainer/PurchaseOrderId.text = "OrderId: " + order


func _on_delete():
	delete.emit(_purchase_id)


func _on_confirm():
	confirm.emit(_purchase_id)


func _on_info():
	info.emit(_purchase_id)
