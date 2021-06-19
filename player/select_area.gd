extends Area2D

const MIN_RADIUS = 5.0
const MAX_RADIUS = 100.0
const INCREASE_SPEED = 40.0
const CIRCLE_POINT_COUNT = 400
const OUTLINE_WIDTH = 2.0

export (Color) var outline_color
export (Color) var overlay_color

var radius = MIN_RADIUS


func _draw():
	draw_circle(Vector2(), radius, overlay_color)
	draw_arc(Vector2(), radius, 0, 2*PI, CIRCLE_POINT_COUNT, outline_color, OUTLINE_WIDTH)


func increase(delta):
	radius = min(radius + INCREASE_SPEED * delta, MAX_RADIUS)
	$CollisionShape2D.shape.radius = radius
	update()


func reset():
	radius = MIN_RADIUS
