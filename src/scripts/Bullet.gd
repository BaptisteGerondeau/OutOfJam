extends Area3D

@export var velocity: float = 5.0

func _ready():
	body_entered.connect(on_hit)

func _physics_process(delta):
	position.x += delta * velocity
	
func on_hit(body):
	print("Pocky Nazi")

#TODO: Play Animation when hitting obstacle
