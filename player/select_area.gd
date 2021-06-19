extends Area2D

const MIN_SIZE = 5.0
const MAX_SIZE = 100.0
const INCREASE_SPEED = 40.0

var radius = MIN_SIZE


func _draw():
	draw_circle(Vector2(0, 0), radius, Color(1.0, 1.0, 1.0, 0.2))
	draw_arc(Vector2(0, 0), radius, 0, 2*PI, 400, Color(1.0, 1.0, 1.0), 2.0)


func increase(delta):
	radius = min(radius + INCREASE_SPEED * delta, MAX_SIZE)
	$CollisionShape2D.shape.radius = radius
	update()


func reset():
	radius = MIN_SIZE
