class_name RuStoreFeatureAvailabilityResult extends Object

var isAvailable: bool
var cause: RuStoreError

func _init(json: String = ""):
	if json == "":
		isAvailable = false
		cause = RuStoreError.new()
	else:
		var obj = JSON.parse_string(json)
		isAvailable = obj["isAvailable"]
		cause = RuStoreError.new(json)
