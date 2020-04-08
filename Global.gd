extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func connect_and_detect(return_value):
	if return_value != 0:
		print("wrong connection", return_value)
		return false
	return true
	pass
