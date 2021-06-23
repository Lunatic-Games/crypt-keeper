extends "res://unit/order/order_unit.gd"

onready var goal_target = Autovars.player

func _ready():
	make_material_unique()

func _process(_delta):
	update()

func _physics_process(_delta):
	
	# If you do not have focus, try and get it
	if !focus:
		get_new_focus()
	
	if focus && !is_focus_detected():
		get_new_focus()
	
	
	# If have a focus
	if (focus):
		handle_focus()
	else:
		move_towards_goal()


func _draw():
	draw_focus_line()

# Overwritten per scene
func handle_focus():
	# If the focus is within the preferred range
	if focus_in_preferred_range():
		# Ready an attack
		if attack_timer.is_stopped():
			attack_timer.start(attack_speed)
		pass
	else:
		# Move to correct the preferred focus
		move_to_preferred_focus_distance()


func move_to_preferred_focus_distance():
	
	if (closes_distance):
		direction = position.direction_to(focus.position) # var
		direction += calculate_avoidance_direction_offset()
		direction = direction.normalized()
		_silenced = move_and_slide(direction * move_speed)
	else:
		direction = - position.direction_to(focus.position) # var
		_silenced = move_and_slide(direction * move_speed)


func move_towards_goal():
	if (goal_target && is_instance_valid(goal_target)):
		direction = position.direction_to(goal_target.position)
		direction += calculate_avoidance_direction_offset()
		direction = direction.normalized()
		_silenced =  move_and_slide(direction * move_speed)


func calculate_avoidance_direction_offset():
	var bodies = ally_avoidance_area.get_overlapping_bodies()
	var allies_in_direction = []
	for body in bodies:
		var ally_direction = global_position.direction_to(body.global_position)
		if body.is_in_group("order") && ally_direction.dot(direction) > 0 && body != self:
			allies_in_direction.push_back(body)
	
	if (allies_in_direction.size() == 0):
		return Vector2(0,0)
	else:
		# Direction rotated 90 degrees
		return Vector2(direction.y, -direction.x)
	

func _on_AttackTimer_timeout():
	# if the focus is in range, do damage
	if focus && is_focus_detected()  && is_focus_in_range():
		attack_tween_at_focus()
		attack_animation.play("attack")
		yield(self, "hit_frame")
		if (focus):
			focus = focus.take_damage(attack_damage)
