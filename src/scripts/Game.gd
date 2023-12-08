extends Node3D

var player_health: int
var monster_health: int

var _begin_sfx
var _gameover_sfx
var _gamewin_sfx

const NUMBER_OF_LEVELS = 3

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
	$Player/PlayerCharacterBody.player_pickup.connect(player_boost)
	
	$JellyMonster2.monster_eat.connect(monster_eat)
	
	$UI.set_player_hp(player_health)
	$UI.set_monster_hp(monster_health)
	$UI.set_leveltimer(level_duration_timer)
	
	_begin_sfx = preload("res://sound/begin.wav")
	_gameover_sfx = preload("res://sound/gameover.wav")
	_gamewin_sfx = preload("res://sound/gamewin.wav")
	
	play_sfx(_begin_sfx)

func _input(event):
	if event.is_action_pressed("reload"):
		reload()
	if event.is_action_pressed("next_level"):
		load_nextlevel()

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
	$JellyMonster2.on_game_over()
	await get_tree().create_timer(1.8).timeout
	get_tree().paused = true
	$UI.game_over()
	play_sfx(_gameover_sfx)
	
func game_win():
	get_tree().paused = true
	print("WIN !")
	play_sfx(_gamewin_sfx)
	$UI.game_won()
	#TODO load next level

func reload():
	get_tree().paused = true
	get_tree().reload_current_scene()
	get_tree().paused = false
	
func load_nextlevel():
	get_tree().paused = true
	var level_number = ($Level.LEVEL_NUMBER + 1)
	if level_number > NUMBER_OF_LEVELS:
		print("GAME WON !")
		level_number = 1
	var level_name = "OutOfJamLevel" + str(level_number)
	print("Loading Level " + level_name)
	get_tree().change_scene_to_file("res://src/scenes/" + level_name + ".tscn")
	get_tree().paused = false

func play_sfx(sfx):
	get_node("etc/AudioStreamPlayer").stream = sfx
	get_node("etc/AudioStreamPlayer").play()
