extends Tween

export var magnitude = 25

var dodged = false
var dir_x = 1
var dodge_speed = 0.5

onready var this = get_parent()
onready var sprite_width = this.get_node("AnimatedSprite").get_sprite_frames().get_frame("default", 0).get_size().x
onready var timer = this.get_node("CooldownTimer")
onready var ShootAudio = get_parent().get_node("ShootAudio")


func dodge():
	check_side()

	var target = this.position
	target.x = clamp(
		target.x + (dir_x * magnitude),
		-sprite_width,
		Global.right_bounds - (sprite_width)
	)	

	#warning-ignore:return_value_discarded
	interpolate_property(
		this, "position", this.position,
		target, dodge_speed,
		Tween.TRANS_SINE, Tween.EASE_OUT
	)

	#warning-ignore:return_value_discarded
	start()
	ShootAudio.play()
	
	dodged = true


func check_side():
	if this.global_position.x >= get_node("/root/World/Bounds/Middle").position.x:
		dir_x = -1
	else:
		dir_x = 1


func _on_EnterTween_tween_completed():
	check_side()


func _on_DodgeTween_tween_completed(_object, _key):
	timer.start()


func _on_CooldownTimer_timeout():
	dodged = false


func _on_TriggerArea_body_entered(body):
	if !dodged and !this.is_falling and body.is_in_group("player_bullets"):
		dodge()
