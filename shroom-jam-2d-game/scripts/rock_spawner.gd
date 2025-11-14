# rock_spawner.gd — WITH 4-SECOND CLEANUP
extends Node2D

@export var spawn_rate: float = 1.5
@export var spawn_height: float = -250.0
@export var min_x: float = -200.0
@export var max_x: float = 200.0

@onready var timer: Timer = $SpawnTimer
var rock_scene = preload("res://objects/rock.tscn")
var active_rocks: Array[RigidBody2D] = []

func _ready():
	timer.wait_time = 1.0 / spawn_rate
	timer.timeout.connect(_spawn_rock)
	timer.start()

func _process(delta):
	# CHECK ALL ROCKS FOR PLAYER COLLISION
	for rock in active_rocks:
		if not is_instance_valid(rock):
			continue
		var player = get_tree().get_first_node_in_group("MinigamePlayer")
		if player and rock.global_position.distance_to(player.global_position) < 20.0:
			print("ROCK HIT PLAYER!")
			kill_player()
			break

func _spawn_rock():
	var rock = rock_scene.instantiate()
	rock.global_position.x = randf_range(min_x, max_x)
	rock.global_position.y = spawn_height
	get_parent().add_child(rock)
	active_rocks.append(rock)
	
	# **Cleanup of rocks
	await get_tree().create_timer(2.5).timeout
	if is_instance_valid(rock):
		rock.queue_free()
		active_rocks.erase(rock)

func kill_player():
	print("KILLING PLAYER — FADING OUT...")
	var fade = preload("res://objects/fade.tscn").instantiate()
	get_tree().current_scene.add_child(fade)
	fade.get_node("AnimationPlayer").play("fade_in")
	await fade.get_node("AnimationPlayer").animation_finished
	get_tree().change_scene_to_file("res://levels/forest_level.tscn")
	fade.queue_free()
