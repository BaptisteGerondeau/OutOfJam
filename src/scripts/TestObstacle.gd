extends RigidBody3D

# Needed to ensure that timer is in tree when connect is called in ready
@onready var _DespawnTimer

func _ready():
	_DespawnTimer = $DespawnTimer
	_DespawnTimer.timeout.connect(despawn)
	_DespawnTimer.start()
		
	apply_impulse(Vector3(-10,0,0))
	apply_torque_impulse(Vector3(10, 0, 0))
	$Area3D.owner = self

func despawn():
	queue_free()
