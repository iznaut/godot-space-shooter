extends Node2D

signal wave_completed(current_wave)

onready var formations = $Formations

var enemy_container = Node.new()
var wave_count = 1


func _ready():
	connect("wave_completed", Global, "_on_EnemyManager_wave_complete")
	connect("wave_completed", Global.UI, "_on_EnemyManager_wave_complete")

	# add container for spawned enemy nodes
	enemy_container.name = "Enemies"
	add_child(enemy_container)


func spawn_formation():
	var valid_formations = formations.get_child(Global.difficulty_level)
	var index = Global.rng.randi_range(0, valid_formations.get_child_count() - 1)
	var formation_node = valid_formations.get_child(index)
	var form_children = formation_node.get_children()
	var enemy_spawners = []

	for node in form_children:
		if node is Path2D:
			enemy_spawners += node.get_children()
		else:
			enemy_spawners.push_back(node)

	for spawner in enemy_spawners:
		var enemy = spawner.get_enemy()

		if spawner.get_parent() is Path2D:
			enemy.parent_path = spawner.get_parent()
			enemy.t = spawner.starting_t
			enemy.path_dir = spawner.path_dir
			enemy.path_move_speed = spawner.path_move_speed
		
		enemy_container.add_child(enemy)
		enemy.flyIn(spawner.global_position)
		yield(enemy.get_node("EnterTween"), "tween_completed")	


func _on_Player_Bullet_Created(bullet):
	connect("wave_completed", bullet, "queue_free")


func _on_Enemy_tree_exited():
	if enemy_container.get_child_count() <= 0:
		wave_count += 1
		emit_signal("wave_completed", wave_count)

		spawn_formation()
