extends CanvasLayer

@onready var PlayerHPLabel: Label
@onready var MonsterHPLabel: Label
@onready var LevelProgression: ProgressBar

var ProgressionTimer: Timer = null
var level_duration : float = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerHPLabel = $Control/PlayerHealth
	MonsterHPLabel = $Control/MonsterHealth
	LevelProgression = $Control/LevelProgression
	
	PlayerHPLabel.set_text("PUT")
	MonsterHPLabel.set_text("PUT")
	LevelProgression.value = 0

func set_player_hp(amount: int):
	PlayerHPLabel.set_text("Player HP: " + str(amount))

func set_monster_hp(amount: int):
	MonsterHPLabel.set_text("Monster HP: " + str(amount))
	
func set_leveltimer(timer: Timer):
	ProgressionTimer = timer
	level_duration = ProgressionTimer.wait_time
	
func game_over():
	var GameOverScreen = load("res://src/scenes/game_over.tscn").instantiate()
	add_child(GameOverScreen)
	hide_everything()
	
func game_won():
	var GameWonScreen = load("res://src/scenes/game_won.tscn").instantiate()
	add_child(GameWonScreen)
	hide_everything()

func hide_everything():
	PlayerHPLabel.hide()
	MonsterHPLabel.hide()
	LevelProgression.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (ProgressionTimer != null):
		LevelProgression.value = (ProgressionTimer.time_left / level_duration) * 100
