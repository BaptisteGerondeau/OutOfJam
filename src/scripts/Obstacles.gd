extends Node

@onready var Shape

func _ready():
	$ObstacleSpawnTimer.timeout.connect(on_spawn)
	$ObstacleSpawnTimer.start()
	
	Shape = $Area3D/CollisionShape3D

func on_spawn():
	var InstanceChosen = owner.get_obstacle().instantiate()
	$Area3D/CollisionShape3D.add_child(InstanceChosen)
	InstanceChosen.position = pick_spawnpoint()

func pick_spawnpoint() -> Vector3:
	var picked_y = randf_range(Shape.position.x + Shape.shape.extents.y/2, 
						Shape.position.x - Shape.shape.extents.y/2)
	return Vector3(Shape.position.x, picked_y, Shape.position.z)
