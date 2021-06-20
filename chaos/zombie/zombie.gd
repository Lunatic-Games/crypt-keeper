extends KinematicBody2D

const SPEED = 100

var health = 2


func take_damage(damage):
	health -= damage
	if (health <= 0):
		die()


func die():
	call_deferred('free')
