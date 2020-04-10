extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Tween1 = $Tween
# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rect_position += Vector2(0, -5)
	pass

func start(_text : String, _color : Color, _pos : Vector2, _time : float):
	text = _text
	modulate = _color
	rect_position = _pos + Vector2(rand_range(-40, 40), rand_range(-40, 40))
	yield(get_tree().create_timer(_time/2), "timeout")
	set_process(true)
	Tween1.interpolate_property(self, "modulate", modulate, Color(modulate.r, modulate.g, modulate.b, 0), _time/2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tween1.start()
	yield(Tween1, "tween_completed")
	queue_free()
