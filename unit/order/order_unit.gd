extends "res://unit/base_unit.gd"


# Gets all chaos in the detection range
func get_detected_chaos():
	var chaos = []
	var bodies = detection_range.get_overlapping_bodies()
	
	for body in bodies:
		if body.is_in_group("chaos") or body.is_in_group("player"):
			chaos.push_back(body)
	
	return chaos

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
