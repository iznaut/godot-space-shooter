tool
extends Sprite

enum ENEMY_TYPE {SHOOTER, DODGER, HOMER}
export (ENEMY_TYPE) var enemy_type setget update_editor_texture
export (float, EASE) var starting_t setget update_editor_position
export (int) var path_dir = 1
export (float) var path_move_speed = 2.5


var enemy_scenes = [
	preload("res://scenes/enemies/Shooter.tscn"),
	preload("res://scenes/enemies/Dodger.tscn"),
	preload("res://scenes/enemies/Homer.tscn")
]


func _ready():
	if Engine.editor_hint:
		update_editor_texture(enemy_type)
		update_editor_position(starting_t)


func get_enemy():
	return enemy_scenes[enemy_type].instance()


func update_editor_texture(value):
	enemy_type = value
	texture = enemy_scenes[enemy_type].instance().get_node("AnimatedSprite").get_sprite_frames().get_frame("default", 0)
	update()


func update_editor_position(value):
	starting_t = clamp(value, 0.0, 1.0)

	if Engine.editor_hint and get_parent() is Line2D:
		position = get_parent().curve.interpolate_baked(starting_t * get_parent().curve.get_baked_length())
