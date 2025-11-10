func trigger_interaction():
	print("FIONA: Trying to start minigame...")
	
	# THIS LINE WORKS FROM ANYWHERE — FINDS SHROOMSTOMPERS 100%
	var shroom_node = get_tree().current_scene.get_node("ShroomStompers")
	
	if shroom_node == null:
		print("ERROR: ShroomStompers NOT found in current scene!")
		print("Make sure it's in your HUB scene and named EXACTLY 'ShroomStompers'")
		return
	
	print("FOUND ShroomStompers! Starting game...")
	shroom_node.start_minigame()
	
	visible = false
