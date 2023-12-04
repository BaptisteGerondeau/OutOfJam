extends Node3D

var player_health: int
var monster_health: int

@onready var level_duration_timer

func _ready():
	randomize()
	player_health = $Level.player_health
	monster_health = 0
	
	level_duration_timer = $Level/LevelDurationTimer
	level_duration_timer.timeout.connect(game_win)
	
	$Player/Gun.has_shot.connect(player_malus)
	$Player/PlayerCharacterBody.has_boosted.connect(player_malus.bind(3))
	$Player/PlayerCharacterBody.player_died.connect(game_over)
	
	$UI.set_player_hp(player_health)
	$UI.set_monster_hp(monster_health)
	$UI.set_leveltimer(level_duration_timer)
	
func player_malus(amount = 1):
	player_health -= amount
	$UI.set_player_hp(player_health)
	if (player_health <= 0):
		game_over()
		
func player_boost():
	$UI.set_player_hp(player_health)
	player_health += 1
	
func monster_eat():
	$UI.set_monster_hp(monster_health)
	monster_health += 1
	if (monster_health >= $Level.monster_health):
		game_over()
	
func game_over():
	print("GAME OVER !")
	get_tree().paused = true
	$UI.game_over()
	#TODO reload scene
	
func game_win():
	get_tree().paused = true
	print("WIN !")
	$UI.game_won()
	#TODO load next level
