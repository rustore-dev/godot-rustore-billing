# RuStorePurchaseAvailabilityResult
# @brief Проверка доступности функционала.
class_name RuStorePurchaseAvailabilityResult extends Object

# @brief
#	Информация о доступности.
#	Если все условия выполняются, возвращается isAvailable == true.
#	В противном случае возвращается isAvailable == false.
var isAvailable: bool = false

# @brief Информация об ошибке.
var cause: RuStoreError = null
