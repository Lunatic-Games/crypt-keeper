extends ProgressBar

var fade_delay_time = 1

onready var health_tween = $HealthTween
onready var fade = $Fade
onready var fade_delay = $FadeDelay

var showing = false

func update_health(current_health, max_health):
	if ! showing:
		fade.play("in")
	
	yield(fade, "animation_finished")
	fade_delay.start(fade_delay_time)
	var goal_value = (current_health / max_health) * 100
	value = goal_value



func _on_FadeDelay_timeout():
	if fade.current_animation == "":
		fade.play("out")
	else:
		fade_delay.start(fade_delay_time)
