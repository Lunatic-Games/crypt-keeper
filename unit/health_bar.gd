extends ProgressBar

onready var health_tween = $HealthTween


func update_health(current_health, max_health):
	print("UPDATING HEALTH, is now: ", value)
	var goal_value = (current_health / max_health) * 100
	print("GOAL VALUE: ", goal_value)
	value = goal_value
	health_tween.interpolate_property(self, "value", value, goal_value, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	health_tween.start()
