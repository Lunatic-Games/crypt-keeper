extends Node2D

export (float) var damage
export (float) var speed

var max_distance
var distance_travelled = 0
var direction

onready var fade = $Fade

func _physics_process(delta):
	move_in_direction(delta)

func move_in_direction(delta):
	assert (direction)
	
	global_position += direction * speed * delta
	distance_travelled += speed * delta
	
	if distance_travelled >= max_distance:
		finish_attack()


func finish_attack():
	fade.play("out")
	yield(fade, "animation_finished")
	call_deferred("free")


func attack_hit():
	call_deferred("free")


func _on_Area2D_body_entered(body):
	if body.is_in_group("order"):
		body.take_damage(damage)
		attack_hit()
