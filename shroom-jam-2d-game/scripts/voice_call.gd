extends Node2D

@onready var audio_player: AudioStreamPlayer2D = $voice_call
@onready var subtitle_label: RichTextLabel = $CanvasLayer/SubtitleLabel
@onready var anim_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

var subtitle_timeline: Array = [
	{"time": 3.0,   "text": "[center][color=white][font_size=40]Max: He-hello? Is this Ethan?[/font_size][/color][/center]"},
	{"time": 7.5,   "text": "[center][color=white][font_size=40]Max: Oh great, hey man...[/font_size][/color][/center]"},
	# ADD ALL 52 SECONDS OF LINES HERE
	# Format: {"time": X.X, "text": "[center][color=color][font_size=40]LINE[/font_size][/color][/center]"}
	{"time": 52.0,  "text": ""}  # Clear at end
]

func _ready():
	audio_player.finished.connect(_on_voice_finished)
	audio_player.play()
	_show_subtitles()

func _show_subtitles():
	for subtitle in subtitle_timeline:
		await get_tree().create_timer(subtitle.time - get_time()).timeout
		subtitle_label.bbcode_text = subtitle.text

func get_time():
	return audio_player.get_playback_position()

func _on_voice_finished():
	print("VOICE ENDED — FADING TO MENU...")
	anim_player.play("fade_transition")
	await anim_player.animation_finished
	get_tree().change_scene_to_file("res://levels/main_menu_level.tscn")
