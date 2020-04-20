extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var count = 0
	#for i in get_children():
	#	if i.is_connected_with_core:
	#		count += 1
	#print(count)
	pass

func update_cubes_connecting_core(from_cube : Spatial):
	if from_cube.has_method("core"):
		return
	var scanned_cubes := [from_cube]
	var new_scanned_cubes := [from_cube]
	var scanned_core = false
	from_cube.is_connected_with_core = false
	while true:
		var new_add_count = 0
		var scanned_cubes_this_loop := []
		for i in new_scanned_cubes:
			if !is_instance_valid(i): continue
			for j in i.attached_cubes.values():
				if !is_instance_valid(j): continue
				if j.has_method("core"):
					scanned_core = true
					break
				if !scanned_cubes.has(j):
					j.is_connected_with_core = false
					scanned_cubes.append(j)
					scanned_cubes_this_loop.append(j)
					new_add_count += 1
		if new_add_count == 0:
			break
		new_scanned_cubes = scanned_cubes_this_loop
	if scanned_core:
		for i in scanned_cubes:
			i.set_connection_with_core(true)
	else:
		for i in scanned_cubes:
			i.set_connection_with_core(false)
	pass
