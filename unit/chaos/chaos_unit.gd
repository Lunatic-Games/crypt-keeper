extends "res://unit/base_unit.gd"

export (float) var follow_range = 30


var selected = false

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


func selected():
	selected = true
