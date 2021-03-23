extends Button

export(String) var action_name = ""
export var button = 0
var get_set = false


func _ready():
	if Global.key_dict[action_name][button-1] == "InputEventKey":
		text = OS.get_scancode_string(Global.key_dict[action_name][button])
	
	elif Global.key_dict[action_name][button-1] == "InputEventJoypadButton":
		text = Input.get_joy_button_string(Global.key_dict[action_name][button])
	
	elif Global.key_dict[action_name][button-1] == "InputEventMouseButton":
		text = "MB: " + str(Global.key_dict[action_name][button])


func _pressed():
	text = "..."
	get_tree().get_current_scene().get_node(".").button_pressed = 1
	get_tree().get_current_scene().get_node("Music/FX_Input").play()
	get_set = true
	var bruderwas = get_tree().get_nodes_in_group("KeyRemapButton")
	for key in bruderwas:
		if key != self:
			key.disabled = true


func _input(event):
	if !(event is InputEventMouseMotion) && !(event is InputEventJoypadMotion):
		if self.disabled == false && get_set == true:
			if event is InputEventKey:
				for key in Global.key_dict:
					if Global.key_dict[key].has(event.scancode) && Global.key_dict[action_name][button] != event.scancode:
						_Button_Fail()
						return
				var newkey = InputEventKey.new() #Remove the old keys
				newkey.scancode = int(Global.key_dict[action_name][button])
				InputMap.action_erase_event(action_name, newkey)
				
				InputMap.action_add_event(action_name, event) #Add the new key for this action
				
				text = OS.get_scancode_string(event.scancode) #Show it as readable to the user
				
				# Saving
				Global.key_dict[action_name][button-1] = "InputEventKey"
				Global.key_dict[action_name][button] = event.scancode 
				get_tree().get_current_scene().get_node("Menu_Controls/Back").text = "Save"
				
				_Button_Reactivate()

			elif event is InputEventJoypadButton:
				for key in Global.key_dict:
					if Global.key_dict[key].has(event.button_index) && Global.key_dict[action_name][button] != event.button_index:
						_Button_Fail()
						return
				var newkey = InputEventJoypadButton.new()
				newkey.button_index = int(Global.key_dict[action_name][button])
				InputMap.action_erase_event(action_name, newkey)
				
				InputMap.action_add_event(action_name, event)
				
				text = Input.get_joy_button_string(event.button_index)
				
				Global.key_dict[action_name][button-1] = "InputEventJoypadButton"
				Global.key_dict[action_name][button] = event.button_index
				get_tree().get_current_scene().get_node("Menu_Controls/Back").text = "Save"
				
				_Button_Reactivate()

			elif event is InputEventMouseButton:
				if event.button_index != 1:
					for key in Global.key_dict:
						if Global.key_dict[key].has(event.button_index) && Global.key_dict[action_name][button] != event.button_index:
							_Button_Fail()
							return
					var newkey = InputEventMouseButton.new()
					newkey.button_index = int(Global.key_dict[action_name][button])
					InputMap.action_erase_event(action_name, newkey)
					
					InputMap.action_add_event(action_name, event)
					
					text = "MB: " + str(event.button_index)
					
					Global.key_dict[action_name][button-1] = "InputEventMouseButton"
					Global.key_dict[action_name][button] = event.button_index
					get_tree().get_current_scene().get_node("Menu_Controls/Back").text = "Save"
					
					_Button_Reactivate()

func _Button_Reactivate():
	get_tree().get_current_scene().get_node("Music/FX_Input").play()
	get_set = false
	var bruderwas = get_tree().get_nodes_in_group("KeyRemapButton")
	for key in bruderwas:
			key.disabled = false
	get_tree().get_current_scene().get_node("Menu_Controls/Reset")._ready()
	yield(get_tree().create_timer(0.1), "timeout")
	get_tree().get_current_scene().get_node(".").button_pressed = 0


func _Button_Fail():
	if $ButtonFailTimer.time_left < 0.01:
		print("fail")
		$ButtonFailTimer.start()
		get_tree().get_current_scene().get_node("Music/FX_ButtonFail").play()
