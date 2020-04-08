extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var a : Position3D
var b : Position3D

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Spatial.global_transform = Transform()
	#$Spatial/Spatial.global_transform = Transform()
	#yield(get_tree().create_timer(0.5), "timeout")
	a = $Spatial/Spatial/a0
	b = $Spatial2/Spatial/a0
	print("1")
	yield(get_tree().create_timer(0.5), "timeout")
	var t = a.global_transform.basis.transposed()
	$Spatial/Spatial.global_transform.basis = t
	print("2")
	yield(get_tree().create_timer(0.5), "timeout")
	var o = $Spatial.global_transform.origin - a.global_transform.origin
	$Spatial/Spatial.global_translate(o)
	print("3")
	yield(get_tree().create_timer(0.5), "timeout")
	#b.rotate_object_local(b.global_transform.basis.x, PI)
	var tt = b.global_transform.basis.rotated(b.global_transform.basis.x, PI)
	yield(get_tree(), "idle_frame")
	$Spatial.global_transform.basis = tt
	print("4")
	yield(get_tree().create_timer(0.5), "timeout")
	var v = b.global_transform.origin - $Spatial.global_transform.origin
	$Spatial.global_translate(v)
	print("5")
	yield(get_tree().create_timer(0.5), "timeout")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
