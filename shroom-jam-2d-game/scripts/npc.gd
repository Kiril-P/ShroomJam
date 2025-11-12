extends CharacterBody2D

@export var dialogue: DialogueResource
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func trigger_interaction() -> void:
	print("[NPC] Starting dialogue...")
	DialogueManager.show_example_dialogue_balloon(dialogue)
	
	if anim:
		anim.play("talk")
	
	set_process(false)
	set_physics_process(false)
	
	DialogueManager.dialogue_ended.connect(_on_dialogue_end, CONNECT_ONE_SHOT)

func _on_dialogue_end(_res):
	set_process(true)
	set_physics_process(true)
	if anim:
		anim.play("idle")
