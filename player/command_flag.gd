extends Node2D

const CIRCLE_POINT_COUNT = 400
const OUTLINE_WIDTH = 4.0

var radius
var opacity = 0

onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	radius = get_tree().get_nodes_in_group("player")[0].get_node("SelectArea").MAX_RADIUS
	$AnimationPlayer.play("enter")
	var _silenced = $AnimationPlayer.connect("animation_finished", self, "remove")
	lerp_opacity()


func _process(_delta):
	update()


func remove(_animation):
	call_deferred("free")

func _draw():
	draw_range()

func draw_range():
	var color = Color("b287c7")
	var outline_color = Color("7b2ca3")
	color.a = opacity
	outline_color.a = opacity * 2
	draw_circle(Vector2(0,0), radius, color)
	draw_arc(Vector2(), radius, 0, 2*PI, CIRCLE_POINT_COUNT, outline_color, OUTLINE_WIDTH)


func lerp_opacity():
	tween.interpolate_property(self, "opacity", 0, 0.05, 0.3, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.interpolate_property(self, "opacity", 0.05, 0, 0.4, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.6)
	tween.start()




