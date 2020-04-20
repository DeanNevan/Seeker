extends Spatial

signal BaseBuildCube_changed(BaseBuildCube)

signal BaseBuildCube_attach_point_changed

signal build_mode_changed(target_mode)

signal camera_mode_changed(target_mode)

enum BUILD_MODE{
	ATTACH
	ERASE
	ROTATE
	SWITCH
}

enum CAMERA_MODE{
	FLY
	PRIVOT
}

var TargetBuildCube : PackedScene

var BuildCube : Spatial
var BuildCube_attach_point_index
var BuildCube_rotate_index

var BaseBuildCube : Spatial
var BaseBuildCube_attach_point

var BuildCubeRay_point_position : Vector3

var rotating_circle_visible_cube : Spatial

var build_mode = BUILD_MODE.ATTACH

var camera_mode = CAMERA_MODE.FLY

var BuildCubes := {}#{location：BuildCube}

var rotating_circle = preload("res://Assets/Scenes/SE/RotatingCircle/RotatingCircle.tscn")

var DynamicData = preload("res://Assets/Scenes/GUI/DynamicData/DynamicData.tscn")

onready var PointLight = $PointLight
onready var Ray = $BuildCubeRay
# Called when the node enters the scene tree for the first time.
func _ready():
	#OS.window_size = Vector2(1920, 1080)
	Global.connect_and_detect($BuildInterfaceGUI.connect("changed_BuildTarget", self, "_on_changed_BuildTarget"))
	#yield(get_tree(), "idle_frame")
	#update_all_BuildCubes_connection()
	Global.connect_and_detect($BuildCubes/BuildCube_TestCore.connect("mouse_in", self, "_on_BuildCubes_mouse_in"))
	Global.connect_and_detect($BuildCubes/BuildCube_TestCore.connect("mouse_out", self, "_on_BuildCubes_mouse_out"))
	$BuildCubes/BuildCube_TestCore.attached()
	Ray.enabled = true
	
	#Global.connect_and_detect(connect("BaseBuildCube_changed", self, "_on_BaseBuildCube_changed"))
	Global.connect_and_detect(connect("BaseBuildCube_changed", $BuildInterfaceGUI, "_on_BaseBuildCube_changed"))
	
	Global.connect_and_detect(connect("BaseBuildCube_attach_point_changed", self, "_on_BaseBuildCube_attach_point_changed"))
	
	Global.connect_and_detect(connect("build_mode_changed", $BuildInterfaceGUI, "_on_build_mode_changed"))
	Global.connect_and_detect(connect("build_mode_changed", self, "_on_build_mode_changed"))
	
	Global.connect_and_detect(connect("camera_mode_changed", $BuildInterfaceGUI, "_on_camera_mode_changed"))
	Global.connect_and_detect(connect("camera_mode_changed", self, "_on_camera_mode_changed"))
	
	
	pass # Replace with function body.

