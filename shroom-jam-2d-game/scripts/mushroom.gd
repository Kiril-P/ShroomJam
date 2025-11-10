extends Area2D
class_name ShroomHole

@export var pop_delay_min: float = 1.0
@export var pop_delay_max: float = 3.0
@export var is_bad_shroom: bool = true

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var is_popped: bool = false
var pop_timer: Timer

signal shroom_whacked(is_good_whack: bool)

func _ready():
	body_entered.connect(_on_player_entered)
	sprite.play("hiding")
	
	if is_bad_shroom:
		new_pop_cycle()

func new_pop_cycle():
	pop_timer = Timer.new()
	add_child(pop_timer)
	pop_timer.wait_time = randf_range(pop_delay_min, pop_delay_max)
	pop_timer.one_shot = true
	pop_timer.timeout.connect(_pop_up)
	pop_timer.start()

func _pop_up():
	if is_popped: return
	is_popped = true
	sprite.play("idling")

func _on_player_entered(body):
	if body.name == "Player":
		if is_popped:  # GOOD WHACK
			audio.play()
			sprite.play("hiding")
			is_popped = false
			shroom_whacked.emit(true)
			await get_tree().create_timer(0.5).timeout
			if is_bad_shroom:
				new_pop_cycle()
		else:  # BAD WHACK
			shroom_whacked.emit(false)
