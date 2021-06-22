extends KinematicBody2D

# Stats
export (float) var preferred_focus_distance = 12
export (bool) var closes_distance = true
export (float) var attack_speed = 2
export (float) var attack_damage = 1
export (float) var max_health = 1
export (float) var move_speed = 50
# Other
var focus
var _silenced
var hit_particle = preload("res://particle/hit_particle/hit_particle.tscn")
var whiten_material = preload("res://shaders/whiten.tres")

onready var health = max_health
onready var detection_range = $DetectionRange
onready var ally_avoidance_area = $AllyAvoidanceArea
onready var attack_timer = $AttackTimer
onready var attack_animation = $AttackAnimation
onready var white_blink = $WhiteBlink
onready var attack_tween = $AttackTween
onready var sprite = $Sprite
onready var health_bar = $HealthBar


signal hit_frame

func make_material_unique():
	sprite.material = whiten_material.duplicate()

func is_focus_detected():
	if (focus && is_instance_valid(focus)):
		return detection_range.overlaps_body(focus)
	else:
		return null


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


func attack_tween_at_focus():
	if (focus):
		var direction = global_position.direction_to(focus.global_position)
		var distance = global_position.distance_to(focus.global_position)
		
		attack_tween.interpolate_property($Sprite, "position", 
											Vector2(0,0), direction * distance, 0.12, 
											Tween.TRANS_ELASTIC, Tween.EASE_IN)
		attack_tween.interpolate_property($Sprite, "position", 
											direction * distance, Vector2(0,0), 0.12, 
											Tween.TRANS_EXPO, Tween.EASE_OUT)
		attack_tween.start()


func draw_focus_line():
	if (focus):
		var target = global_position.direction_to(focus.global_position) * global_position.distance_to(focus.global_position)
		draw_line(Vector2(0,0), target, Color(0.8, 0.3, 0, 0.2), 1.6)
	else:
		pass


func take_damage(damage):
	var unit = self
	
	white_blink.play("normal")
	health -= damage
	var hit_particles = hit_particle.instance()
	hit_particles.global_position = global_position
	get_tree().get_root().add_child(hit_particles)
	if (health <= 0):
		unit = null
		die()
	else:
		health_bar.update_health(health, max_health)
	
	return unit


func die():
	call_deferred('free')


func hit_signal():
	emit_signal("hit_frame")
