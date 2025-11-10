extends CharacterBody2D

@export var speed: float = 60.0
@onready var sprite: AnimatedSprite2D = %sprite
@onready var actionable_finder: Area2D = $ActionableFinder  # Add this node!

var facing := "down"  # "down", "up", or "right" (right = left when flipped)
var is_in_dialogue := false  # Prevent movement during talk

func _ready() -> void:
	# Ensure ActionableFinder exists
	if not has_node("ActionableFinder"):
		push_error("ActionableFinder (Area2D) missing! Add it as child of player.")
		return

func _physics_process(_delta: float) -> void:
	# Skip movement if in dialogue
	if is_in_dialogue:
		velocity = Vector2.ZERO
		return

	var input := Vector2.ZERO
	if Input.is_action_pressed("move_right"): input.x += 1
	if Input.is_action_pressed("move_left"):  input.x -= 1
	if Input.is_action_pressed("move_down"):  input.y += 1
	if Input.is_action_pressed("move_up"):    input.y -= 1

	# Direction lock
	if input != Vector2.ZERO:
		if abs(input.x) > abs(input.y):
			input.y = 0
		else:
			input.x = 0
		input = input.normalized()

	velocity = input * speed
	move_and_slide()

	# ANIMATION
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
			"right":
				sprite.flip_h = sprite.flip_h  # keep last flip
				sprite.play("idle_right")
			"down":
				sprite.play("idle_down")
			"up":
				sprite.play("idle_up")

# Handle interaction input
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_interact") and not is_in_dialogue:
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			var npc = actionables[0].get_parent()
			if npc and npc.has_method("trigger_interaction"):
				npc.trigger_interaction()
			get_viewport().set_input_as_handled()

# Called by NPC balloon to pause/resume player
func set_dialogue_active(active: bool) -> void:
	is_in_dialogue = active
