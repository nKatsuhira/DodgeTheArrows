extends Node2D

var mainmenu_scene = preload("res://menus/Menu_Main.tscn")
var options_scene = preload("res://menus/Menu_Options.tscn")
var credits_scene = preload("res://menus/Menu_Credits.tscn")
var controls_scene = preload("res://menus/Menu_Controls.tscn")
var playground_scene = preload("res://Playground.tscn")
var gameover_scene = preload("res://menus/Menu_Gameover.tscn")
var pause_scene = preload("res://menus/Pause.tscn")

onready var scene = get_tree().get_current_scene()

var current_screen = "."  # Screens: Menu_Main, Menu_Controls, Menu_Options, Menu_Credits, Menu_Gameover, Pause, Playground
var button_pressed = 0

func _ready():
	var save = File.new()
	if save.file_exists(Global.save_dir):
		OS.window_size.x = Global.save_data.resolutionX
		OS.window_size.y = Global.save_data.resolutionY
		OS.window_fullscreen = Global.save_data.fullscreen
		OS.center_window()
	
	save.close()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), Global.save_data.audio)
	_any_Button_pressed(2.3)


func _on_Options_pressed(): # Options Button
	_any_Button_pressed(0.5)
	$Music/FX_ButtonIn.play()
	var options_instance = options_scene.instance()
	options_instance.rect_position = Vector2(0, 1080)
	add_child(options_instance)
	options_instance.owner = self
	$Camera2D/AnimationPlayer.queue("OptionsIn")
	current_screen = "Menu_Options"


func _on_Credits_pressed(): # Credits Button
	_any_Button_pressed(0.5)
	$Music/FX_ButtonIn.play()
	var credits_instance = credits_scene.instance()
	credits_instance.rect_position = Vector2(1920, 0)
	add_child(credits_instance)
	credits_instance.owner = self
	$Camera2D/AnimationPlayer.queue("CreditsIn")
	current_screen = "Menu_Credits"


func _on_Controls_pressed(): # Controls Button
	_any_Button_pressed(0.5)
	$Music/FX_ButtonIn.play()
	var controls_instance = controls_scene.instance()
	controls_instance.rect_position = Vector2(-1920, 0)
	add_child(controls_instance)
	controls_instance.owner = self
	$Camera2D/AnimationPlayer.queue("ControlsIn")
	current_screen = "Menu_Controls"


func _on_Start_pressed(): # Start Game Button
	_any_Button_pressed(0.4)
	var playground_instance = playground_scene.instance()
	playground_instance.position = Vector2(0, -2160)
	
	$Music.play("MenuFadeOut")
	$Music/FX_Start.play()
	
	$Menu_Main/AnimationPlayer.playback_speed = 2  # button animation
	$Menu_Main/AnimationPlayer.play_backwards("Start")
	yield(get_tree().create_timer(0.45), "timeout")
	
	$Music/Ingame.play()
	
	add_child(playground_instance)
	scene.get_node("Playground/TitleSequence").show()
	$Camera2D.position = Vector2(0, -2160)
	$Camera2D/AnimationPlayer.queue("GameStart")
	current_screen = "Playground"
	
	yield(get_tree().create_timer(0.25), "timeout")
	$Music/Menu.stop()


func _Game_Over(): # When player is hit
	_any_Button_pressed(1.1)
	var bruderwas = get_tree().get_nodes_in_group("Fly") # +1 score for every Fly on screen
	for Fly in bruderwas:
		Fly._GameOver_score()
	
	$Music/Ingame.stop()
	$Music/FX_Death.play()
	
	# Save data
	if Global.score > Global.save_data.highscore:
		Global.save_data.highscore = Global.score
	Global.save_data.dash_used += Global.stat_dash
	Global.save_data.arrows_reflected += Global.stat_refl
	Global.save_data.totalscore += Global.score
	Global.save_data.time_survived += Global.stat_time
	
	# Create Instance
	var gameover_instance = gameover_scene.instance()
	gameover_instance.position = Vector2(0, -1080)
	add_child(gameover_instance)
	# Move Camera
	yield(get_tree().create_timer(1.2), "timeout")
	Global._Write_SaveData()
	$Camera2D.position = Vector2(0, 0)
	$Camera2D/AnimationPlayer.play("GameOver")
	$Music/Gameover.play()
	
	if scene.get_node_or_null("Pause") != null: # unfuck pause if someone is pause scaming
		scene.get_node("Pause")._fuck()
	
	yield(get_tree().create_timer(0.25), "timeout")
	$Z_Index/Score.text = "Score: " + str(Global.score)
	yield(get_tree().create_timer(0.25), "timeout")
	get_node("Playground").queue_free()
	current_screen = "Menu_Gameover"


