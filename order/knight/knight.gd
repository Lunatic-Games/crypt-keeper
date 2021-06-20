extends KinematicBody2D

# Stats
var preferred_focus_distance = 12
var closes_distance = true
var attack_rate = 2
var attack_damage = 1
var health = 4
var move_speed = 50


onready var detection_range = $DetectionRange
onready var attack_timer = $AttackTimer
onready var attack_animation = $AttackAnimation
onready var goal_target = get_tree().get_nodes_in_group("player")[0]
onready var focus = null

func _physics_process(delta):
	
	# If you already have a focus
	if (focus):
		print("HAS FOCUS: ", focus.get_name())
		# Check if the focus is still in the detection range
		if is_focus_detected():
			handle_focus()
		else:
			get_new_focus()
			
			# target the new focus
			if focus:
				handle_focus()
			# No focus could be found, target the goal_target
			else:
				move_towards_goal()
	# If you do not already have a focus
	else:
			print("HAS NO FOCUS")
			get_new_focus()
			
			# target the new focus
			if focus:
				handle_focus()
			# No focus could be found, target the goal_target
			else:
				move_towards_goal()




# Gets all chaos in the detection range
func get_detected_chaos():
	var chaos = []
	var bodies = detection_range.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("chaos"):
			chaos.push_back(body)
	
	return chaos


func is_focus_detected():
	return detection_range.overlaps_body(focus)


# Overwritten per scene
func handle_focus():
	
	# If the focus is within the preferred range
	if focus_in_preferred():
		# Ready an attack
		if attack_timer.is_stopped():
			attack_timer.start(attack_rate)
		pass
	else:
		# Move to correct the preferred focus
		move_to_preferred_focus_distance()
		

func get_new_focus():
	randomize()
	var chaos = get_detected_chaos()
	chaos.shuffle()
	
	if (chaos && chaos.size() >= 1):
		focus = chaos[0]
		return chaos[0]
	else:
		focus = null
		return null


func focus_in_preferred():
	# If the unit is melee
	if (closes_distance):
		if (position.distance_to(focus.position) > preferred_focus_distance):
			return false
		else:
			return true
	# If the unit is ranged
	else:
		if (position.distance_to(focus.position) < preferred_focus_distance):
			return false
		else:
			return true


func move_to_preferred_focus_distance():
	
	if (closes_distance):
		var direction = position.direction_to(focus.position)
		move_and_slide(direction * move_speed)
	else:
		var direction = - position.direction_to(focus.position)
		move_and_slide(direction * move_speed)


func move_towards_goal():
	var direction = position.direction_to(goal_target.position)
	move_and_slide(direction * move_speed)


func _on_AttackTimer_timeout():
	
	# if the focus is in range, do damage
	if is_focus_detected():
		attack_animation.play("attack")
		yield(attack_animation, "animation_finished")
		focus.take_damage(attack_damage)
		focus = null
