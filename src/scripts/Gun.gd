extends Node3D

@onready var cooldownTimer

@export var bullet:PackedScene

signal has_shot

var _shoot_sfx

var able_to_shoot = true
# Called when the node enters the scene tree for the first time.
func _ready():
	cooldownTimer = $FireCooldown
	cooldownTimer.timeout.connect(cooldown_expired)
	
	_shoot_sfx = preload("res://sound/squirt_fire.wav")
	$AudioStreamPlayer3D.stream = _shoot_sfx
	
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
	
	$AudioStreamPlayer3D.play()
	# PLAY ANIM

func cooldown_expired():
	able_to_shoot = true
