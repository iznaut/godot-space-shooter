extends Node2D

export (Array, PackedScene) var formations

var current_formation
var enemy_container = Node.new()


func _ready():
	enemy_container.name = "Enemies"
	add_child(enemy_container)


func spawn_formation():
	formations.shuffle()
	var new_formation = formations[0]
	formations.pop_front()

	current_formation = new_formation.instance()

	add_child(current_formation)

	formations.push_back(new_formation)

	spawnEnemies(current_formation)


func spawnEnemies(formation_node):
	var enemy_spawners = formation_node.get_children()

	for spawner in enemy_spawners:
		var enemy = spawner.activate()
		$Enemies.add_child(enemy)
		enemy.flyIn(spawner.get_node("Position2D").global_position)
		yield(enemy.get_node("EnterTween"), "tween_completed")


func _on_Enemy_tree_exited():
	if (enemy_container.get_child_count() <= 0):
		current_formation.queue_free()
		spawn_formation()
