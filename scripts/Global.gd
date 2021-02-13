extends Node

onready var left_bounds = get_node("/root/World/Bounds/LeftBounds").position.x
onready var right_bounds = get_node("/root/World/Bounds/RightBounds").position.x
onready var World = get_node("/root/World")
onready var Camera = World.get_node("Camera2D")
onready var Player = World.get_node("Player")
onready var HUD = World.get_node("CanvasLayer/HUD")
onready var EnemyManager = World.get_node("EnemyManager")

var game_in_progress = false
var game_over = false
var rng = RandomNumberGenerator.new()
var spawn_count = 0
var spawn_limit = 4
var gravity = 50
var wave_count = 1

const Enemy: = preload("res://scripts/Enemy.gd")
const Bullet: = preload("res://scripts/Bullet.gd")
const Coin: = preload("res://scripts/Coin.gd")

signal game_started
signal game_ended


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	connect("game_started", EnemyManager, "spawn_formation")
	connect("game_started", HUD, "_on_game_started")
	rng.randomize()


func _process(_delta):
	if Input.is_action_just_pressed("primary_action") and !Global.game_in_progress and get_tree().paused:
		emit_signal("game_started")
		game_in_progress = true
		get_tree().paused = false
		# $Menu/StartLabel.hide()
		# $Menu/ScoreLabel.show()
		# $Menu/StartLabel.get_node("AudioStreamPlayer2D").play()

	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func shake_screen(trauma, time):
	Camera.trauma = trauma
	var timer = get_tree().create_timer(time)
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	yield(timer, "timeout")
	get_tree().paused = false
	pause_mode = Node.PAUSE_MODE_STOP


func _on_wave_complete():
	wave_count += 1