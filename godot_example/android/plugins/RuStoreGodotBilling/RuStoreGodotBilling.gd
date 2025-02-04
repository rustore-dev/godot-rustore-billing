# RuStoreGodotBillingClient
# @brief Класс реализует API для интегрирации платежей в мобильное приложение.
class_name RuStoreGodotBillingClient extends Object

const SINGLETON_NAME = "RuStoreGodotBilling"

var _isInitialized: bool = false
var _clientWrapper: Object = null

var _core_client: RuStoreGodotCoreUtils = null

# @brief Действие, выполняемое при успешном завершении операции check_purchases_availability.
signal on_check_purchases_availability_success

# @brief Действие, выполняемое в случае ошибки check_purchases_availability.
signal on_check_purchases_availability_failure

# @brief Действие, выполняемое при успешном завершении операции get_products.
signal on_get_products_success

# @brief Действие, выполняемое в случае ошибки get_products.
signal on_get_products_failure

# @brief Действие, выполняемое при успешном завершении операции purchase_product.
signal on_purchase_product_success

# @brief Действие, выполняемое в случае ошибки purchase_product.
signal on_purchase_product_failure

# @brief Действие, выполняемое при успешном завершении операции get_purchases.
signal on_get_purchases_success

# @brief Действие, выполняемое в случае ошибки get_purchases.
signal on_get_purchases_failure

# @brief Действие, выполняемое при успешном завершении операции confirm_purchase.
signal on_confirm_purchase_success

# @brief Действие, выполняемое в случае ошибки confirm_purchase.
signal on_confirm_purchase_failure

# @brief Действие, выполняемое при успешном завершении операции delete_purchase.
signal on_delete_purchase_success

# @brief Действие, выполняемое в случае ошибки delete_purchase.
signal on_delete_purchase_failure

# @brief Действие, выполняемое при успешном завершении операции.
signal on_get_purchase_info_success

# @brief Действие, выполняемое в случае ошибки.
signal on_get_purchase_info_failure


# @brief
#	Логирует отладочное сообщение.
#	Используется для записи логов, которые помогают в процессе отладки приложения.
signal on_payment_logger_debug

# @brief
#	Логирует сообщение об ошибке.
#	Используется для записи логов, которые сигнализируют о возникновении ошибок,
#	требующих вмешательства или исправления.
signal on_payment_logger_error

# @brief
#	Логирует информационное сообщение.
#	Используется для записи стандартных логов, которые помогают отслеживать нормальное выполнение программы.
signal on_payment_logger_info

# @brief
#	Логирует подробное сообщение.
#	Используется для записи детализированных логов, которые полезны для отладки.
signal on_payment_logger_verbose

#  @brief
#	Логирует предупреждающее сообщение.
#	Используется для записи логов, которые сигнализируют о потенциальных проблемах,
#	которые не мешают выполнению программы, но могут потребовать внимания.
signal on_payment_logger_warning

static var _instance: RuStoreGodotBillingClient = null


# @brief
#	Получить экземпляр RuStoreGodotBillingClient.
# @return
#	Возвращает указатель на единственный экземпляр RuStoreGodotBillingClient (реализация паттерна Singleton).
#	Если экземпляр еще не создан, создает его.
static func get_instance() -> RuStoreGodotBillingClient:
	if _instance == null:
		_instance = RuStoreGodotBillingClient.new()
	return _instance


