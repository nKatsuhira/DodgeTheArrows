extends Button

var reset_keys = {
	"Dash" : ["InputEventKey", 32, "InputEventKey", 16777237],
	"Up" : ["InputEventKey", 87, "InputEventKey", 16777232],
	"Down" : ["InputEventKey",83, "InputEventKey", 16777234],
	"Left" : ["InputEventKey", 65, "InputEventKey", 16777231],
	"Right" : ["InputEventKey", 68, "InputEventKey", 16777233],
	"Start" : ["InputEventKey", 32, "InputEventKey", 16777221],
	"Pause" : ["InputEventKey", 16777217, "InputEventKey", 16777225],
	"Back" : ["InputEventKey", 16777217, "InputEventKey", 16777220]
}


func _ready():
	if Global.key_dict.hash() != reset_keys.hash():
		self.disabled = false
	else:
		self.disabled = true

func _on_Reset_pressed():
	Global.key_dict = reset_keys
	get_tree().get_current_scene().get_node("Music/FX_Input").play()
	var bruderwas = get_tree().get_nodes_in_group("KeyRemapButton")
	for key in bruderwas:
		key._ready()

#func _compare_Dicts(dict1:Dictionary, dict2:Dictionary):
#	if dict1.size() != dict2.size(): # Checkt die Anzahl an Keys
#		return false
#	for i in dict1.keys(): # Check ob es die gleichen Keys sind
#		if dict2.has(i):
#			if dict1[i] != dict2[i]:
#				return false
#		else:
#			return false
#	return true
