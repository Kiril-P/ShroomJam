extends Node2D

@onready var manager = $ShroomManager

func _ready():
	visible = false  # OFF at start
	manager.game_active = false

# Called by Fiona
func start_minigame():
	visible = true
	manager.start_game()
