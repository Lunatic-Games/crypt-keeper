extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("enter")
	var _silenced = $AnimationPlayer.connect("animation_finished", self, "remove")


func remove(_animation):
	call_deferred("free")
