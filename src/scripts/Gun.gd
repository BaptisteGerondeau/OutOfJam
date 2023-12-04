extends Node3D

@onready var cooldownTimer

@export var bullet:PackedScene

signal has_shot

var able_to_shoot = true
# Called when the node enters the scene tree for the first time.
func _ready():
	cooldownTimer = $FireCooldown
	cooldownTimer.timeout.connect(cooldown_expired)
	
func shoot(new_position: Vector3):
	if able_to_shoot:
		spawn_projectile(new_position)
		able_to_shoot = false
		cooldownTimer.start()
		has_shot.emit()
		

func spawn_projectile(new_position: Vector3):
	var bullet_instance = bullet.instantiate()
	add_child(bullet_instance)
	bullet_instance.position = new_position
	# PLAY ANIM

func cooldown_expired():
	able_to_shoot = true
