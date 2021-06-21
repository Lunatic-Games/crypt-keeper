extends Node2D

var price = 5

onready var popup = $Popup
onready var animation_player = $AnimationPlayer

func _ready():
	popup.get_node("Label").text = str(price)


func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		animation_player.play("popin")


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		animation_player.play("popout")


