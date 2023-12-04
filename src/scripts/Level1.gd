extends Node3D

@export var level_duration: float = 20.0
@export var monster_health: int = 10
@export var player_health: int = 10


@export var HardObstacle: PackedScene
@export var PlayerHealthPickup: PackedScene
@export var MonsterHealthPickup: PackedScene
	
func _ready():
	if (HardObstacle == null || PlayerHealthPickup == null || MonsterHealthPickup == null):
		print("NO ASSIGNED OBSTACLES !!")
	
	$LevelDurationTimer.set_wait_time(level_duration)
	$LevelDurationTimer.start()
	
func get_obstacle() -> PackedScene:
	var i = randi_range(0, 100)
	
	if i < 50:
		return HardObstacle
	elif i < 65:
		return MonsterHealthPickup
	else:
		return PlayerHealthPickup
