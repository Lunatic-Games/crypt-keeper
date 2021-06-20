extends KinematicBody2D

const MAX_SPEED = 150
const ACCELERATION_WEIGHT = 0.5


var velocity: Vector2


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
	if Input.is_action_pressed("select"):
		$SelectArea.visible = true
		$SelectArea.increase(delta)
	if Input.is_action_just_released("select"):
		$SelectArea.select_chaos_units()
		$SelectArea.visible = false
		$SelectArea.reset()
