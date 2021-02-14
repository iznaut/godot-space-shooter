extends Control

export var sfx_enabled = true

onready var start_label = $StartLabel
onready var game_display = $GameInProgress
onready var score_display = game_display.get_node("ScoreLabel")
onready var multi_display = game_display.get_node("MultiLabel")
onready var bullet_display = game_display.get_node("BulletDisplay")

var score_up_label = preload("res://scenes/ScoreUpLabel.tscn")

var score_queued = 0
var score_displayed = 0

func _ready():
	if !sfx_enabled:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -99)

func _process(_delta):
	while score_queued > 0:
		score_displayed += 1
		score_display.text = "score: \n" + String("%07d" % score_displayed)
		score_queued -= 1
		yield(get_tree().create_timer(0.2), "timeout")


func set_score_display_text(added_score):
	score_queued += added_score


func set_multi_display_text(text = false):
	if !text:
		multi_display.hide()
		get_node("ComboLostAudio").play()
	else:
		multi_display.text = text
		multi_display.show()


	# Global.MultiLabel.rect_position = global_position - Vector2(8,4)
	# Global.MultiLabel.text = String(ScoreManager.multiplier) + 'x'
	# Global.MultiLabel.visible = true


func _on_game_started():
	score_display.text = "score:\n0000000"
	multi_display.text = "multi x2"
	start_label.hide()
	game_display.show()
	

func update_bullet_pips(new_bullet):
	var bullet_pips = bullet_display.get_children()
	var pip_updated = false
	var index = 0

	while !pip_updated:
		if index < bullet_pips.size():
			var pip = bullet_pips[index]

			if new_bullet and pip.visible:
				pip.hide()
				pip_updated = true
			elif !new_bullet and !pip.visible:
				pip.show()
				pip_updated = true
			
			index += 1
		else:
			return


func _on_wave_complete():
	$WaveLabel.text = "wave " + String("%02d" % Global.wave_count)