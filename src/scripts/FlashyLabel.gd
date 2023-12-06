extends Label

@export var initial_h: float = 180
@export var initial_s = 0.6
@export var initial_v = 0.6

var _h: float = 0

func _ready():
	_h = initial_h / 360

func _process(delta):
	_h += delta / 3
	_h = fmod(_h, 1.0)
	label_settings.outline_color = Color.from_hsv(_h, initial_s, initial_v)