func _unhandled_input(event):
	if event.is_action_released("key_ctrl"):
		if $Camera.privot:
			$Camera.set_privot(null)
			camera_mode = CAMERA_MODE.FLY
			emit_signal("camera_mode_changed", CAMERA_MODE.FLY)
	if event.is_action_pressed("key_ctrl"):
		if is_instance_valid(BaseBuildCube):
			$Camera.set_privot(BaseBuildCube.get_node("Spatial"))
			#$Camera.distance = ($Camera.global_transform.origin.distance_to(BaseBuildCube.global_transform.origin))
			$Camera.look_at(BaseBuildCube.get_node("Spatial").global_transform.origin, Vector3.UP)
			camera_mode = CAMERA_MODE.PRIVOT
			emit_signal("camera_mode_changed", CAMERA_MODE.PRIVOT)
	
	if event.is_action_pressed("key_1"):
		build_mode = BUILD_MODE.ATTACH
		if !is_instance_valid(BuildCube) and TargetBuildCube != null:
			BuildCube = TargetBuildCube.instance()
			$BuildCubes.add_child(BuildCube)
			BuildCube.visible = false
		emit_signal("build_mode_changed", BUILD_MODE.ATTACH)
		emit_signal("BaseBuildCube_attach_point_changed")
	if event.is_action_pressed("key_2"):
		build_mode = BUILD_MODE.ERASE
		if is_instance_valid(BuildCube):
			BuildCube.queue_free()
		emit_signal("build_mode_changed", BUILD_MODE.ERASE)
		emit_signal("BaseBuildCube_attach_point_changed")
	if event.is_action_pressed("key_3"):
		build_mode = BUILD_MODE.ROTATE
		if is_instance_valid(BuildCube):
			BuildCube.queue_free()
		emit_signal("build_mode_changed", BUILD_MODE.ROTATE)
		emit_signal("BaseBuildCube_attach_point_changed")
	if event.is_action_pressed("key_4"):
		build_mode = BUILD_MODE.SWITCH
		if is_instance_valid(BuildCube):
			BuildCube.queue_free()
		emit_signal("build_mode_changed", BUILD_MODE.SWITCH)
		emit_signal("BaseBuildCube_attach_point_changed")
	
	if event.is_action_pressed("left_mouse_button"):
		match build_mode:
			BUILD_MODE.ATTACH:
				if is_instance_valid(BuildCube) and is_instance_valid(BaseBuildCube):
					BuildCube.attached()
					Global.connect_and_detect(BuildCube.connect("mouse_in", self, "_on_BuildCubes_mouse_in"))
					Global.connect_and_detect(BuildCube.connect("mouse_out", self, "_on_BuildCubes_mouse_out"))
					if TargetBuildCube != null:
						BuildCube = TargetBuildCube.instance()
						$BuildCubes.add_child(BuildCube)
						BuildCube.visible = false
					
					add_new_DynamicData("添加", Color(randf(),randf(),randf(),1), $BuildInterfaceGUI.get_local_mouse_position(), 0.3)
			BUILD_MODE.ERASE:
				if is_instance_valid(BaseBuildCube):
					BaseBuildCube.erased()
					
					add_new_DynamicData("擦除", Color(randf(),randf(),randf(),1), $BuildInterfaceGUI.get_local_mouse_position(), 0.3)
			BUILD_MODE.ROTATE:
				if is_instance_valid(BaseBuildCube):
					BaseBuildCube.update_transform( BaseBuildCube.build_attach_point_index,
													BaseBuildCube_attach_point,
													BaseBuildCube.build_attach_rotate_index + 1)
					BaseBuildCube.rotated()
					
					add_new_DynamicData("旋转", Color(randf(),randf(),randf(),1), $BuildInterfaceGUI.get_local_mouse_position(), 0.3)
			BUILD_MODE.SWITCH:
				if is_instance_valid(BaseBuildCube):
					BaseBuildCube.update_transform( BaseBuildCube.build_attach_point_index + 1,
													BaseBuildCube_attach_point,
													BaseBuildCube.build_attach_rotate_index)
					BaseBuildCube.switched()
					
					add_new_DynamicData("切换", Color(randf(),randf(),randf(),1), $BuildInterfaceGUI.get_local_mouse_position(), 0.3)
	
	if event.is_action_pressed("key_e"):
		if is_instance_valid(BuildCube) and is_instance_valid(BaseBuildCube):
			if BuildCube.visible and BaseBuildCube_attach_point != null:
				BuildCube.update_transform(BuildCube.build_attach_point_index + 1,
										   BaseBuildCube_attach_point,
										   BuildCube.build_attach_rotate_index)
				add_new_DynamicData("切换", Color(randf(),randf(),randf(),1), $BuildInterfaceGUI.get_local_mouse_position(), 0.3)
	if event.is_action_pressed("key_q"):
		if is_instance_valid(BuildCube) and is_instance_valid(BaseBuildCube):
			if BuildCube.visible and BaseBuildCube_attach_point != null:
				BuildCube.update_transform(BuildCube.build_attach_point_index,
										   BaseBuildCube_attach_point,
										   BuildCube.build_attach_rotate_index + 1)
				add_new_DynamicData("旋转", Color(randf(),randf(),randf(),1), $BuildInterfaceGUI.get_local_mouse_position(), 0.3)
	if event is InputEventMouse:
		#print(BuildCubeRay_point_position)
		update_BuildCubeRay(event, $Camera)
		update_PointLight()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_BaseBuildCube_attach_point()
	update_BuildCube()
	update_rotating_circles(BaseBuildCube)
	#if is_instance_valid(BaseBuildCube):
	#	print(BaseBuildCube.attached_cubes) 
	pass

func update_all_BuildCubes_connection():
	for i in get_tree().get_nodes_in_group("BuildCubes"):
		if !i.is_connected("mouse_in", self, "_on_BuildCubes_mouse_in"):
			Global.connect_and_detect(i.connect("mouse_in", self, "_on_BuildCubes_mouse_in"))
		if !i.is_connected("mouse_out", self, "_on_BuildCubes_mouse_out"):
			Global.connect_and_detect(i.connect("mouse_out", self, "_on_BuildCubes_mouse_out"))

func _on_BuildCubes_mouse_in(_Cube):
	BaseBuildCube = _Cube
	emit_signal("BaseBuildCube_changed", BaseBuildCube)
	if BaseBuildCube.has_method("set_outline"):
		BaseBuildCube.set_outline(true, 0.1, Color.white)

func _on_BuildCubes_mouse_out(_Cube):
	if is_instance_valid(_Cube):
		if _Cube.has_method("set_outline"):
			_Cube.set_outline(false, 0.1, Color.white)
	if BaseBuildCube == _Cube:
		BaseBuildCube = null
		BaseBuildCube_attach_point = null
		emit_signal("BaseBuildCube_changed", null)

