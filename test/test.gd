extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vec1
var vec2

var time = 0.9
onready var Tween1 = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Tween1)
	#print($BuildCube_Test/Spatial/Spatial/AttachAreas/a0.global_transform.basis.y)
	
	yield(get_tree().create_timer(0.1), "timeout")
	
	#tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a1, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a1)
	#yield(get_tree().create_timer(time), "timeout")
	
	#return
	
	print("a0-a0")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a0, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a0)
	yield(get_tree().create_timer(time), "timeout")
	print("a0-a1")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a0, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a1)
	yield(get_tree().create_timer(time), "timeout")
	print("a0-a2")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a0, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a2)
	yield(get_tree().create_timer(time), "timeout")
	print("a0-a3")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a0, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a3)
	yield(get_tree().create_timer(time), "timeout")
	print("a0-a4")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a0, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a4)
	yield(get_tree().create_timer(time), "timeout")
	print("a0-a5")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a0, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a5)
	
	yield(get_tree().create_timer(time), "timeout")
	print("a1-a0")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a1, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a0)
	yield(get_tree().create_timer(time), "timeout")
	print("a1-a1")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a1, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a1)
	yield(get_tree().create_timer(time), "timeout")
	print("a1-a2")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a1, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a2)
	yield(get_tree().create_timer(time), "timeout")
	print("a1-a3")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a1, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a3)
	yield(get_tree().create_timer(time), "timeout")
	print("a1-a4")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a1, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a4)
	yield(get_tree().create_timer(time), "timeout")
	print("a1-a5")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a1, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a5)
	
	yield(get_tree().create_timer(time), "timeout")
	print("a2-a0")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a2, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a0)
	yield(get_tree().create_timer(time), "timeout")
	print("a2-a1")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a2, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a1)
	yield(get_tree().create_timer(time), "timeout")
	print("a2-a2")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a2, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a2)
	yield(get_tree().create_timer(time), "timeout")
	print("a2-a3")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a2, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a3)
	yield(get_tree().create_timer(time), "timeout")
	print("a2-a4")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a2, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a4)
	yield(get_tree().create_timer(time), "timeout")
	print("a2-a5")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a2, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a5)
	yield(get_tree().create_timer(time), "timeout")
	
	print("a3-a0")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a3, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a0)
	yield(get_tree().create_timer(time), "timeout")
	print("a3-a1")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a3, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a1)
	yield(get_tree().create_timer(time), "timeout")
	print("a3-a2")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a3, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a2)
	yield(get_tree().create_timer(time), "timeout")
	print("a3-a3")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a3, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a3)
	yield(get_tree().create_timer(time), "timeout")
	print("a3-a4")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a3, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a4)
	yield(get_tree().create_timer(time), "timeout")
	print("a3-a5")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a3, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a5)
	yield(get_tree().create_timer(time), "timeout")
	
	print("a4-a0")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a4, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a0)
	yield(get_tree().create_timer(time), "timeout")
	print("a4-a1")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a4, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a1)
	yield(get_tree().create_timer(time), "timeout")
	print("a4-a2")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a4, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a2)
	yield(get_tree().create_timer(time), "timeout")
	print("a4-a3")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a4, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a3)
	yield(get_tree().create_timer(time), "timeout")
	print("a4-a4")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a4, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a4)
	yield(get_tree().create_timer(time), "timeout")
	print("a4-a5")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a4, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a5)
	yield(get_tree().create_timer(time), "timeout")
	
	print("a5-a0")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a5, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a0)
	yield(get_tree().create_timer(time), "timeout")
	print("a5-a1")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a5, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a1)
	yield(get_tree().create_timer(time), "timeout")
	print("a5-a2")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a5, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a2)
	yield(get_tree().create_timer(time), "timeout")
	print("a5-a3")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a5, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a3)
	yield(get_tree().create_timer(time), "timeout")
	print("a5-a4")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a5, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a4)
	yield(get_tree().create_timer(time), "timeout")
	print("a5-a5")
	tras($BuildCube_Test/Spatial/Spatial/AttachAreas/a5, $BuildCube_TestCore/Spatial/Spatial/AttachAreas/a5)
	yield(get_tree().create_timer(time), "timeout")
	
	pass

func tras(a, b):
	#yield(get_tree(), "idle_frame")
	#yield(get_tree(), "idle_frame")
	#orthonormalize()
	#$BuildCube_Test/Spatial/Spatial.orthonormalize()
	#$BuildCube_Test/Spatial.orthonormalize()
	#$BuildCube_Test.orthonormalize()
	$BuildCube_Test.transform = Transform()
	$BuildCube_Test/Spatial.transform = Transform()
	$BuildCube_Test/Spatial/Spatial.transform = Transform()
	yield(get_tree().create_timer(0.1), "timeout")
	
	var t = a.global_transform.basis.transposed()
	$BuildCube_Test/Spatial/Spatial.global_transform.basis = t
	$BuildCube_Test/Spatial/Spatial.force_update_transform()
	yield(get_tree().create_timer(0.1), "timeout")
	#yield(get_tree(), "idle_frame")
	var o = $BuildCube_Test/Spatial.global_transform.origin - a.global_transform.origin
	$BuildCube_Test/Spatial/Spatial.global_translate(o)
	$BuildCube_Test/Spatial/Spatial.force_update_transform()
	yield(get_tree().create_timer(0.1), "timeout")
	#yield(get_tree(), "idle_frame")
	#b.rotate_object_local(b.global_transform.basis.x, PI)
	var tt = b.global_transform.basis.rotated(b.global_transform.basis.x, PI)
	#yield(get_tree(), "idle_frame")
	$BuildCube_Test/Spatial.global_transform.basis = tt
	$BuildCube_Test/Spatial.force_update_transform()
	yield(get_tree().create_timer(0.1), "timeout")
	#yield(get_tree(), "idle_frame")
	var v = b.global_transform.origin - $BuildCube_Test/Spatial.global_transform.origin
	$BuildCube_Test/Spatial.global_translate(v)
	$BuildCube_Test/Spatial.force_update_transform()
	yield(get_tree().create_timer(0.1), "timeout")
	#yield(get_tree(), "idle_frame")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
