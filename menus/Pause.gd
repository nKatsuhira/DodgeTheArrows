extends Control


func _ready():
	var pause_list = InputMap.get_action_list("Pause")
	var pause_key = [null, null]
	
	for i in range(0, 2):
		if pause_list[i] is InputEventKey:
			pause_key[i] = OS.get_scancode_string(pause_list[i].scancode)
		elif pause_list[i] is InputEventJoypadButton:
			pause_key[i] = Input.get_joy_button_string(pause_list[i].button_index)
		elif pause_list[i] is InputEventMouseButton:
			pause_key[i] = "Mouse Button: " + str(pause_list[i].button_index)
		
	$PauseTitle/Key.text = "Press [" + str(pause_key[0]) + "] or [" + str(pause_key[1]) + "] to unpause"


func _input(_event):
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = false
		get_tree().get_current_scene().get_node(".").current_screen = "Playground"
		get_tree().get_current_scene().get_node(".")._any_Button_pressed(0.1)
		queue_free()


func _fuck():
	get_tree().paused = false
	get_tree().get_current_scene().get_node(".").current_screen = "Playground"
	queue_free()




#	if pause_keys[1] is InputEventKey:
#		pause_key1 = OS.get_scancode_string(pause_keys[1].scancode)
#	elif pause_keys[1] is InputEventJoypadButton:
#		pause_key1 = Input.get_joy_button_string(pause_keys[1].button_index)
#	elif pause_keys[1] is InputEventMouseButton:
#		pause_key1 = "Mouse Button: " + str(pause_keys[1].button_index)

#	var pause_keys = InputMap.get_action_list("Pause")
#	var pause_key1 = OS.get_scancode_string(pause_keys[0].scancode)
#	var pause_key2 = OS.get_scancode_string(pause_keys[1].scancode)

#	for action in InputMap.get_action_list("Pause"):
#		if action is InputEventKey:
#			 print(OS.get_scancode_string(action.scancode))
