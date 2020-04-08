extends Spatial

signal BaseBuildCube_changed

signal BaseBuildCube_attach_point_changed

enum BUILD_MODE{
	ATTACH
	ERASE
	ROTATE
	SWITCH
}

var TargetBuildCube : PackedScene

var BuildCube : Spatial
var BuildCube_attach_point_index
var BuildCube_rotate_index

var BaseBuildCube : Spatial
var BaseBuildCube_attach_point

var build_mode = BUILD_MODE.ATTACH

var BuildCubes := {}#{location：BuildCube}

onready var Ray = $BuildCubeRay
# Called when the node enters the scene tree for the first time.
func _ready():
	#OS.window_size = Vector2(1920, 1080)
	Global.connect_and_detect($BuildInterfaceGUI.connect("changed_BuildTarget", self, "_on_changed_BuildTarget"))
	#yield(get_tree(), "idle_frame")
	#update_all_BuildCubes_connection()
	Global.connect_and_detect($BuildCubes/BuildCube_TestCore.connect("mouse_in", self, "_on_BuildCubes_mouse_in"))
	Global.connect_and_detect($BuildCubes/BuildCube_TestCore.connect("mouse_out", self, "_on_BuildCubes_mouse_out"))
	$BuildCubes/BuildCube_TestCore.build()
	Ray.enabled = true
	
	Global.connect_and_detect(connect("BaseBuildCube_attach_point_changed", self, "_on_BaseBuildCube_attach_point_changed"))
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_pressed("key_1"):
		build_mode = BUILD_MODE.ATTACH
	if event.is_action_pressed("key_2"):
		build_mode = BUILD_MODE.ERASE
	if event.is_action_pressed("key_3"):
		build_mode = BUILD_MODE.ROTATE
	if event.is_action_pressed("key_4"):
		build_mode = BUILD_MODE.SWITCH
	
	if event.is_action_pressed("left_mouse_button"):
		match build_mode:
			BUILD_MODE.ATTACH:
				if is_instance_valid(BuildCube) and is_instance_valid(BaseBuildCube):
					BuildCube.build()
					Global.connect_and_detect(BuildCube.connect("mouse_in", self, "_on_BuildCubes_mouse_in"))
					Global.connect_and_detect(BuildCube.connect("mouse_out", self, "_on_BuildCubes_mouse_out"))
					if TargetBuildCube != null:
						BuildCube = TargetBuildCube.instance()
						$BuildCubes.add_child(BuildCube)
						BuildCube.visible = false
			BUILD_MODE.ERASE:
				if is_instance_valid(BaseBuildCube):
					BaseBuildCube.queue_free()
			BUILD_MODE.ROTATE:
				if is_instance_valid(BaseBuildCube):
					BaseBuildCube.update_transform(BaseBuildCube.build_attach_point_index,
										   BaseBuildCube_attach_point,
										   BaseBuildCube.build_attach_rotate_index + 1)
			BUILD_MODE.SWITCH:
				if is_instance_valid(BaseBuildCube):
					BaseBuildCube.update_transform(BaseBuildCube.build_attach_point_index + 1,
										   BaseBuildCube_attach_point,
										   BaseBuildCube.build_attach_rotate_index)
	
	if event.is_action_pressed("key_e"):
		if is_instance_valid(BuildCube) and is_instance_valid(BaseBuildCube):
			if BuildCube.visible and BaseBuildCube_attach_point != null:
				BuildCube.update_transform(BuildCube.build_attach_point_index + 1,
										   BaseBuildCube_attach_point,
										   BuildCube.build_attach_rotate_index)
	if event.is_action_pressed("key_q"):
		if is_instance_valid(BuildCube) and is_instance_valid(BaseBuildCube):
			if BuildCube.visible and BaseBuildCube_attach_point != null:
				BuildCube.update_transform(BuildCube.build_attach_point_index,
										   BaseBuildCube_attach_point,
										   BuildCube.build_attach_rotate_index + 1)
	
	if event is InputEventMouse:
		update_BuildCubeRay(event, $Camera)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_BaseBuildCube_attach_point()
	update_BuildCube()
	pass

