extends Area3D

@export var velocity: float = 5.0

var _sfx_pickup
var _sfx_hit
var _sfx_monstereat
# Needed to ensure that timer is in tree when connect is called in ready
@onready var _DespawnTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	_DespawnTimer = $DespawnTimer
	_DespawnTimer.timeout.connect(despawn)
	_DespawnTimer.start()
	
	area_entered.connect(on_area_hit)
	
	_sfx_hit = preload("res://sound/hit.wav")
	_sfx_pickup = preload("res://sound/pickup.wav")
	_sfx_monstereat = preload("res://sound/monster_eat.wav")

func despawn():
	play_sfx(_sfx_hit)
	get_node("../GPUParticles3D").global_position = global_position
	get_node("../GPUParticles3D").restart()
	queue_free()
	
func on_area_hit(area):
	print("hit")
	if (owner.get_meta("PlayerPickup") && area.has_meta("Player")):
		get_tree().root.get_node("Root").player_boost()
		play_sfx(_sfx_pickup)
	if (!owner.get_meta("PlayerPickup") && area.has_meta("Monster")):
		get_tree().root.get_node("Root").monster_eat()
		play_sfx(_sfx_monstereat)
	despawn()
	
func _physics_process(delta):
	position.x -= velocity * delta

func play_sfx(sfx):
	var AudioPlayer = get_node("../AudioStreamPlayer3D")
	if not AudioPlayer.playing:
		AudioPlayer.stream = sfx
		AudioPlayer.play()
