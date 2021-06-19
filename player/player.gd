extends KinematicBody2D

const SPEED = 150


func _physics_process(delta):
	var movement = Vector2()
	if Input.is_action_pressed("move_up"):
		movement.y -= 1
	if Input.is_action_pressed("move_right"):
		movement.x += 1
	if Input.is_action_pressed("move_down"):
		movement.y += 1
	if Input.is_action_pressed("move_left"):
		movement.x -= 1
	movement = movement.normalized() * SPEED
	
	handle_select(delta)
		
	var _ret =  move_and_slide(movement)


func handle_select(delta):
	if Input.is_action_pressed("select"):
		$SelectArea.visible = true
		$SelectArea.increase(delta)
	if Input.is_action_just_released("select"):
		$SelectArea.visible = false
		$SelectArea.reset()
