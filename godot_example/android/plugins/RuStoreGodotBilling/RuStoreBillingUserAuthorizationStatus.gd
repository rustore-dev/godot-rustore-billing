# RuStoreBillingAuthorizationStatus
# @brief Статус авторизации у пользователя.
class_name RuStoreBillingUserAuthorizationStatus extends Object

# @brief
#	Значение статуса авторизации у пользователя.
#	Если true, то пользователь авторизован в RuStore.
#	Если false, то пользователь не авторизован.
#	В случае использования SDK вне RuStore результат true также может вернуться,
#	если в процессе оплаты пользователь авторизовался через VK ID и с момента авторизации прошло менее 15 минут.
var authorized: bool = false
