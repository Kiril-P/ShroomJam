extends Area2D

@onready var fade_scene = preload("res://objects/fade.tscn")

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		print("ENTERING CAVE...")
		var fade = fade_scene.instantiate()
		get_tree().current_scene.add_child(fade)
		await fade.fade_in()
		get_tree().change_scene_to_file("res://levels/wack-a-mole.tscn")
		fade.queue_free()
