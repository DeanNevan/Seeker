extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_parent().get_parent())
	print(get_node(NodePath("../..")))
	pass # Replace with function body.
