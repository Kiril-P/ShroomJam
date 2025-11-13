# rock_player.gd — FIXED
extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -350.0
@export var gravity: float = 980.0

@onready var sprite: AnimatedSprite2D = $sprite  # ← FIXED: AnimatedSprite2D
@onready var camera: Camera2D = $SideCamera

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# Left/Right
	var direction = Input.get_axis("move_left", "move_right")
	velocity.x = direction * speed
	
	move_and_slide()
	
	# Flip sprite
	if direction != 0:
		sprite.flip_h = direction < 0
	
	# Camera follow
	camera.global_position = global_position
