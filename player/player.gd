extends KinematicBody2D

const MAX_SPEED = 150
const ACCELERATION_WEIGHT = 0.5
const pressed_interval = 0.1


var velocity: Vector2
var press_count = 0
var time_held = 0
var coyote_hold = 0.2
var performing_action = ""
var selected_units = []
var command_flag = preload("res://player/command_flag.tscn")
var hit_particle = preload("res://particle/hit_particle/hit_particle.tscn")

var max_health = 10
var health = max_health


onready var health_bar = $HealthBar
onready var pressed_timer = $PressedTimer
onready var white_blink = $WhiteBlink


func _physics_process(delta):
	handle_select(delta)
	
	var movement = Vector2()
	if Input.is_action_pressed("move_up"):
		movement.y -= 1
	if Input.is_action_pressed("move_right"):
		movement.x += 1
	if Input.is_action_pressed("move_down"):
		movement.y += 1
	if Input.is_action_pressed("move_left"):
		movement.x -= 1
	
	var target_velocity = movement.normalized() * MAX_SPEED
	velocity.x = lerp(velocity.x, target_velocity.x, ACCELERATION_WEIGHT)
	velocity.y = lerp(velocity.y, target_velocity.y, ACCELERATION_WEIGHT)
		
	velocity =  move_and_slide(velocity)


func handle_select(delta):
	# Handle if an action is pressed or held
	if (Input.is_action_just_pressed("select")):
		performing_action = "pressed"
		pressed_timer.start(pressed_interval)
	
	# Take the release action
	if (Input.is_action_just_released("select")):
		take_action()
	
	# Increase circle if held
	if performing_action == "held":
		time_held += delta
		$SelectArea.visible = true
		$SelectArea.increase(delta)


func take_action():
	if performing_action == "held":
		var new_selections = $SelectArea.select_chaos_units()
		selected_units += new_selections
		$SelectArea.visible = false
		$SelectArea.reset()
		if (new_selections.size() == 0 && time_held <= pressed_interval + coyote_hold):
			performing_action = "pressed"
		time_held = 0
	
	if performing_action == "pressed":
		if selected_units.size() >= 1:
			command_selected_to_hold()
		else:
			selected_units = $SelectArea.instant_select()
			$SelectArea.reset()
			command_selected_to_hold()
	
	performing_action = ""

func command_selected_to_hold():
	var flag = command_flag.instance()
	flag.global_position = global_position
	get_tree().get_root().add_child(flag)
	
	for unit in selected_units:
		if (unit && is_instance_valid(unit)):
			unit.command_hold(global_position, selected_units.size())
	
	selected_units = []


func _on_PressedTimer_timeout():
	if performing_action == "pressed":
		performing_action = "held"


func take_damage(damage):
	var unit = self
	
	white_blink.play("normal")
	health -= damage
	var hit_particles = hit_particle.instance()
	hit_particles.global_position = global_position
	get_tree().get_root().add_child(hit_particles)
	if (health <= 0):
		unit = null
		die()
	else:
		health_bar.update_health(health, max_health)
	
	return unit


func die():
	call_deferred('free')
