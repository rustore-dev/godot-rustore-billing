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


func get_string_resources(name: String) -> String:
	return _clientWrapper.getStringResources(name)


func get_int_resources(name: String) -> int:
	return _clientWrapper.getIntResources(name)


func get_string_shared_preferences(storageName: String, key: String, defaultValue: String) -> String:
	return _clientWrapper.getStringSharedPreferences(storageName, key, defaultValue)


func get_int_shared_preferences(storageName: String, key: String, defaultValue: int) -> int:
	return _clientWrapper.getIntSharedPreferences(storageName, key, defaultValue)


func set_string_shared_preferences(storageName: String, key: String, value: String):
	_clientWrapper.setStringSharedPreferences(storageName, key, value)


func set_int_shared_preferences(storageName: String, key: String, value: int):
	_clientWrapper.setIntSharedPreferences(storageName, key, value)
