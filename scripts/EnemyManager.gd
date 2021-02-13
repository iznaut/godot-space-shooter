extends Node2D

signal wave_completed

var enemy_container = Node.new()


func _ready():
	enemy_container.name = "Enemies"
	add_child(enemy_container)

	connect("wave_completed", Global, "_on_wave_complete")
	connect("wave_completed", Global.HUD, "_on_wave_complete")


func spawn_formation(index = -1):
	var formations = $EnemyFormations.get_children()

	if index == -1:
		index = Global.rng.randi_range(0, formations.size() - 1)

	spawn_enemies(formations[index])


func spawn_enemies(formation_node):
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
		emit_signal("wave_completed")
		spawn_formation()
