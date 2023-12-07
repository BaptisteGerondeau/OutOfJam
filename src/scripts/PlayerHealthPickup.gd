extends Area3D

@export var velocity: float = 5.0

var _sfx_hit

func _ready():
	$DespawnTimer.timeout.connect(despawn)
	$DespawnTimer.start()
	
	area_entered.connect(on_area_hit)
	_sfx_hit = preload("res://sound/hit.wav")
	
func despawn():
	queue_free()
	
func on_area_hit(area):
	if (area.owner.has_meta("type") && area.owner.get_meta("type") == "Bullet"):
		get_node("../GPUParticles3D").global_position = global_position
		get_node("../GPUParticles3D").restart()
		play_sfx(_sfx_hit)
		despawn()
	
func _physics_process(delta):
	position.x -= velocity * delta

func play_sfx(sfx):
	var AudioPlayer = get_node("../AudioStreamPlayer3D")
	if not AudioPlayer.playing:
		AudioPlayer.stream = sfx
		AudioPlayer.play()
