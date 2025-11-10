extends ColorRect

func _input(event):
	if event.is_action_pressed("ui_accept"):  # press Enter/Space
		material.set_shader_parameter("enable_vhs", 
			!material.get_shader_parameter("enable_vhs"))
