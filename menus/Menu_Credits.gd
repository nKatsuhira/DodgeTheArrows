extends Control

func _on_Back_pressed():
	$Back.disabled = true
	get_tree().get_current_scene().get_node("Music/FX_ButtonOut").play()
	get_tree().get_current_scene().get_node("Camera2D/AnimationPlayer").queue("CreditsOut")
	yield(get_tree().create_timer(0.5), "timeout")
	get_tree().get_current_scene().get_node(".").current_screen = "Menu_Main"
	queue_free()


func _on_OpenLink_pressed():
	OS.shell_open("https://freemusicarchive.org/music/Jesse_Spillane/Art_of_Presentation")
	get_tree().get_current_scene().get_node("Music/FX_Input").play()


func _on_OpenLinkFont_pressed():
	OS.shell_open("https://fonts.google.com/specimen/Varela+Round")
	get_tree().get_current_scene().get_node("Music/FX_Input").play()
