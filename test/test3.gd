extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var Tween1 = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	yield(get_tree().create_timer(2), "timeout")
	$a1.global_transform.basis.y = -$a1.global_transform.basis.y
	#print($a1.global_transform.basis.x)
	#$a1.global_transform.basis = $a1.global_transform.basis.rotated($a1.global_transform.basis.x, 0.5)
	#Tween1.interpolate_property($a1, "global_transform/basis/y", $a1.global_transform.basis.y, Vector3(1, 0, 0), 3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	#Tween1.start()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($a1.global_transform.basis.y)
	pass
