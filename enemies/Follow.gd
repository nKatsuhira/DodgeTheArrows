extends KinematicBody2D

var scoreplus_scene = preload("res://enemies/ScorePlus.tscn")

export var follow_speed_max = 325
var follow_speed = 325
onready var player = get_tree().get_current_scene().get_node("Playground/Player")

func _physics_process(delta):
	look_at(player.get_global_position())
	move_and_collide((player.position - self.position).normalized() * follow_speed * delta)
	
	follow_speed -= 1
	if follow_speed < (follow_speed_max / 10):
		follow_speed = follow_speed_max

func _GameOver_score(): # Dead stuff
	var scoreplus_instance = scoreplus_scene.instance()
	scoreplus_instance.position = self.position
	find_parent("Playground").add_child(scoreplus_instance)
	queue_free()
