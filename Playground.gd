extends Node2D

var gameover_scene = preload("res://menus/Menu_Gameover.tscn")
var scoreplus_scene = preload("res://enemies/ScorePlus.tscn")
export (PackedScene) var enemy_fly

export var enemy_timer_min = 0.4
export var enemy_timer_max = 0.9
export var enemy_timer_ran = 0.3
export var enemy_timer_sco = 250.0


func _ready():
	Global.score = 0
	Global.stat_dash = 0
	Global.stat_refl = 0
	Global.stat_time = 0
	randomize()
	$TitleSequence.play()

func _on_TitleSequence_animation_finished():
	$TitleSequence.queue_free()


func _on_EnemyTimer_timeout(): # Enemy Spawning
	$EnemySpawn/EnemySpawnLocation.offset = randi()
	var enemy_scene = enemy_fly.instance()
	add_child(enemy_scene)
	
	var enemy_time = 0.0
	var factor = Global.score / enemy_timer_sco
	if factor > 1:
		factor = 1
	
	enemy_time = enemy_timer_max - ((enemy_timer_max - enemy_timer_min) * factor)
	$EnemyTimer.wait_time = rand_range(enemy_time - (enemy_timer_ran / 2), enemy_time + (enemy_timer_ran / 2))


func _on_ScoreTimer_timeout():
	Global.score += 1
	get_tree().get_current_scene().get_node("Z_Index/Score").text = str(Global.score)


func _on_Player_hit():
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$TotalPlaytimeTimer.stop()


func _on_TotalPlaytimeTimer_timeout():
	Global.stat_time += 1
