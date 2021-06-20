extends KinematicBody2D

const SPEED = 100

var health = 2


func take_damage(damage):
	var unit = self
	health -= damage
	if (health <= 0):
		unit = null
		die()
	
	return unit


func die():
	call_deferred('free')
