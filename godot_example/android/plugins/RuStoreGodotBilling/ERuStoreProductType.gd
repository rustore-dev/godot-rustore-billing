# ERuStoreProductType
# @brief Тип продукта.
class_name ERuStoreProductType extends Object

# @brief Доступные значения.
enum Item {
	# @brief Непотребляемый продукт (может быть приобретен один раз).
	NON_CONSUMABLE,
	
	# @brief Потребляемый продукт.
	CONSUMABLE,
	
	# @brief Подписка.
	SUBSCRIPTION
}
