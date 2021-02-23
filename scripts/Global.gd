extends Node

onready var right_bounds = get_node("/root/World/Bounds/RightBounds").position.x
onready var middle = get_node("/root/World/Bounds/Middle").position
onready var World = get_node("/root/World")
onready var Camera = World.get_node("Camera2D")
onready var Player = World.get_node("Player")
onready var UI = World.get_node("UI")
onready var Menu = UI.get_node("Menu")
onready var EnemyManager = World.get_node("EnemyManager")

enum State {NOT_STARTED, IN_PROGRESS, OVER}
var game_state = State.NOT_STARTED

enum Difficulty {EASY, MEDIUM, HARD}
var difficulty_level = Difficulty.EASY

var rng

const GRAVITY = 50 # todo can edit project-level gravity instead

signal game_started
signal game_ended


func _ready(): # todo resart
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	connect("game_started", EnemyManager, "spawn_formation")
	connect("game_started", UI, "_on_game_started")
	init()


func _process(_delta):
	if Input.is_action_just_pressed("primary_action") and game_state == State.NOT_STARTED:
		emit_signal("game_started")
		get_tree().paused = false
		game_state = State.IN_PROGRESS

	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func shake_screen(trauma, time):
	Camera.trauma = trauma
	get_tree().paused = true
	yield(get_tree().create_timer(time), "timeout")
	get_tree().paused = false


func init():
	game_state = State.NOT_STARTED
	rng = RandomNumberGenerator.new()
	rng.randomize()
	print(game_state)
	get_tree().call_group("bullets", "queue_free")
	get_tree().call_group("enemies", "queue_free")


func _on_EnemyManager_wave_complete(wave_count):
	# raise difficulty every 10 waves
	if wave_count % 10 == 0:
		if wave_count == 30:
			get_tree().paused = true
			# todo restart at wave 1 on hard difficulty

		difficulty_level += 1