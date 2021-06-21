extends KinematicBody2D

const MAX_SPEED = 150
const ACCELERATION_WEIGHT = 0.5
const pressed_interval = 0.2


var velocity: Vector2
var press_count = 0
var performing_action = ""
var selected_units = []
var command_flag = preload("res://player/command_flag.tscn")

onready var pressed_timer = $PressedTimer


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
		$SelectArea.visible = true
		$SelectArea.increase(delta)


func take_action():
	if performing_action == "held":
		selected_units += $SelectArea.select_chaos_units()
		$SelectArea.visible = false
		$SelectArea.reset()
	
	if performing_action == "pressed":
		if selected_units.size() >= 1:
			command_selected_to_hold()
		else:
			print("Attempt to get units")
	
	performing_action = ""

func command_selected_to_hold():
	var flag = command_flag.instance()
	flag.global_position = global_position
	get_tree().get_root().add_child(flag)
	
	for unit in selected_units:
		unit.command_hold(global_position, selected_units.size())


func _on_PressedTimer_timeout():
	if performing_action == "pressed":
		performing_action = "held"
