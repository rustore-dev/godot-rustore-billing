class_name RuStoreSubscriptionPeriod extends Object

var days: int = 0
var months: int = 0
var years: int = 0

func _init(json: String = ""):
	if json != "":
		var obj = JSON.parse_string(json)
		days = int(obj["days"])
		months = int(obj["months"])
		years = int(obj["years"])