# @brief
#	Выполняет инициализацию синглтона URuStoreBillingClient.
#	Параметры инициализации задаются объектом типа FURuStoreBillingClientConfig.
# @param consoleApplicationId Идентификатор приложения из консоли RuStore.
# @param deeplinkScheme
#	Схема deeplink, необходимая для возврата в ваше приложение после оплаты через стороннее приложение (например, SberPay или СБП).
#	SDK генерирует свой хост к данной схеме.
# @param debugLogs
#	Флаг, регулирующий ведение журнала событий.
#	Укажите значение true, если хотите, чтобы события попадали в журнал.
#	В ином случае укажите false.
func init(
		consoleApplicationId: String,
		deeplinkScheme: String,
		debugLogs: bool = false
	):
	_core_client = RuStoreGodotCoreUtils.get_instance()
	
	if _isInitialized == false && Engine.has_singleton(SINGLETON_NAME):
		_clientWrapper = Engine.get_singleton(SINGLETON_NAME)
		_clientWrapper.rustore_check_purchases_available_success.connect(_on_check_purchases_availability_success)
		_clientWrapper.rustore_check_purchases_available_failure.connect(_on_check_purchases_availability_failure)
		_clientWrapper.rustore_on_get_products_success.connect(_on_get_products_success)
		_clientWrapper.rustore_on_get_products_failure.connect(_on_get_products_failure)
		_clientWrapper.rustore_on_purchase_product_success.connect(_on_purchase_product_success)
		_clientWrapper.rustore_on_purchase_product_failure.connect(_on_purchase_product_failure)
		_clientWrapper.rustore_on_get_purchases_success.connect(_on_get_purchases_success)
		_clientWrapper.rustore_on_get_purchases_failure.connect(_on_get_purchases_failure)	
		_clientWrapper.rustore_on_confirm_purchase_success.connect(_on_confirm_purchase_success)
		_clientWrapper.rustore_on_confirm_purchase_failure.connect(_on_confirm_purchase_failure)
		_clientWrapper.rustore_on_delete_purchase_success.connect(_on_delete_purchase_success)
		_clientWrapper.rustore_on_delete_purchase_failure.connect(_on_delete_purchase_failure)
		_clientWrapper.rustore_on_get_purchase_info_success.connect(_on_get_purchase_info_success)
		_clientWrapper.rustore_on_get_purchase_info_failure.connect(_on_get_purchase_info_failure)
		_clientWrapper.rustore_on_payment_logger_debug.connect(_on_payment_logger_debug)
		_clientWrapper.rustore_on_payment_logger_error.connect(_on_payment_logger_error)
		_clientWrapper.rustore_on_payment_logger_info.connect(_on_payment_logger_info)
		_clientWrapper.rustore_on_payment_logger_verbose.connect(_on_payment_logger_verbose)
		_clientWrapper.rustore_on_payment_logger_warning.connect(_on_payment_logger_warning)
		
		_clientWrapper.init(consoleApplicationId, deeplinkScheme, debugLogs)
		_isInitialized = true


# Error processing
# @brief Обработка ошибок в нативном SDK.
# @param value true — разрешает обработку ошибок, false — запрещает.
func set_error_handling(value: bool):
	_clientWrapper.setErrorHandling(value)

# @brief Получает текущее состояние режима обработки ошибок в нативном SDK.
# @return Возвращает true, если обработка ошибок разрешена, и false, если запрещена.
func get_error_handling() -> bool:
	return _clientWrapper.getErrorHandling()


# Theme switcher
func setTheme(themeCode: int):
	_clientWrapper.setTheme(themeCode)

# @brief
#	SDK поддерживает динамическую смены темы.
#	Установить тему интерфейса.
# @param themeCode Новая тема, заданная значением из перечисления EURuStoreTheme.
func set_theme(themeCode: int):
	_clientWrapper.setTheme(themeCode)


# Check purchases availability
# @brief Проверка доступности платежей.
func check_purchases_availability():
	_clientWrapper.checkPurchasesAvailability()

func _on_check_purchases_availability_success(data: String):
	var obj = RuStoreFeatureAvailabilityResult.new(data)
	on_check_purchases_availability_success.emit(obj)

func _on_check_purchases_availability_failure(data: String):
	var obj = RuStoreError.new(data)
	on_check_purchases_availability_failure.emit(obj)


# Is RuStore installed
# @brief Проверка установлен ли на устройстве пользователя RuStore.
# @return Возвращает true, если RuStore установлен, в противном случае — false.
func is_rustore_installed() -> bool:
	return _clientWrapper.isRuStoreInstalled()


# Get products
# @brief Получение списка продуктов, добавленных в ваше приложение через RuStore консоль.
# @param productIds
#	Список идентификаторов продуктов (задаются при создании продукта в консоли разработчика).
#	Список продуктов имеет ограничение в размере 1000 элементов.
func get_products(productIds: Array):
	_clientWrapper.getProducts(productIds)

func _on_get_products_success(data: String):
	var obj_arr = []
	var str_arr = JSON.parse_string(data)
	for str_item in str_arr:
		var obj_item = RuStoreProduct.new(str(str_item))
		obj_arr.append(obj_item)
	on_get_products_success.emit(obj_arr)

