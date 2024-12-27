# RuStoreSubscriptionPeriod
# @brief Информация о периоде подписки.
class_name RuStoreSubscriptionPeriod extends Object

# @brief Количество дней.
var days: int = 0

# @brief Количество месяцев.
var months: int = 0

# @brief Количество лет.
var years: int = 0

func _init(json: String = ""):
	if json != "":
		var obj = JSON.parse_string(json)
		days = int(obj["days"])
		months = int(obj["months"])
		years = int(obj["years"])
