extends Node2D

@onready var timer_label: Label = $UI/TimerLabel
@onready var fade = preload("res://objects/fade.tscn")
var time_left: float = 45.0

func _ready():
	timer_label.text = "45.0"
	$ShroomManager.start_game()

func _process(delta):
	if time_left > 0:
		time_left -= delta
		timer_label.text = "%.1f" % time_left
		if time_left <= 0:
			end_game()

func end_game():
	var score = $ShroomManager.score
	var won = score >= 25
	print("GAME OVER! Score: ", score, " Won: ", won)
	var fade_inst = fade.instantiate()
	add_child(fade_inst)
	fade_inst.get_node("AnimationPlayer").play("fade_in")
	await fade_inst.get_node("AnimationPlayer").animation_finished
	get_tree().change_scene_to_file("res://levels/forest_level.tscn")