func _on_get_products_failure(data: String):
	var obj = RuStoreError.new(data)
	on_get_products_failure.emit(obj)


# Purchase product
# @brief Покупка продукта.
# @param productId Идентификатор продукта, который был присвоен продукту в RuStore Консоли (обязательный параметр).
# @param params
#	Опциональные параметры:
#		- orderId — идентификатор заказа, создаётся на стороне AnyApp. (необязательно — если не указан, то генерируется автоматически);
#		- quantity — количество продукта (необязательный параметр — если не указывать, будет подставлено значение 1) (необязательно);
#		- developerPayload — строка с дополнительной информацией о заказе, которую вы можете установить при инициализации процесса покупки.
func purchase_product(productId: String, params: Dictionary = {}):
	_clientWrapper.purchaseProduct(productId, params)

func _on_purchase_product_success(data: String):
	var obj = RuStorePaymentResult.parse(data)
	on_purchase_product_success.emit(obj)

func _on_purchase_product_failure(data: String):
	var obj = RuStoreError.new(data)
	on_purchase_product_failure.emit(obj)


# Get purchases
# @brief Получение списка покупок пользователя.
func get_purchases():
	_clientWrapper.getPurchases()

func _on_get_purchases_success(data: String):
	var obj_arr = []
	var str_arr = JSON.parse_string(data)
	for str_item in str_arr:
		var obj_item = RuStorePurchase.new(str(str_item))
		obj_arr.append(obj_item)
	on_get_purchases_success.emit(obj_arr)

func _on_get_purchases_failure(data: String):
	var obj = RuStoreError.new(data)
	on_get_purchases_failure.emit(obj)


# Confirm purchase
# @brief
#	Потребление (подтверждение) покупки.
#	Запрос на потребление (подтверждение) покупки должен сопровождаться выдачей товара.
# @param purchaseId Идентификатор покупки.
# @param developer_payload
#	Строка с дополнительной информацией о заказе,
#	которую вы можете установить при инициализации процесса покупки.
func confirm_purchase(purchase_id: String, developer_payload: String = ""):
	_clientWrapper.confirmPurchase(purchase_id, developer_payload)

func _on_confirm_purchase_success(purchase_id: String):
	on_confirm_purchase_success.emit(purchase_id)

func _on_confirm_purchase_failure(purchase_id: String, data: String):
	var obj = RuStoreError.new(data)
	on_confirm_purchase_failure.emit(purchase_id, obj)


# Delete purchase
# @brief Отмена покупки.
# @param purchase_id Идентификатор покупки.
func delete_purchase(purchase_id: String):
	_clientWrapper.deletePurchase(purchase_id)

func _on_delete_purchase_success(purchase_id: String):
	on_delete_purchase_success.emit(purchase_id)

func _on_delete_purchase_failure(purchase_id: String, data: String):
	var obj = RuStoreError.new(data)
	on_delete_purchase_failure.emit(purchase_id, obj)


# Get purchase info
# @brief Получение информации о покупке.
# @param purchaseId Идентификатор покупки.
func get_purchase_info(purchase_id: String):
	_clientWrapper.getPurchaseInfo(purchase_id)

func _on_get_purchase_info_success(data: String):
	var obj = RuStorePurchase.new(data)
	on_get_purchase_info_success.emit(obj)

func _on_get_purchase_info_failure(purchase_id: String, data: String):
	var obj = RuStoreError.new(data)
	on_get_purchase_info_failure.emit(purchase_id, obj)


# Debug logs
func _on_payment_logger_debug(data: String, message: String, tag: String):
	var obj = RuStoreError.new(data)
	on_payment_logger_debug.emit(obj, message, tag)

func _on_payment_logger_error(data: String, message: String, tag: String):
	var obj = RuStoreError.new(data)
	on_payment_logger_error.emit(obj, message, tag)

func _on_payment_logger_info(data: String, message: String, tag: String):
	var obj = RuStoreError.new(data)
	on_payment_logger_info.emit(obj, message, tag)

func _on_payment_logger_verbose(data: String, message: String, tag: String):
	var obj = RuStoreError.new(data)
	on_payment_logger_verbose.emit(obj, message, tag)

func _on_payment_logger_warning(data: String, message: String, tag: String):
	var obj = RuStoreError.new(data)
	on_payment_logger_warning.emit(obj, message, tag)