func update_BaseBuildCube_attach_point():
	if !is_instance_valid(BaseBuildCube):
		return
	#print(BaseBuildCube.area)
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
	BuildCubeRay_point_position = pos
	var _BaseBuildCube_attach_point = BaseBuildCube.get_attach_point(pos)
	if !is_instance_valid(_BaseBuildCube_attach_point) or _BaseBuildCube_attach_point == null:
		_BaseBuildCube_attach_point = BaseBuildCube_attach_point
		#BaseBuildCube_attach_point = null
	if !is_instance_valid(_BaseBuildCube_attach_point) or _BaseBuildCube_attach_point == null:
		return false
	#$Area.global_transform = _BaseBuildCube_attach_point.global_transform
	if BaseBuildCube_attach_point != _BaseBuildCube_attach_point:
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

func update_rotating_circles(target_cube : Spatial):
	if !is_instance_valid(target_cube):
		for i in $CanvasLayer/RotatingCircles.get_children():
			i.get_node("AnimationPlayer").stop()
			i.visible = false
		return
	else:
		var count = target_cube.AttachAreas.get_child_count()
		if count > $CanvasLayer/RotatingCircles.get_child_count():
			var _d = count - $CanvasLayer/RotatingCircles.get_child_count()
			for i in _d:
				var new = rotating_circle.instance()
				$CanvasLayer/RotatingCircles.add_child(new)
				new.get_node("AnimationPlayer").stop()
				new.visible = false
				#print("1")
		for i in $CanvasLayer/RotatingCircles.get_child_count():
			$CanvasLayer/RotatingCircles.get_child(i).visible = false
		for i in count:
			#print(i)
			var circle = $CanvasLayer/RotatingCircles.get_child(i)
			circle.visible = true
			circle.get_node("AnimationPlayer").play("default")
			circle.scale = Vector2(0.1, 0.1)
			var area = target_cube.AttachAreas.get_child(i)
			circle.global_position = Global.transfer_position_3d_to_2d_in_camera($Camera, area.global_transform.origin)
			if target_cube.attached_cubes.has(i):
				circle.modulate = Color.blue
			else:
				circle.modulate = Color.white
			

func update_PointLight():
	if BuildCubeRay_point_position == null or !is_instance_valid(BaseBuildCube):
		PointLight.visible = false
	else:
		#$Area.global_transform.origin = BuildCubeRay_point_position
		var r = (BuildCubeRay_point_position - $Camera.global_transform.origin).normalized()
		show_PointLight(BuildCubeRay_point_position - r * 2, BuildCubeRay_point_position)

func show_PointLight(light_pos : Vector3, light_target_pos : Vector3):
	PointLight.visible = true
	PointLight.look_at_from_position(light_pos, light_target_pos, Vector3.UP)
	#print(PointLight.global_transform.origin)
	#print(PointLight)
	#PointLight.global_transform = light_transform

func raycast(event : InputEventMouse, camera : Camera = get_viewport().get_camera()) -> Dictionary:
	var from = camera.project_ray_origin(event.position)
	var to = from + camera.project_ray_normal(event.position) * 1000
	return camera.get_world().direct_space_state.intersect_ray(from, to)

func _on_BaseBuildCube_attach_point_changed():
	if is_instance_valid(BuildCube):
		BuildCube.update_transform( BuildCube.build_attach_point_index,
									BaseBuildCube_attach_point,
									BuildCube.build_attach_rotate_index)

func add_new_DynamicData(_text : String, _color : Color, _pos : Vector2, _time : float):
	var new_dd = DynamicData.instance()
	$BuildInterfaceGUI.add_child(new_dd)
	new_dd.start(_text, _color, _pos, _time)

func _on_changed_BuildTarget(new_BuildTarget):
	if is_instance_valid(BuildCube):
		BuildCube.queue_free()
	
	if TargetBuildCube != new_BuildTarget:
		add_new_DynamicData("切换建造目标", Color(randf(),randf(),randf(),1), $BuildInterfaceGUI.get_local_mouse_position(), 0.8)
	
	TargetBuildCube = new_BuildTarget
	
	if build_mode == BUILD_MODE.ATTACH:
		BuildCube = TargetBuildCube.instance()
		$BuildCubes.add_child(BuildCube)
		BuildCube.visible = false

func _on_BaseBuildCube_changed(BaseBuildCube):
	#update_cube_rotating_circle(BaseBuildCube)
	pass

func _on_build_mode_changed(target_mode):
	var t : String
	match target_mode:
		0:
			t = "笔刷模式：添加"
		1:
			t = "笔刷模式：擦除"
		2:
			t = "笔刷模式：旋转"
		3:
			t = "笔刷模式：切换"
	add_new_DynamicData(t, Color(randf(),randf(),randf(),1), $BuildInterfaceGUI.get_local_mouse_position(), 0.8)

func _on_camera_mode_changed(target_mode):
	var t : String
	match target_mode:
		CAMERA_MODE.FLY:
			t = "相机模式：飞行"
		CAMERA_MODE.PRIVOT:
			t = "相机模式：锚定"
	add_new_DynamicData(t, Color(randf(),randf(),randf(),1), $BuildInterfaceGUI.get_local_mouse_position(), 0.8)
