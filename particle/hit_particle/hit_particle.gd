extends Particles2D


func _process(_delta):
	if ! emitting:
		call_deferred("free")

func _ready():
	emitting = true
