extends Node2D

@export var dialogue_resource: DialogueResource

@onready var interaction_area: Area2D = $InteractionArea

func _ready() -> void:
	# SAFEST WAY — preload the .tres file
	if not dialogue_resource:
		dialogue_resource = preload("res://dialogue/woman.dialogue.tres")

# This function is called by player
func trigger_interaction() -> void:
	if not dialogue_resource:
		push_error("No dialogue resource!")
		return
	
	DialogueManager.show_example_dialogue_balloon(dialogue_resource, "")
	
	var balloon = DialogueManager.show_example_dialogue_balloon(dialogue_resource)
	
	# Find player and freeze
	var player = get_tree().get_first_node_in_group("player")  # ← Add player to group "player"!
	if player:
		player.set_dialogue_active(true)
		balloon.dialogue_ended.connect(func(_res):
			player.set_dialogue_active(false)
		)
		
