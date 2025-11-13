extends CanvasLayer

@onready var timer_label: Label = $TimerLabel

var time_left: float = 30.0

func _ready():
	var timer = Timer.new()
	timer.wait_time = 0.016  # 60 FPS
	timer.timeout.connect(_update_timer)
	add_child(timer)
	timer.start()

func _update_timer():
	time_left -= 0.016
	timer_label.text = "Time: %.1f" % time_left
	
	if time_left <= 0:
		end_minigame()

func end_minigame():
	# Fade out + return to overworld
	get_tree().change_scene_to_file("res://levels/forest_level.tscn")
