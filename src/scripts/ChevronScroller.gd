extends Node

var _chevron_instance
var _driver_node
var _chevron_array = []

@export var InitialPosition : Vector3 = Vector3(0, 0, -20)
@export var ScrollingSpeed : float = 20.0

func _ready():
	_chevron_instance = preload("res://src/scenes/chevron.tscn")
	_driver_node = Node3D.new()
	_chevron_array.append(_chevron_instance.instantiate())
	_chevron_array.append(_chevron_instance.instantiate())
	
	add_child(_driver_node)
	_driver_node.global_position = InitialPosition
	_driver_node.add_child(_chevron_array[0])
	_chevron_array[0].position = Vector3.ZERO
	_driver_node.add_child(_chevron_array[1])
	_chevron_array[1].position = Vector3(98.5, 0, 0)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_driver_node.global_position -= Vector3(ScrollingSpeed * delta, 0, 0)
	
	if _driver_node.global_position.x < -98.5:
		_driver_node.global_position = InitialPosition
