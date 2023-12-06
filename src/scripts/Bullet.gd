extends Area3D

@export var velocity: float = 5.0

func _physics_process(delta):
	position.x += delta * velocity

#TODO: Play Animation when hitting obstacle
