extends Node2D


export (Array, Resource) var waves

signal wave_cleared

const DELAY_BETWEEN_WAVES = 1.0
const DELAY_BETWEEN_GROUPS = 5.0
const DELAY_BETWEEN_ENEMIES = 0.5

var spawners = []
var current_wave: Resource
var wave_n = 1


func _ready():
	randomize()
	spawners = $Spawners.get_children()
	update_wave_hud()
	spawn_waves()
	


func spawn_waves():
	yield(get_tree().create_timer(DELAY_BETWEEN_WAVES), "timeout")
	while waves:
		current_wave = waves.pop_front()
		current_wave.create_queue()
		yield(spawn_current_wave(), "completed")
		yield(self, "wave_cleared")
		if get_tree():
			yield(get_tree().create_timer(DELAY_BETWEEN_WAVES), "timeout")
		if waves:
			wave_n += 1
			update_wave_hud()


func spawn_current_wave():
	while current_wave.unit_queue:
		var enemies = current_wave.get_next_in_queue()
		var spawner = spawners[randi() % spawners.size()]
		yield(spawn_group(enemies, spawner), "completed")
		if get_tree():
			yield(get_tree().create_timer(DELAY_BETWEEN_GROUPS), "timeout")


func spawn_group(group, spawner):
	for enemy in group:
		add_child(enemy)
		enemy.connect("tree_exited", self, "check_enemies_cleared")
		enemy.global_position = spawner.global_position
		if get_tree():
			yield(get_tree().create_timer(DELAY_BETWEEN_ENEMIES), "timeout")


func update_wave_hud():
	$HUD/Wave.text = "Wave-" + str(wave_n)


func check_enemies_cleared():
	if $Enemies.get_child_count() == 0:
		emit_signal("wave_cleared")
