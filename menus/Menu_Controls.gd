extends Control

func _on_Back_pressed():
	$Back.disabled = true
	get_tree().get_current_scene().get_node("Music/FX_ButtonOut").play()
	get_tree().get_current_scene().get_node("Camera2D/AnimationPlayer").queue("ControlsOut")
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().get_current_scene().get_node(".").current_screen = "Menu_Main"
	Global._Write_SaveData()
	queue_free()
