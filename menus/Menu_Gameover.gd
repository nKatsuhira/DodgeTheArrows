extends Node2D

var totalscore_sec  # all time in seconds
var totalscore_min  # all time in minutes

var totalscore_rou_sec  # this rounds time in seconds
var totalscore_rou_min  # this rounds time in minutes

func _ready():
	$Highscore.text = "Highscore: " + str(Global.save_data.highscore)
	
	# This round stats
	$ThisRoundStats.text = "Arrows reflected: " + str(Global.stat_refl)
	$ThisRoundStats.text += "\nDashes used: " + str(Global.stat_dash)
	totalscore_rou_min = floor(Global.stat_time / 60)
	totalscore_rou_sec = Global.stat_time % 60
	if totalscore_rou_min > 0:
		$ThisRoundStats.text += "\nTime played: " + str(totalscore_rou_min) + "min. " + str(totalscore_rou_sec) + "sec."
	else:
		$ThisRoundStats.text += "\nTime played: " + str(totalscore_rou_sec) + "sec."
	
	
	# All-time stats
	$AllTimeLabel/Scores.text = "Arrows reflected: " + str(Global.save_data.arrows_reflected)
	$AllTimeLabel/Scores.text += "\nDashes used: " + str(Global.save_data.dash_used)
	totalscore_min = floor(Global.save_data.time_survived / 60)
	totalscore_sec = Global.save_data.time_survived % 60
	if totalscore_min > 0:
		$AllTimeLabel/Scores.text += "\nTime played: " + str(totalscore_min) + "min. " + str(totalscore_sec) + "sec."
	else:
		$AllTimeLabel/Scores.text += "\nTime played: " + str(totalscore_sec) + "sec."
	$AllTimeLabel/Scores.text += "\nTotal score: " + str(Global.save_data.totalscore)


func _on_Retry_pressed():
	get_tree().get_current_scene().get_node(".")._Retry_pressed()


func _on_Menu_pressed():
	get_tree().get_current_scene().get_node(".")._Menu_pressed()
