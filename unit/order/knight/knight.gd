extends KinematicBody2D

onready var attack_animation = $AttackAnimation
onready var goal_target = Autovars.player

func _physics_process(delta):
	
	# If you already have a focus
	if (focus):
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
			get_new_focus()
			
			# target the new focus
			if focus:
				handle_focus()
			# No focus could be found, target the goal_target
			else:
				move_towards_goal()

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
	if focus && is_focus_detected():
		attack_animation.play("attack")
		yield(attack_animation, "animation_finished")
		focus = focus.take_damage(attack_damage)