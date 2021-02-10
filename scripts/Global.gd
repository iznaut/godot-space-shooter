extends Node

onready var left_bounds = get_node("/root/World/Bounds/LeftBounds").position.x
onready var right_bounds = get_node("/root/World/Bounds/RightBounds").position.x
onready var Camera = get_node("/root/World/Camera2D")
onready var Player = get_node("/root/World/Player")
onready var HUD = get_node("/root/World/CanvasLayer/HUD")
onready var EnemyManager = get_node("/root/World/EnemyManager")

var game_over = false
var rng = RandomNumberGenerator.new()
var spawn_count = 0
var spawn_limit = 4

signal game_started
signal game_ended


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	connect("game_started", EnemyManager, "spawn_formation")
	connect("game_started", HUD, "_on_game_started")
	rng.randomize()


func _process(_delta):
	if Input.is_action_just_pressed("primary_action") and !Global.game_over and get_tree().paused:
		emit_signal("game_started")
		get_tree().paused = false
		# $Menu/StartLabel.hide()
		# $Menu/ScoreLabel.show()
		# $Menu/StartLabel.get_node("AudioStreamPlayer2D").play()

	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()