func update_all_BuildCubes_connection():
	for i in get_tree().get_nodes_in_group("BuildCubes"):
		if !i.is_connected("mouse_in", self, "_on_BuildCubes_mouse_in"):
			Global.connect_and_detect(i.connect("mouse_in", self, "_on_BuildCubes_mouse_in"))
		if !i.is_connected("mouse_out", self, "_on_BuildCubes_mouse_out"):
			Global.connect_and_detect(i.connect("mouse_out", self, "_on_BuildCubes_mouse_out"))

func _on_BuildCubes_mouse_in(_Cube):
	BaseBuildCube = _Cube
	emit_signal("BaseBuildCube_changed")

func _on_BuildCubes_mouse_out(_Cube):
	if BaseBuildCube == _Cube:
		BaseBuildCube = null
		BaseBuildCube_attach_point = null
		emit_signal("BaseBuildCube_changed")

func update_BaseBuildCube_attach_point():
	if !is_instance_valid(BaseBuildCube):
		return
	#yield(get_tree(), "idle_frame")
	var pos
	#Ray.force_update_transform()
	Ray.clear_exceptions()
	Ray.force_raycast_update()
	if !Ray.is_colliding():
		print("error:update_BuildCubeRay|1")
		return false
	while true:
		#print(Ray.get_collider())
		if !Ray.is_colliding():
			print("error:update_BuildCubeRay|2")
			return false
		var _target = Ray.get_collider()
		if _target != BaseBuildCube.area:
			Ray.add_exception(_target)
		else:
			pos = Ray.get_collision_point()
			break
		Ray.force_raycast_update()
	var _BaseBuildCube_attach_point = BaseBuildCube.get_attach_point(pos)
	#print(BaseBuildCube_attach_point)
	$Area.global_transform = _BaseBuildCube_attach_point.global_transform
	if BaseBuildCube_attach_point != _BaseBuildCube_attach_point:
		print("_???_")
		BaseBuildCube_attach_point = _BaseBuildCube_attach_point
		emit_signal("BaseBuildCube_attach_point_changed")

func update_BuildCube():
	if is_instance_valid(BaseBuildCube):
		if is_instance_valid(BuildCube):
			BuildCube.visible = true
			#BuildCube.update_transform(BuildCube.build_attach_point_index, )
	elif is_instance_valid(BuildCube):
		BuildCube.visible = false

func update_BuildCubeRay(event : InputEventMouse, camera : Camera = get_viewport().get_camera()):
	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * 1000
	$BuildCubeRay.global_transform.origin = from
	$BuildCubeRay.cast_to = to
	#print($BuildCubeRay.get_collision_point())

#添加方块
func attach_cube(_attach_array, _TargetCube):
	pass

#移除方块
func erase_cube(cube : Spatial):
	if BuildCubes.has(cube.location):
		BuildCubes.erase(cube.location)
	cube.smooth_change_LightBuild_energy(0, 0.15, true)
	pass

func raycast(event : InputEventMouse, camera : Camera = get_viewport().get_camera()) -> Dictionary:
	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * 1000
	return camera.get_world().direct_space_state.intersect_ray(from, to)

func _on_BaseBuildCube_attach_point_changed():
	if is_instance_valid(BuildCube):
		BuildCube.update_transform( BuildCube.build_attach_point_index,
									BaseBuildCube_attach_point,
									BuildCube.build_attach_rotate_index)

func _on_changed_BuildTarget(new_BuildTarget):
	if is_instance_valid(BuildCube):
		BuildCube.queue_free()
	TargetBuildCube = new_BuildTarget
	BuildCube = TargetBuildCube.instance()
	$BuildCubes.add_child(BuildCube)
	BuildCube.visible = false
