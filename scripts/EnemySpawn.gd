tool
extends Sprite

enum ENEMY_TYPE {SHOOTER, DODGER, HOMER}
export (ENEMY_TYPE) var enemy_type setget update_editor_texture

var enemy_scenes = [
	preload("res://scenes/enemies/Shooter.tscn"),
	preload("res://scenes/enemies/Dodger.tscn"),
	preload("res://scenes/enemies/Homer.tscn")
]


func _ready():
	if Engine.editor_hint:
		update_editor_texture(enemy_type)


func get_enemy():
	return enemy_scenes[enemy_type].instance()


func update_editor_texture(value):
	enemy_type = value
	texture = enemy_scenes[enemy_type].instance().get_node("AnimatedSprite").get_sprite_frames().get_frame("default", 0)
	update()
