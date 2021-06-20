extends Particles2D


func _process(delta):
	if ! emitting:
		call_deferred("free")

func _ready():
	emitting = true
