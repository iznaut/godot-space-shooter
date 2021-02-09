extends Tween


func _on_EnterTween_tree_entered():
	var this_enemy = get_parent()
	var spawner = this_enemy.get_parent()

	interpolate_property(
		this_enemy, "position", this_enemy.position,
		spawner.position, 1,
		Tween.TRANS_SINE, Tween.EASE_OUT
	)

	start()
