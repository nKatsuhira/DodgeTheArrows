extends KinematicBody2D

signal hit

export var player_speed = 500
export var player_speed_dash = 1500
export var dash_cooldown = 3.0
var player_dash_ready = true
var player_dash_dir = Vector2()
var game_over = false
var screen_size

func _ready():
	screen_size = get_viewport_rect().size
	player_dash_ready = false
	$AnimatedSprite.animation = "reload"
	$AnimatedSprite.set_frame(0)
	$DashCooldown.wait_time = (dash_cooldown - 0.3) / 2
	$DashCooldown.start()

func _process(delta):
	if game_over == false:
		# Get Input
		var velocity = Vector2()
		if Input.is_action_pressed("Up"):
			velocity.y -= 1
			rotation = velocity.angle()
		if Input.is_action_pressed("Down"):
			velocity.y += 1
			rotation = velocity.angle()
		if Input.is_action_pressed("Left"):
			velocity.x -= 1
			rotation = velocity.angle()
		if Input.is_action_pressed("Right"):
			velocity.x += 1
			rotation = velocity.angle()
		
		if velocity != Vector2(0, 0) && $DashTime.time_left == 0:
			player_dash_dir = velocity
		
		# Dash
		if Input.is_action_pressed("Dash") && player_dash_ready == true:
			$DashCooldown.start()
			$DashTime.start()
			$ReflectArea/Reflectbox.disabled = false
			$HitArea/Hitbox.disabled = true
			
			get_tree().get_current_scene().get_node("Music/FX_Dash").play()
			
			$AnimationPlayer.play("Reflect")
			$AnimatedSprite.play()
			$AnimatedSprite.animation = "dash"
			$DashReflectAnimatedSprite.set_frame(0)
			$DashReflectAnimatedSprite.play()
			
			Global.stat_dash += 1
			player_dash_ready = false
		
		# Movement
		if $DashTime.time_left > 0:
			var factor = (1 * $DashTime.time_left) / $DashTime.wait_time
			if factor > 1:
				factor = 1
			
			velocity = velocity.normalized() * player_speed
			player_dash_dir = player_dash_dir.normalized() * player_speed_dash * factor
			move_and_collide((player_dash_dir + velocity) * delta)
		else:
			velocity = velocity.normalized() * player_speed  # Normalize velocity
			move_and_collide(velocity * delta)
		
		# Keep in player in window
		position.x = clamp(position.x, 0, screen_size.x)
		position.y = clamp(position.y, 0, screen_size.y)

func _on_DashCooldown_timeout():
	if game_over == false:
		$DashCooldown.stop()
		$AnimatedSprite.play()
		$DashCooldown.wait_time = dash_cooldown - 0.3
		yield(get_tree().create_timer(0.1), "timeout")
		get_tree().get_current_scene().get_node("Music/FX_DashReload").play()

func _on_DashTime_timeout():
	$DashTime.stop()
	$ReflectArea/Reflectbox.disabled = true
	yield(get_tree().create_timer(0.2), "timeout")
	$HitArea/Hitbox.disabled = false

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "dash":
		$AnimatedSprite.stop()
		$AnimatedSprite.animation = "reload"
		$AnimatedSprite.set_frame(0)
	else:
		player_dash_ready = true
		$AnimatedSprite.stop()
		$AnimatedSprite.animation = "still"


func _on_Hitbox_body_entered(_body):
	if game_over == false:
		emit_signal("hit")
		$HitArea/Hitbox.set_deferred("disabled", true)
		get_tree().get_current_scene().get_node(".")._Game_Over()
		yield(get_tree().create_timer(0.1), "timeout")
		$AnimatedSprite.animation = "death"
		$AnimatedSprite.play()
	game_over = true
