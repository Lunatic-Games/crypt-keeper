extends Node2D


export (Resource) var current_wave

const ENEMY_INDIVIDUAL_SPAWN_DELAY = 0.25
const START_SPAWN_DELAY = 1.0

var spawners = []


func _ready():
	randomize()
	spawners = $Spawners.get_children()
	spawn_waves()


func spawn_waves():
	current_wave.create_queue()
	yield(get_tree().create_timer(START_SPAWN_DELAY), "timeout")
	while current_wave.unit_queue:
		var enemies = current_wave.get_next_in_queue()
		var spawner = spawners[randi() % spawners.size()]
		for enemy in enemies:
			add_child(enemy)
			enemy.global_position = spawner.global_position
			yield(get_tree().create_timer(ENEMY_INDIVIDUAL_SPAWN_DELAY), "timeout")
		yield(get_tree().create_timer(current_wave.time_between_groups), "timeout")
	
