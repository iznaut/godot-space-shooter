extends Node2D

var enemy_container = Node.new()


func _ready():
	enemy_container.name = "Enemies"
	add_child(enemy_container)


func spawn_formation(index = -1):
	var formations = $EnemyFormations.get_children()

	if index == -1:
		index = Global.rng.randi_range(0, formations.size() - 1)

	spawn_enemies(formations[index])


func spawn_enemies(formation_node):
	var enemy_spawners = formation_node.get_children()

	for spawner in enemy_spawners:
		var enemy = spawner.get_enemy()
		enemy_container.add_child(enemy)
		enemy.flyIn(spawner.global_position)
		yield(enemy.get_node("EnterTween"), "tween_completed")


func _on_Enemy_tree_exited():
	if (enemy_container.get_child_count() <= 0):
		# current_formation.queue_free()
		spawn_formation()
