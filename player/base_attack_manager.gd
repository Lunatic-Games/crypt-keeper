extends Node2D

export (float) var radius
export (float) var attack_time = 1.8
export (float) var attack_warning_time = 1
export (float) var attack_warning_opacity = 0.1

var base_attack_scene = preload("res://player/basic_attack.tscn")

onready var attack_range_area = $BaseAttackRange
onready var attack_timer = $BaseAttackTimer


func _ready():
	set_attack_radius()
	attack_timer.start(attack_time)

func _process(_delta):
	#update()
	pass

func _draw():
	#draw_range()
	pass


func set_attack_radius():
	attack_range_area.get_node("CollisionShape2D").shape.radius = radius
	

func draw_range():
	var opacity = calculate_ability_opacity()
	var color = Color("b287c7")
	color.a = opacity
	draw_circle(Vector2(0,0), radius, color)


func calculate_ability_opacity():
	if (attack_timer.time_left <= attack_warning_time):
		var ratio = 1 - (attack_timer.time_left / attack_warning_time)
		var opacity = (ratio * attack_warning_opacity)
		return opacity
	else:
		return 0
	


# Gets all order in the detection range
func get_random_detected_order():
	var order = []
	var bodies = attack_range_area.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("order"):
			order.push_back(body)
	
	randomize()
	order.shuffle()
	
	if (order.size() >= 1):
		return order[0]
	else:
		return null


func _on_BaseAttackTimer_timeout():
	var target = get_random_detected_order()
	
	if target:
		var direction = global_position.direction_to(target.global_position)
		var attack = base_attack_scene.instance()
		attack.direction = direction
		attack.global_position = global_position
		attack.max_distance = radius
		get_tree().get_root().add_child(attack)
	else:
		pass
