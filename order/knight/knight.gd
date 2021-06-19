extends KinematicBody2D


var goal_target = get_tree().get_nodes_in_group("player")[0]


onready var detection_range = $DetectionRange


func _physics_process(delta):
	
	# Check if an "ally" is in the detection range
	var all_chaos = get_detected_chaos()



# Gets all "allies" in the detection range
func get_detected_chaos():
	return detection_range.get_overlapping_bodies()
