extends Node3D

@export var growing_speed : float = 5.0
@export var rotation_speed : float = 5.0

var _growing = false
var _rotating = false
var _old_scale
var _old_rotation
var _monster_powerup_sfx
var _absorb_sfx

const THRESHOLD = 0.05

signal monster_eat

func _ready():
	_monster_powerup_sfx = preload("res://sound/PowerUpMonster.wav")
	_absorb_sfx = preload("res://sound/monster_absorb.wav")
	$Area3D.area_entered.connect(on_hit)
	
	monster_eat.connect(on_monster_eat)

func on_monster_eat():
	_old_scale = scale
	_growing = true
	flash_white()
	$AudioStreamPlayer3D.stream = _monster_powerup_sfx
	$AudioStreamPlayer3D.volume_db = 0.0
	$AudioStreamPlayer3D.play()

func _physics_process(delta):
	if _growing:
		scale.lerp(_old_scale + Vector3.ONE, delta * growing_speed)
		if (scale - _old_scale).length() < THRESHOLD || not $AudioStreamPlayer3D.playing:
			scale = (_old_scale + Vector3.ONE)
			_growing = false
	
	if _rotating:
		rotation.y = lerp_angle(rotation.y, _old_rotation + 80.0, delta * rotation_speed)

func on_hit(area):
	if area.owner.has_meta("type"):
		match area.owner.get_meta("type"):
			"PlayerPickup":
				absorb_body(area)
			"Obstacle":
				absorb_body(area)
			"MonsterPickup":
				area.despawn()
				monster_eat.emit()

func absorb_body(body):
	body.queue_free()
	$AudioStreamPlayer3D.stream = _absorb_sfx
	$AudioStreamPlayer3D.volume_db = 10.0
	$AudioStreamPlayer3D.play()
	
func on_game_over():
	_old_rotation = rotation.y
	_rotating = true

func flash_white():
	var flash_material = preload("res://src/etc/material_flashing_white.tres")
	$Armature/Skeleton3D/JellyMonster.set_surface_override_material(0, flash_material)
	await get_tree().create_timer(0.2).timeout
	$Armature/Skeleton3D/JellyMonster.set_surface_override_material(0, null)
