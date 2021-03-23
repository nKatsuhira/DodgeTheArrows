extends Node

# Save Data
var data_allowed = false
var save_data = {
	# Options
	"resolutionX" : 1920,
	"resolutionY" : 1080,
	"fullscreen" : false,
	"audio" : -10.457575,
	# Statistics
	"highscore" : 0,
	"totalscore" : 0,
	"arrows_reflected" : 0,
	"dash_used" : 0,
	"time_survived" : 0
}

# Ingame
var score = 0
var stat_dash = 0  # dashed this round
var stat_refl = 0  # arrows (fly) reflected this round
var stat_time = 0  # time (in sec) played this round

# Create, write, read and delete save data 
var save_dir = "user://save.dat"

func _Create_SaveData(): # Create File
	var save = File.new()
	if save.file_exists(save_dir):
		print(save_data)
	else:
		var error = save.open(save_dir, File.WRITE)
		if error == OK:
			save.store_var(save_data)
			save.close()
			_Message_SaveData("created")


func _Write_SaveData(): # Overwrite
	var save = File.new()
	if save.file_exists(save_dir):
		var error = save.open(save_dir, File.WRITE)
		if error == OK:
			save.store_var(save_data)
			save.close()
			_Message_SaveData("saved")
			_Save_Keys()


func _ready(): # Read
	var save = File.new()
	if save.file_exists(save_dir):
		var error = save.open(save_dir, File.READ)
		if error == OK:
			var save_data_temp = save.get_var()
			save_data = save_data_temp
			save.close()
			_Message_SaveData("loaded")
			Global.data_allowed = true
	_Load_Keys()


func _Delete_SaveData():
	var save = Directory.new()
	save.remove(save_dir)
	save.remove(file_name)
	_Message_SaveData("deleted")


func _Message_SaveData(text):
	var animation = get_tree().get_current_scene().get_node("SettingsSaved/Animation")
	
	if animation.is_playing() == true:
		animation.queue(text)
	else:
		animation.play(text)
	
	if animation.get_queue().size() > 2:
		animation.playback_speed = 2
	else:
		animation.playback_speed = 1



# guikeybinding.gd
var file_name = "user://keybindings.json"
var setting_key = false

var key_dict = {
	"Dash" : ["InputEventKey", 32, "InputEventKey", 16777237],
	"Up" : ["InputEventKey", 87, "InputEventKey", 16777232],
	"Down" : ["InputEventKey", 83, "InputEventKey", 16777234],
	"Left" : ["InputEventKey", 65, "InputEventKey", 16777231],
	"Right" : ["InputEventKey", 68, "InputEventKey", 16777233],
	"Start" : ["InputEventKey", 32, "InputEventKey", 16777221],
	"Pause" : ["InputEventKey", 16777217, "InputEventKey", 16777225],
	"Back" : ["InputEventKey", 16777217, "InputEventKey", 16777220]
}


func _Load_Keys():
	var file = File.new()
	if file.file_exists(file_name):
		_Delete_Old_Keys()
		file.open(file_name,File.READ)
		
		var loadkey = parse_json(file.get_as_text())
		if typeof(loadkey) == TYPE_DICTIONARY:
			key_dict = loadkey
			_Setup_Keys()

func _Delete_Old_Keys():
	for i in Global.key_dict:
		InputMap.action_erase_events(i)

func _Save_Keys():
	for i in key_dict:
		var savekey = InputMap.get_action_list(i)
		for j in [0, 2]:
			if savekey is InputEventKey:
				key_dict[i][j] = "InputEventKey"
				key_dict[i][j+1] = savekey[j+1].scancode
			if savekey is InputEventJoypadButton:
				key_dict[i][j] = "InputEventJoypadButton"
				key_dict[i][j+1] = savekey[j+1].button_index
			if savekey is InputEventMouseButton:
				key_dict[i][j] = "InputEventMouseButton"
				key_dict[i][j+1] = savekey[j+1].button_index
	
	var file = File.new()
	file.open(file_name,File.WRITE)
	file.store_string(to_json(Global.key_dict))
	file.close()

func _Setup_Keys():
	for i in key_dict:
		for j in [0, 2]:
			if key_dict[i][j] == "InputEventKey":
				var setupkey = InputEventKey.new()
				setupkey.scancode = key_dict[i][j+1]
				InputMap.action_add_event(i, setupkey)
			
			if key_dict[i][j] == "InputEventJoypadButton":
				var setupkey = InputEventJoypadButton.new()
				setupkey.button_index = key_dict[i][j+1]
				InputMap.action_add_event(i, setupkey)
			
			if key_dict[i][j] == "InputEventMouseButton":
				var setupkey = InputEventMouseButton.new()
				setupkey.button_index = key_dict[i][j+1]
				InputMap.action_add_event(i, setupkey)
