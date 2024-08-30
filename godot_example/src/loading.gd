extends ProgressBar

var _speed = 2

func _ready():
	set_process(true)


func _process(delta):
	var progress = tan(Time.get_ticks_msec() / 1000.0 * PI * _speed)
	
	if progress >= 0:
		self.set_fill_mode(FILL_BEGIN_TO_END)
	else:
		self.set_fill_mode(FILL_END_TO_BEGIN)
	
	self.value = abs(progress)
