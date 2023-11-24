class_name RuStoreGodotCoreUtils extends Object

const SINGLETON_NAME = "RuStoreGodotCore"

var _isInitialized: bool = false
var _clientWrapper: Object = null

static var _instance: RuStoreGodotCoreUtils = null


static func get_instance() -> RuStoreGodotCoreUtils:
	if _instance == null:
		_instance = RuStoreGodotCoreUtils.new()
	return _instance


func _init():
	if Engine.has_singleton(SINGLETON_NAME):
		_clientWrapper = Engine.get_singleton(SINGLETON_NAME)
		_isInitialized = true


func show_toast(data: String):
	return _clientWrapper.showToast(data)


func convert_to_iso8601(data: String) -> String:
	return _clientWrapper.convertToISO8601(data)


func copy_to_clipboard(data: String):
	_clientWrapper.copyToClipboard(data)


func get_from_clipboard() -> String:
	return _clientWrapper.getFromClipboard()
