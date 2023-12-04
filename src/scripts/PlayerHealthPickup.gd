extends Area3D

@export var velocity: float = 5.0

# Needed to ensure that timer is in tree when connect is called in ready
@onready var _DespawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	_DespawnTimer = $DespawnTimer
	_DespawnTimer.timeout.connect(despawn)
	_DespawnTimer.start()
	
	area_entered.connect(on_area_hit)

func despawn():
	get_node("../GPUParticles3D").global_position = global_position
	get_node("../GPUParticles3D").restart()
	queue_free()
	
func on_area_hit(area):
	print("hit")
	if (owner.get_meta("PlayerPickup") && area.has_meta("Player")):
		get_tree().root.get_node("Root").player_boost()
	if (!owner.get_meta("PlayerPickup") && area.has_meta("Monster")):
		get_tree().root.get_node("Root").monster_eat()
	despawn()
	
func _physics_process(delta):
	position.x -= velocity * delta
