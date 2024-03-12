class_name RuStoreError extends Object

var name: String = ""
var description: String = ""

func _init(json: String = ""):
	if json != "":
		var obj = JSON.parse_string(json)
		
		if obj.has("simpleName"):
			name = obj["simpleName"]
		
		if obj.has("detailMessage"):
			description = obj["detailMessage"]
