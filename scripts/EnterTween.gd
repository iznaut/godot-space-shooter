extends Tween
# todo 
#onready var this_enemy = get_parent()
#onready var spawner = this_enemy.get_parent()


#func _on_Tween_tween_completed(_object, _key):
#	timer.start()


func _on_EnterTween_tree_entered():
	var this_enemy = get_parent()
	var spawner = this_enemy.get_parent()
	
	# print(this_enemy.name, this_enemy.position)
	# print(spawner.name, spawner.position)
	
	#warning-ignore:return_value_discarded
	interpolate_property(
		this_enemy, "position", this_enemy.position,
		spawner.position, 1,
		Tween.TRANS_SINE, Tween.EASE_OUT
	)

	#warning-ignore:return_value_discarded
	start()
