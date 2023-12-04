extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$DespawnTimer.timeout.connect(despawn)
	$DespawnTimer.start()

func despawn():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
