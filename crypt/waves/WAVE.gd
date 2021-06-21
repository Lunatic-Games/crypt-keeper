extends Resource

export (int, 0, 999) var knights
export (int) var min_group_size = 2
export (int) var max_group_size = 4
export (float) var time_between_groups = 1.0

const UNITS = {
	"knights": preload("res://unit/order/knight/knight.tscn")
}

var unit_queue = []

func create_queue():
	for unit in UNITS:
		for number in get(unit):
			unit_queue.append(UNITS[unit])

func get_next_in_queue():
	unit_queue.shuffle()
	var number_units = randi() % (max_group_size - min_group_size) + min_group_size
	if unit_queue.size() - number_units < min_group_size:
		number_units = unit_queue.size()
	
	var created_units = []
	for _i in number_units:
		created_units.append(unit_queue.pop_front().instance())
	return created_units
