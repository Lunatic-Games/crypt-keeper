extends "res://unit/base_unit.gd"

export (float) var follow_range = 30


var is_selected = false
var holding
var units_in_hold
var reached_hold = false

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
	is_selected = true
	holding = null
	units_in_hold = 0

func command_hold(hold_pos, number_of_units):
	is_selected = false
	holding = hold_pos
	units_in_hold = number_of_units
	reached_hold = false
