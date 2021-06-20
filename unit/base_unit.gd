extends KinematicBody2D

# Stats
export (float) var preferred_focus_distance = 12
export (bool) var closes_distance = true
export (float) var attack_speed = 2
export (float) var attack_damage = 1
export (float) var health = 1
export (float) var move_speed = 50
# Other
var focus


onready var detection_range = $DetectionRange
onready var attack_timer = $AttackTimer


func is_focus_detected():
	return detection_range.overlaps_body(focus)


func is_focus_in_range():
	if (position.distance_to(focus.position) <= preferred_focus_distance):
		return true
	else:
		return false


func focus_in_preferred_range():
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


func take_damage(damage):
	var unit = self
	health -= damage
	if (health <= 0):
		unit = null
		die()
	
	return unit


func die():
	call_deferred('free')
