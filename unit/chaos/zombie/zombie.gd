extends "res://unit/chaos/chaos_unit.gd"

var wander_target
var wander_range = 100
var wander_speed = move_speed / 10


onready var wandering = $Wandering

func _ready():
	make_material_unique()


func _physics_process(_delta):
	if (is_selected):
		selected_ai()
	else:
		hold_ai()


func selected_ai():
	if wandering.emitting:
		wandering.emitting = false
		wandering.restart()
	
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


func hold_ai():
	if (! holding):
		holding = position
	
	# If you don't have a focus
	if (!focus):
		get_new_focus()
	
	# If your old focus is no longer detected
	if (focus && !is_focus_detected()):
		get_new_focus()
	
	# Move towards the hold position
	if (! reached_hold):
		move_to_hold_and_attack()
	else:
		# If you have focus of a unit
		if (focus):
			move_and_attack()
		# If there is nothing to get focus of
		else:
			wander()


func move_and_attack():
	if wandering.emitting:
		wandering.emitting = false
	
	# Move towards focus
	if position.distance_to(focus.position) > preferred_focus_distance:
		var direction = position.direction_to(focus.position)
		_silenced = move_and_slide(direction * move_speed)
	
	# If focus in range, attack
	if position.distance_to(focus.position) < preferred_focus_distance:
		ready_attack()

func move_to_hold_and_attack():
	if wandering.emitting:
		wandering.emitting = false
	
	# Move towards hold
	if position.distance_to(holding) > preferred_focus_distance:
		var direction = position.direction_to(holding)
		_silenced = move_and_slide(direction * move_speed)
	else:
		reached_hold = true
	
	# If focus in range, attack
	if (focus && is_focus_in_range()):
		if position.distance_to(focus.position) < preferred_focus_distance:
			ready_attack()


func wander():
	if ! wandering.emitting:
		wandering.emitting = true
	
	if (! wander_target):
		choose_wander_target()
	
	if (position.distance_to(wander_target) <= 5):
		choose_wander_target()
	
	var direction = position.direction_to(wander_target)
	_silenced = move_and_slide(direction * wander_speed)


func choose_wander_target():
	randomize()
	var wander_x = rand_range(-wander_range, wander_range)
	var wander_y = rand_range(-wander_range, wander_range)
	
	wander_target = holding + Vector2(wander_x, wander_y)
	return wander_target

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

