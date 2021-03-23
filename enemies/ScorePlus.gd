extends Node2D

func _ready():
	$AnimationPlayer.play("Plus")
	Global.score += 1
	get_tree().get_current_scene().get_node("Z_Index/Score").text = str(Global.score)

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
