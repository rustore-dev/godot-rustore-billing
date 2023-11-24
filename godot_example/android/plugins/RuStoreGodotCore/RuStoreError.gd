class_name RuStoreError extends Object

var description: String = ""

func _init(json: String = ""):
	if json != "":
		var obj = JSON.parse_string(json)
		description = obj["detailMessage"]
