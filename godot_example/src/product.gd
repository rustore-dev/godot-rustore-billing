class_name ProductPanel extends MarginContainer

@onready var _productId = $ProductPanel/MarginContainer/VBoxContainer/ProductId
@onready var _productTitle = $ProductPanel/MarginContainer/VBoxContainer/ProductTitle
@onready var _productType = $ProductPanel/MarginContainer/VBoxContainer/ProductType
@onready var _productStatus = $ProductPanel/MarginContainer/VBoxContainer/ProductStatus
@onready var _productPrice = $ProductPanel/MarginContainer/VBoxContainer/ProductPrice

const ID_LABEL = "Id: "
const TITLE_LABEL = "Title: "
const TYPE_LABEL = "Type: "
const STATUS_LABEL = "Status: "
const PRICE_LABEL = "Price: "

var _product: RuStoreProduct = null

signal on_purchase_product_pressed

func set_product(product: RuStoreProduct):
	_product = product
	_productId.text = ID_LABEL + _product.productId
	_productTitle.text = TITLE_LABEL + _product.title
	_productType.text = TYPE_LABEL + ERuStoreProductType.Item.find_key(_product.productType)
	_productStatus.text = STATUS_LABEL + ERuStoreProductStatus.Item.find_key(_product.productStatus)
	_productPrice.text = PRICE_LABEL + str(_product.price)

func free_product():
	if is_instance_valid(_product):
		_product.free()
	_product = null

func _on_purchase_pressed():
	on_purchase_product_pressed.emit(_product)

func _notification(what: int):
	if what == NOTIFICATION_PREDELETE:
		free_product()
