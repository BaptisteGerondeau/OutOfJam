extends CharacterBody3D

@export var speed : float = 5.0

const THRESHOLD = 1
const MOVE_THRESHOLD = 2.5
const VELOCITY_THRESHOLD = Vector3(0, 0.05, 0)
const IMPOSSIBLE_POSITION = Vector3(10000, 10000, 10000)
const INTERPOLATION_SPEED = 4

const SMILING_EYES_UVOFFSET = Vector3(0.175, 0, 0)
const DEAD_EYES_UVOFFSET = Vector3(0.35, 0, 0)
const DEAD_MOUTH_UVOFFSET = Vector3(0.29, 0, 0)

var _target: Vector3 = IMPOSSIBLE_POSITION
var _moving: bool = false
var _boosting: bool = false
var _lerped_target: Vector3 = IMPOSSIBLE_POSITION

var _sfx_pickup
var _sfx_boost
var _sfx_laughter

@onready var viewport
@onready var camera
@onready var gun

signal has_boosted
signal player_died
signal player_pickup

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	viewport = get_viewport()
	camera = viewport.get_camera_3d()
	gun = get_node("../Gun")
	
	$JamMan/JaMAnimated/Skeleton3D/JaManimated.get_active_material(2).uv1_offset = Vector3.ZERO
	$JamMan/JaMAnimated/Skeleton3D/JaManimated.get_active_material(3).uv1_offset = Vector3.ZERO
	
	_sfx_pickup = preload("res://sound/pickup.wav")
	_sfx_boost = preload("res://sound/boost.wav")
	_sfx_laughter = preload("res://sound/laughter.wav")
	
	$Area3D.area_entered.connect(on_area_hit)
	player_pickup.connect(on_pickup)
	
	if viewport == null || camera == null || gun == null:
		print("Viewport or Camera or Gun not found !")

func _input(event):
	if event.is_action_pressed("move_click"):
		_moving = true
	if event.is_action_released("move_click"):
		_moving = false
	
	if event.is_action_pressed("shoot"):
		gun.shoot(position)
		
	if event.is_action_pressed("boost"):
		_boosting = true
		has_boosted.emit()
		$CollisionShape3D.disabled = true
		$Area3D/CollisionShape3D.disabled = true
		$AudioStreamPlayer3D.stream = _sfx_boost
		$AudioStreamPlayer3D.play()

func _physics_process(delta):
	var target_y = cursor_position().y
	if _moving && abs(position.y - target_y) > MOVE_THRESHOLD :
		_target = Vector3(position.x, target_y, position.z)
	else:
		_target = position
		_lerped_target = _target
		
	if _boosting:
		if abs(position.x - $StartingPosition.position.x) > THRESHOLD:
			_target.x = $StartingPosition.position.x
		else:
			_boosting = false
			$CollisionShape3D.disabled = false
			$Area3D/CollisionShape3D.disabled = false

	_lerped_target = _lerped_target.lerp(_target, delta * INTERPOLATION_SPEED)
	velocity = position.direction_to(_lerped_target) * speed

	if abs(velocity) < VELOCITY_THRESHOLD:
		velocity = Vector3.ZERO

	move_and_slide()

func on_area_hit(area):
	if area.owner.get_meta("type") == "Monster":
		on_death()
	if area.owner.get_meta("type") == "PlayerPickup":
		area.despawn()
		player_pickup.emit()
		

func on_pickup():
	$AudioStreamPlayer3D.stream = _sfx_pickup
	$AudioStreamPlayer3D.play()
	$JamMan/JaMAnimated/Skeleton3D/JaManimated.get_active_material(2).uv1_offset = SMILING_EYES_UVOFFSET
	await get_tree().create_timer(0.2).timeout
	$JamMan/JaMAnimated/Skeleton3D/JaManimated.get_active_material(2).uv1_offset = Vector3.ZERO

func on_death():
	$AudioStreamPlayer3D.stream = _sfx_laughter
	$AudioStreamPlayer3D.play()
	$JamMan/JaMAnimated/Skeleton3D/JaManimated.get_active_material(2).uv1_offset = DEAD_EYES_UVOFFSET
	$JamMan/JaMAnimated/Skeleton3D/JaManimated.get_active_material(3).uv1_offset = DEAD_MOUTH_UVOFFSET
	player_died.emit()

func cursor_position() -> Vector3:
	return get_viewport().get_camera_3d().project_position(get_viewport().get_mouse_position(), 100)
