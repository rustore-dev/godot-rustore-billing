extends MarginContainer

class_name Product

var _product_id = ""
@onready var purchase_button = $ProductPanel/Purchase

signal purchase


func _ready():
	purchase_button.pressed.connect(_on_purchase)


func _process(delta):
	pass


func set_product_id(id: String):
	_product_id = id
	$ProductPanel/MarginContainer/VBoxContainer/ProductId.text = "ProductId: " + id


func set_title(title: String):
	$ProductPanel/MarginContainer/VBoxContainer/ProductTitle.text = "Title: " + title
	

func set_type(type: String):
	$ProductPanel/MarginContainer/VBoxContainer/ProductType.text = "Type: " + type
	

func set_status(status: String):
	$ProductPanel/MarginContainer/VBoxContainer/ProductStatus.text = "Status: " + status


func set_price(price: String):
	$ProductPanel/MarginContainer/VBoxContainer/ProductPrice.text = "Price: " + price

func _on_purchase():
	purchase.emit(_product_id)
