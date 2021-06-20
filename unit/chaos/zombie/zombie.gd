extends KinematicBody2D


var move_speed = 20
var health = 2
var attack_speed = 1.2
var attack_damage = 1
var preferred_focus_range = 15
var focus
var selected = false
var follow_range = 30

onready var detection_range = $DetectionRange
onready var attack_timer = $AttackTimer


func _physics_process(delta):
	if (selected):
		selected_ai()
	else:
		unselected_ai()


func take_damage(damage):
	var unit = self
	health -= damage
	if (health <= 0):
		unit = null
		die()
	
	return unit


func die():
	call_deferred('free')


func selected():
	selected = true


func selected_ai():
	# Move towards player if selected
	if (position.distance_to(Autovars.player.position) > follow_range):
		var direction = position.direction_to(Autovars.player.position)
		move_and_slide(direction * move_speed)
	
	if (focus):
		if is_focus_detected():
			ready_attack()
		else:
			get_new_focus()
			if focus:
				ready_attack()
			else:
				# Do nothing
				pass
	else:
		get_new_focus()
		
		if (focus):
			ready_attack()
		else:
			pass


func unselected_ai():
	if (focus):
		if is_focus_detected():
			move_and_attack()
		else:
			get_new_focus()
			if focus:
				move_and_attack()
			else:
				# Do nothing
				pass
	else:
		get_new_focus()
		
		if (focus):
			move_and_attack()
		else:
			pass


func move_and_attack():
	
	# Move towards focus
	if position.distance_to(focus.position) > preferred_focus_range:
		var direction = position.direction_to(focus.position)
		move_and_slide(direction * move_speed)
	
	# If focus in range, attack
	if position.distance_to(focus.position) < preferred_focus_range:
		ready_attack()

func ready_attack():
	# Attack
	if attack_timer.is_stopped():
		attack_timer.start(attack_speed)


func is_focus_detected():
	return detection_range.overlaps_body(focus)


func get_new_focus():
	randomize()
	var order = get_detected_order()
	order.shuffle()
	
	if (order && order.size() >= 1):
		focus = order[0]
		return order[0]
	else:
		focus = null
		return null


# Gets all chaos in the detection range
func get_detected_order():
	var order = []
	var bodies = detection_range.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("order"):
			order.push_back(body)
	
	return order


func _on_AttackTimer_timeout():
	if focus && is_focus_detected() && is_focus_in_range():
		focus = focus.take_damage(attack_damage)


func is_focus_in_range():
	if (position.distance_to(focus.position) <= preferred_focus_range):
		return true
	else:
		return false
