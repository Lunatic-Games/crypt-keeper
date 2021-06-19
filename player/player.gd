extends KinematicBody2D

const SPEED = 150


func _physics_process(_delta):
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
		
	var _ret =  move_and_slide(movement)
