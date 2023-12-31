extends Area3D

@export var velocity: float = 5.0

func _ready():
	$Timer.timeout.connect(queue_free)

func _physics_process(delta):
	position.x += delta * velocity
