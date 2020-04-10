extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.visible_characters = 0
	yield(get_tree().create_timer(2), "timeout")
	while true:
		$Label.visible_characters += 1
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		#yield(get_tree(), "idle_frame")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

#	pass
