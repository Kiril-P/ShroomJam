extends Node2D

@export var hole_scene: PackedScene = preload("res://objects/shroom_hole.tscn")
@onready var player = get_parent().get_node("Player")
@onready var score_label: Label = get_parent().get_node("UI/ScoreLabel")

var holes: Array[Area2D] = []
var score: int = 0

func _ready():
	spawn_holes()
	start_game()

func spawn_holes():
	var positions = [
		Vector2(-60, -60), Vector2(0, -60), Vector2(60, -60),
		Vector2(-60, 0),    Vector2(0, 0),    Vector2(60, 0),
		Vector2(-60, 60), Vector2(0, 60), Vector2(60, 60)
	]
	for pos in positions:
		var hole = hole_scene.instantiate()
		hole.global_position = pos
		add_child(hole)
		holes.append(hole)
		hole.whacked.connect(_on_whacked)

func start_game():
	score = 0
	score_label.text = "Score: 0"
	await get_tree().create_timer(1.0).timeout
	_spawn_loop()

func _spawn_loop():
	while get_parent().get_node("UI/TimerLabel").text.to_float() > 0:
		var hole = holes.pick_random()
		if not hole.is_popped:
			var is_bad = randf() < 0.7
			hole.pop_up(is_bad)
		await get_tree().create_timer(randf_range(1.0, 2.5)).timeout

func _on_whacked(points: int):
	score += points
	score_label.text = "Score: %d" % score
	if points < 0:
		var effect = get_parent().get_node("Effects")  # ← NOT $VHSFilter
		if effect:
			var tween = create_tween()
			tween.tween_property(effect, "modulate:a", 1.0, 0.1)
			tween.tween_property(effect, "modulate:a", 0.0, 0.1)
