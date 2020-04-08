extends Control


var user

var is_mouse_entered = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect_and_detect($Rect.connect("mouse_entered", self, "_on_mouse_entered"))
	Global.connect_and_detect($Rect.connect("mouse_exited", self, "_on_mouse_exited"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered():
	is_mouse_entered = true
	pass

func _on_mouse_exited():
	if is_mouse_entered:
		queue_free()

func set_text(_text):
	$Info.bbcode_text = _text

func judge_free():
	yield(get_tree(), "idle_frame")
	if !is_mouse_entered:
		queue_free()
