# player.gd — FINAL WORKING VERSION
extends CharacterBody2D

@export var speed: float = 60.0
@onready var sprite: AnimatedSprite2D = %sprite
@onready var actionable_finder: Area2D = $ActionableFinder

var facing := "down"
var is_in_dialogue := false
var nearby_npcs: Array = []

func _ready() -> void:
	if not actionable_finder:
		push_error("ActionableFinder missing!")
		return
	
	# Connect to area_entered (NOT body_entered)
	actionable_finder.area_entered.connect(_on_area_entered)
	actionable_finder.area_exited.connect(_on_area_exited)
	
	DialogueManager.dialogue_started.connect(_on_dialogue_start)
	DialogueManager.dialogue_ended.connect(_on_dialogue_end)

func _physics_process(delta):
	if is_in_dialogue:
		velocity = Vector2.ZERO
		return

	var input = Vector2.ZERO
	if Input.is_action_pressed("move_right"): input.x += 1
	if Input.is_action_pressed("move_left"): input.x -= 1
	if Input.is_action_pressed("move_down"): input.y += 1
	if Input.is_action_pressed("move_up"): input.y -= 1

	if input != Vector2.ZERO:
		if abs(input.x) > abs(input.y): input.y = 0
		else: input.x = 0
		input = input.normalized()

	velocity = input * speed
	move_and_slide()

	if velocity != Vector2.ZERO:
		if velocity.x != 0:
			facing = "right"
			sprite.flip_h = velocity.x < 0
			sprite.play("walk_right")
		elif velocity.y > 0:
			facing = "down"
			sprite.play("walk_down")
		else:
			facing = "up"
			sprite.play("walk_up")
	else:
		match facing:
			"right": sprite.play("idle_right")
			"down": sprite.play("idle_down")
			"up": sprite.play("idle_up")

func _unhandled_input(event):
	if event.is_action_pressed("move_interact") and not is_in_dialogue and nearby_npcs.size() > 0:
		var npc = nearby_npcs[0]
		print("[PLAYER] TRIGGERING: ", npc.name)
		npc.trigger_interaction()
		get_viewport().set_input_as_handled()

# === AREA DETECTION (NOT BODY) ===
func _on_area_entered(area: Area2D):
	var npc = area.get_parent()
	if npc and npc.has_method("trigger_interaction") and npc not in nearby_npcs:
		nearby_npcs.append(npc)
		print("[PLAYER] NPC DETECTED: ", npc.name)

func _on_area_exited(area: Area2D):
	var npc = area.get_parent()
	if npc in nearby_npcs:
		nearby_npcs.erase(npc)
		print("[PLAYER] NPC LEFT: ", npc.name)

func _on_dialogue_start(_res):
	is_in_dialogue = true
	print("[PLAYER] DIALOGUE STARTED")

func _on_dialogue_end(_res):
	is_in_dialogue = false
	print("[PLAYER] DIALOGUE ENDED")
