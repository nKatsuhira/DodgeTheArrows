extends Control

var playsound = false

func _ready(): # Load right values
	$Audio/Value.text = str(db2linear(Global.save_data.audio) * 100)
	$Audio/HSlider.value = db2linear(Global.save_data.audio) * 100
	_update_Fullscreen()
	$WriteSaveData/CheckBox.pressed = Global.data_allowed
	$WriteSaveData/Directory.disabled = !$WriteSaveData/CheckBox.pressed
	
	#Resolution Dropdown Menu, get ID of list and trigger _Resolution_toggled
	$Resolution/Dropdown.get_popup().connect("id_pressed", self, "_Resolution_toggled")
	playsound = true

func _Resolution_toggled(ID): # Resolution Dropdown Menu
	match(ID):
		0: # 720p
			OS.window_size.x = 1280
			OS.window_size.y = 720
			$Resolution/Dropdown.text = "720p"
		1: # 900p
			OS.window_size.x = 1600
			OS.window_size.y = 900
			$Resolution/Dropdown.text = "900p"
		2: # 1080p
			OS.window_size.x = 1920
			OS.window_size.y = 1080
			$Resolution/Dropdown.text = "1080p"
		3: # 1440p
			OS.window_size.x = 2560
			OS.window_size.y = 1440
			$Resolution/Dropdown.text = "1440p"
		4: # 1800p
			OS.window_size.x = 3200
			OS.window_size.y = 1800
			$Resolution/Dropdown.text = "1800p"
		5: # 2160p
			OS.window_size.x = 3840
			OS.window_size.y = 2160
			$Resolution/Dropdown.text = "2160p"
	OS.center_window()
	get_tree().get_current_scene().get_node("Music/FX_Input").play()


func _update_Fullscreen():
	if OS.window_fullscreen == true:
		$Resolution/Dropdown.disabled = true
		$Resolution/Dropdown.text = "Fullscreen"
		$Fullscreen/CheckBox.pressed = true
	else:
		$Resolution/Dropdown.disabled = false
		$Resolution/Dropdown.text = str(OS.window_size.y) + "p"
		$Fullscreen/CheckBox.pressed = false

func _on_Fullscreen_CheckBox_toggled(_button_pressed): # Fullscreen CheckBox
	OS.window_fullscreen = $Fullscreen/CheckBox.pressed
	_update_Fullscreen()
	if playsound == true:
		get_tree().get_current_scene().get_node("Music/FX_Input").play()


func _on_Audio_HSlider_value_changed(value):
	$Audio/Value.text = str(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value / 100))
	if playsound == true:
		get_tree().get_current_scene().get_node("Music/FX_Input").play()
		playsound = false
		yield(get_tree().create_timer(0.1), "timeout")
		playsound = true


# SaveData Bullshit
func _on_WriteSaveData_CheckBox_toggled(_button_pressed):
	if $WriteSaveData/CheckBox.pressed == true:
		_Temp_SaveData()
		Global._Create_SaveData()
	else:
		Global._Delete_SaveData()
	
	if playsound == true:
		get_tree().get_current_scene().get_node("Music/FX_Input").play()
	# WriteSaveData Buttons on/off updated
	Global.data_allowed = $WriteSaveData/CheckBox.pressed
	$WriteSaveData/Directory.disabled = !$WriteSaveData/CheckBox.pressed

func _on_WriteSaveData_Directory_pressed(): # Open Folder Button
	OS.shell_open(ProjectSettings.globalize_path("user://"))
	get_tree().get_current_scene().get_node("Music/FX_Input").play()

func _Temp_SaveData():
	Global.save_data.resolutionX = OS.window_size.x
	Global.save_data.resolutionY = OS.window_size.y
	Global.save_data.fullscreen = $Fullscreen/CheckBox.pressed
	Global.save_data.audio = linear2db(($Audio/HSlider.value) / 100)


func _on_Back_pressed(): # Back Button and write save data
	_Temp_SaveData()
	Global._Write_SaveData()
	
	$Back.disabled = true
	get_tree().get_current_scene().get_node("Music/FX_ButtonOut").play()
	get_tree().get_current_scene().get_node("Camera2D/AnimationPlayer").queue("OptionsOut")
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().get_current_scene().get_node(".").current_screen = "Menu_Main"
	queue_free()
