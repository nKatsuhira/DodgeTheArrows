extends Control

func _ready():
	yield(get_tree().create_timer(0.5), "timeout")
	$TitleSequence.show()
	$TitleSequence.play()

func _on_TitleSequence_animation_finished():
	$AnimationPlayer.play("Start")
	get_tree().get_current_scene().get_node(".").current_screen = "Menu_Main"
