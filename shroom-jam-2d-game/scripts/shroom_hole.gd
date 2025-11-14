extends Area2D

@onready var sprite: AnimatedSprite2D = $Sprite
var is_popped: bool = false
var is_bad: bool = false

signal whacked(points: int)

func pop_up(bad: bool):
	is_bad = bad
	is_popped = true
	sprite.modulate = Color.RED if bad else Color.GREEN
	sprite.play("pop")
	await get_tree().create_timer(2.0).timeout
	if is_popped:
		retract()

func retract():
	is_popped = false
	sprite.play("hide")

func whack():
	if not is_popped: return
	is_popped = false
	var points = 10 if is_bad else -20
	emit_signal("whacked", points)
	sprite.play("whacked")
	await sprite.animation_finished
	retract()
