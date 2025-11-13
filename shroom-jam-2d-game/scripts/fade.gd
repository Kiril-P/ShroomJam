# fade.gd — REUSABLE
extends CanvasLayer

@onready var anim: AnimationPlayer = $AnimationPlayer

signal fade_complete

func fade_in():
	anim.play("fade_in")
	await anim.animation_finished
	fade_complete.emit()

func fade_out():
	anim.play("fade_out")
	await anim.animation_finished
	fade_complete.emit()
