class_name RuStoreFeatureAvailabilityResult extends Object

var isAvailable: bool = false
var cause: RuStoreError = null

func _init(json: String = ""):
	if json != "":
		var obj = JSON.parse_string(json)
		isAvailable = obj["isAvailable"]
		
		if obj.has("cause"):
			var jcause = JSON.stringify(obj["cause"])
			cause = RuStoreError.new(jcause)