func _Retry_pressed(): # GameOver Menu, Retry-Button
	_any_Button_pressed(0.49)
	
	var playground_instance = playground_scene.instance()
	playground_instance.position = Vector2(0, -2160)
	add_child(playground_instance)
	scene.get_node("Playground/TitleSequence").hide()
	
	$Camera2D/AnimationPlayer.play("GameRetry")
	$Music/Gameover.stop()
	$Music/FX_Start.play()
	
	yield(get_tree().create_timer(0.25), "timeout")
	$Z_Index/Score.text = str(Global.score)
	$Music/Ingame.play()
	yield(get_tree().create_timer(0.25), "timeout")
	
	get_node("Menu_Gameover").queue_free()
	current_screen = "Playground"


func _Menu_pressed(): # GameOver Menu, Menu-Button
	_any_Button_pressed(0.49)
	
	$Camera2D/AnimationPlayer.play("GameMenu")
	$Menu_Main/TitleSequence.hide()
	
	if $Music/Menu.playing == false:
		$Music.play("MenuFadeIn")
		$Music/Menu.play()
	$Music/FX_ButtonOut.play()
	$Music/Gameover.stop()
	
	yield(get_tree().create_timer(0.25), "timeout")
	$Menu_Main/TitleSequence.show()
	$Menu_Main/TitleSequence.frame = 0
	
	yield(get_tree().create_timer(0.25), "timeout")
	$Z_Index/Score.text = str(Global.score)
	get_node("Menu_Gameover").queue_free()
	
	yield(get_tree().create_timer(1.05), "timeout")
	$Menu_Main/AnimationPlayer.playback_speed = 1
	$Menu_Main/AnimationPlayer.play("Start")
	current_screen = "Menu_Main"


func _Pause():
	get_tree().paused = true
	var pause_instance = pause_scene.instance()
	pause_instance.rect_position = Vector2(0, -2160)
	add_child(pause_instance)
	current_screen = "Pause"


func _input(_event):
	if $Camera2D/AnimationPlayer.is_playing() == false && $Menu_Main/AnimationPlayer.is_playing() == false && button_pressed == 0:
		if Input.is_action_just_pressed("Start") && current_screen == "Menu_Main":       # Start-Button in Menu_Main
			_on_Start_pressed()
		
		if Input.is_action_just_pressed("Start") && current_screen == "Menu_Gameover":   # Retry-Button in Menu_Gameover
			_Retry_pressed()
		
		if Input.is_action_just_pressed("Back") && current_screen == "Menu_Gameover":    # Menu-Button in Menu_Gameover
			_Menu_pressed()
		
		if Input.is_action_just_pressed("Back") && current_screen == "Menu_Controls":    # Back-Button in Menu_Controls
			scene.get_node("Menu_Controls")._on_Back_pressed()
			_any_Button_pressed(0.5)
		
		if Input.is_action_just_pressed("Back") && current_screen == "Menu_Options":     # Back-Button in Menu_Options
			scene.get_node("Menu_Options")._on_Back_pressed()
			_any_Button_pressed(0.5)
		
		if Input.is_action_just_pressed("Back") && current_screen == "Menu_Credits":     # Back-Button in Menu_Credits
			scene.get_node("Menu_Credits")._on_Back_pressed()
			_any_Button_pressed(0.5)
		
		if Input.is_action_just_pressed("Pause") && current_screen == "Playground":      # Pause-Button in Playground, WIP
			_Pause()


func _any_Button_pressed(pause_time): # Deactivates Buttons to prevent double trigger
	button_pressed = 1
	if current_screen == "Menu_Main":
		$Menu_Main/Start.disabled = true
		$Menu_Main/Options.disabled = true
		$Menu_Main/Credits.disabled = true
		$Menu_Main/Controls.disabled = true
		yield(get_tree().create_timer(pause_time), "timeout")
		$Menu_Main/Start.disabled = false
		$Menu_Main/Options.disabled = false
		$Menu_Main/Credits.disabled = false
		$Menu_Main/Controls.disabled = false
	elif current_screen == "Menu_Gameover":
		scene.get_node("Menu_Gameover/Retry").disabled = true
		scene.get_node("Menu_Gameover/Menu").disabled = true
		yield(get_tree().create_timer(pause_time), "timeout")
		scene.get_node("Menu_Gameover/Retry").disabled = false
		scene.get_node("Menu_Gameover/Menu").disabled = false
		yield(get_tree().create_timer(pause_time*3), "timeout")
	else:
		yield(get_tree().create_timer(pause_time), "timeout")
	button_pressed = 0


func _on_GameoverMusic_finished():
	yield(get_tree().create_timer(0.3), "timeout")
	if $Music/Ingame.playing == false:
		$Music.play("MenuFadeIn")
		$Music/Menu.play()
