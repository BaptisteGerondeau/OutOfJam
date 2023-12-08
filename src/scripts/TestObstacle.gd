extends RigidBody3D

# Needed to ensure that timer is in tree when connect is called in ready
@onready var _DespawnTimer

func _ready():
	_DespawnTimer = $DespawnTimer
	_DespawnTimer.timeout.connect(despawn)
	_DespawnTimer.start()
	
	var force = get_tree().root.get_node("Root").get_node("Level").obstacle_velocity
	
	apply_impulse(Vector3(-force,0,0))
	apply_torque_impulse(Vector3(force, 0, 0))
	$Area3D.owner = self

func despawn():
	queue_free()
