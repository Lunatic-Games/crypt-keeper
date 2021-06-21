extends Area2D

const MIN_RADIUS = 5.0
const MAX_RADIUS = 100.0
const INCREASE_SPEED = 70.0
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


func instant_select():
	radius = MAX_RADIUS
	$CollisionShape2D.shape.radius = radius
	
	return select_chaos_units()


func reset():
	radius = MIN_RADIUS


func select_chaos_units():
	var bodies = get_overlapping_bodies()
	var selected_units = []
	
	for body in bodies:
		if body.is_in_group("chaos") && ! body.is_selected:
			body.selected()
			selected_units.push_back(body)
	
	return selected_units
