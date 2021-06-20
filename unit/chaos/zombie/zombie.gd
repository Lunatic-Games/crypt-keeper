extends "res://unit/chaos/chaos_unit.gd"


func _ready():
	make_material_unique()


func _physics_process(_delta):
	if (is_selected):
		selected_ai()
	else:
		unselected_ai()


func selected_ai():
	# Move towards player if selected
	if (position.distance_to(Autovars.player.position) > follow_range):
		var direction = position.direction_to(Autovars.player.position)
		_silenced = move_and_slide(direction * move_speed)
	
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
	if position.distance_to(focus.position) > preferred_focus_distance:
		var direction = position.direction_to(focus.position)
		_silenced = move_and_slide(direction * move_speed)
	
	# If focus in range, attack
	if position.distance_to(focus.position) < preferred_focus_distance:
		ready_attack()

func ready_attack():
	# Attack
	if attack_timer.is_stopped():
		attack_timer.start(attack_speed)


func _on_AttackTimer_timeout():
	if focus && is_focus_detected() && is_focus_in_range():
		attack_tween_at_focus()
		attack_animation.play("attack")
		yield(self, "hit_frame")
		if (focus):
			focus = focus.take_damage(attack_damage)

