extends KinematicBody2D

var scoreplus_scene = preload("res://enemies/ScorePlus.tscn")
var trail_scene = preload("res://enemies/Trail.tscn")

export var fly_speed_min = 300    # minimum speed range
export var fly_speed_max = 550    # maximum speed range
export var fly_speed_ran = 150    # speed range (-/2 to +/2)
export var fly_speed_sco = 250.0  # score when max speed should be reached
export var fly_speed_ref = 100    # reflect speed bonus 
export var fly_speed_rep = 800    # player reflect speed bonus
var fly_speed                     # final speed
var fly_type = 0                  # fly type - 0: normal, 1: trail
export var fly_type_trp = 20      # fly trail type percentage
var reflected = 0                 # number of times fly got reflected
var reflect_timer = 0.8           # how long of a grace period should be
var direction_ran                 # randomise direction left or right
var direction_cur                 # randomise how hard its "drifting"
var direction                     # direction its headed to 

func _ready():
	randomize()
	# set start position
	self.position = find_parent("Playground").get_node("EnemySpawn/EnemySpawnLocation").position
	
	# set rotation
	direction = find_parent("Playground").get_node("EnemySpawn/EnemySpawnLocation").rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	# randomize direction
	direction_ran = rand_range(0, 1)
	direction_cur = rand_range(180, 1080)
	
	# set speed range
	var factor = Global.score / fly_speed_sco
	if factor > 1:
		factor = 1
	fly_speed = fly_speed_min + ((fly_speed_max - fly_speed_min) * factor)
	fly_speed = rand_range(fly_speed - (fly_speed_ran / 2), fly_speed + (fly_speed_ran / 2))
	
	# set fly type
	var fly_type_ran = 0   # fly randomise type
	fly_type_ran = rand_range(0, 100)
	if fly_type_ran < (fly_type_trp * factor):
		fly_type = 1  # trail
		$Sprite.animation = "trail"
		$TrailTimer.start()
		$Reflect.set_collision_mask_bit(2, false)
		$Reflect.set_collision_layer_bit(2, false)
		if fly_speed < 450:
			fly_speed = 450
	else:
		fly_type = 0  # normal
		$Sprite.animation = "normal"


func _physics_process(delta):
	move_and_collide(Vector2(fly_speed, 0).rotated(direction) * delta)
	if fly_type == 0:
		if direction_ran > 0.5:
			direction += PI / direction_cur
		else:
			direction -= PI / direction_cur
	self.rotation = direction


func _on_Reflect_body_entered(body): # Reflect shit
	if body != self && $ReflectTimer.time_left < (reflect_timer - 0.15) && reflected < 4:
		if fly_type == 0:
			self.direction += PI
		else:
			self.direction += PI / 2
		self.rotation = self.direction
		$ReflectTimer.wait_time = reflect_timer
		$ReflectTimer.start()
		reflected += 1
		
		if body.get_name() == "ReflectArea":
			set_collision_layer_bit(1, false)
			$ReflectBlinkTimer.start()
			
			fly_speed += fly_speed_rep
			Global.stat_refl += 1  # arrows reflected this round
			var scoreplus_instance = scoreplus_scene.instance()
			scoreplus_instance.position = self.position
			find_parent("Playground").add_child(scoreplus_instance)
			get_tree().get_current_scene().get_node("Playground/Player").player_speed += 10
			get_tree().get_current_scene().get_node("Music/FX_Reflect").play()
		else:
			fly_speed += fly_speed_ref
			get_tree().get_current_scene().get_node("Music/FX_ReflectNonP").play()
			yield(get_tree().create_timer(0.1), "timeout")
			self.hide()
			yield(get_tree().create_timer(0.1), "timeout")
			self.show()
	
	_mirror_direction()

func _on_ReflectTimer_timeout():
	set_collision_layer_bit(1, true)
	$ReflectBlinkTimer.stop()
	self.show()

func _mirror_direction(): # mirrors direction
	if direction_ran > 0.5: 
		direction_ran = 0
	else:
		direction_ran = 1

func _on_TrailTimer_timeout():
	var trail_instance = trail_scene.instance()
	trail_instance.position = self.position
	trail_instance.rotation = self.rotation
	find_parent("Playground").add_child(trail_instance)
	get_tree().get_current_scene().get_node("Music/FX_Trail").play()


func _GameOver_score(): # Dead stuff
	var scoreplus_instance = scoreplus_scene.instance()
	scoreplus_instance.position = self.position
	find_parent("Playground").add_child(scoreplus_instance)
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_ReflectBlinkTimer_timeout():
	if self.visible == true:
		self.hide()
		$ReflectBlinkTimer.wait_time = 0.1
	else:
		self.show()
		$ReflectBlinkTimer.wait_time = 0.2
	$ReflectBlinkTimer.start()
