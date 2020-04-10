extends Spatial

signal mouse_in(cube)
signal mouse_out(cube)

signal attached_cubes_areas_updated

export(PackedScene) var CUBE

var name_CN = "3"
var information = "4"

var on_mouse = false
var is_built = false

var build_attach_point_index = 0
var build_attach_rotate_index = 0

var area_to_index := {}#{area:index}

var attached_cubes := {}#{index:Cube}
var attached_areas := {}#{index:Area}

onready var area = $Spatial/Spatial/Area
onready var AttachAreas = $Spatial/Spatial/AttachAreas

var Model : MeshInstance
var Model_material : Material
var Model_outline_shader : Material

onready var LightBuild = OmniLight.new()
onready var TweenLightBuild = Tween.new()
func _init():
	add_to_group("BuildCubes")
# Called when the node enters the scene tree for the first time.
func _ready():
	update_info()
	Global.connect_and_detect(area.connect("mouse_entered", self, "_on_mouse_entered"))
	Global.connect_and_detect(area.connect("mouse_exited", self, "_on_mouse_exited"))
	
	init_attach_points()
	
	LightBuild.light_energy = 0
	add_child(LightBuild)
	LightBuild.global_transform.origin = global_transform.origin
	call_deferred("add_child", TweenLightBuild)
	
	Model = $Spatial/Spatial/MeshInstance
	Model_material = Model.get_surface_material(0)
	#print(Model.get_surface_material_count())
	Model_material.next_pass = ShaderMaterial.new()
	Model_material.next_pass.shader = load("res://addons/3D Outline/Outline.shader")
	Model_outline_shader = Model_material.next_pass
	Model_outline_shader.resource_local_to_scene = true
	set_outline(false)
	
	Model.set_layer_mask_bit(0, false)
	Model.set_layer_mask_bit(1, true)
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on_mouse:
		if Input.is_action_just_pressed("key_ctrl"):
			print("emmm")
			for i in attached_cubes.values():
				i.update_attached_cubes_areas()
			update_attached_cubes_areas()
			#print("attached_areas:", attached_areas)
			#print("attached_cubes:", attached_cubes)
	#	print(attached_cubes)
	pass

#返回area
func get_attach_point(pos : Vector3):
	var min_distance = 1000
	var attach_area : Area
	update_attached_cubes_areas()
	erase_unvalid_attached_cubes_areas()
	for i in AttachAreas.get_child_count():
		var area = AttachAreas.get_child(i)
		if attached_cubes.has(area_to_index[area]):
			#print("2333")
			continue
		var distance = pos.distance_to(area.global_transform.origin)
		if distance < min_distance:
			attach_area = area
			min_distance = distance
	return attach_area

func update_info():
	if CUBE == null:
		return
	var instance = CUBE.instance()
	name_CN = instance.name_CN
	information = instance.information
	instance.queue_free()

func update_transform(_build_attach_point_index : int, _build_attach_point : Area, _build_attach_rotate_index : int):
	build_attach_rotate_index = _build_attach_rotate_index
	if _build_attach_point_index > area_to_index.keys().size() - 1:
		while _build_attach_point_index > area_to_index.keys().size() - 1:
			_build_attach_point_index -= area_to_index.keys().size()
	build_attach_point_index = _build_attach_point_index
	
	#_build_attach_point.user.attached_cubes[_build_attach_point.user.area_to_index[_build_attach_point]] = self
	#attached_cubes[area_to_index[AttachAreas.get_child(build_attach_point_index)]] = _build_attach_point.user
	
	self.transform = Transform()
	$Spatial.transform = Transform()
	$Spatial/Spatial.transform = Transform()
	force_update_transform()
	$Spatial.force_update_transform()
	$Spatial/Spatial.force_update_transform()
	
	var self_attach_point : Area
	self_attach_point = AttachAreas.get_child(build_attach_point_index)
	var target_attach_point = _build_attach_point
	
	if target_attach_point == null:
		#return false
		target_attach_point = AttachAreas.get_child(build_attach_point_index)
	
	var transpose_basis = self_attach_point.global_transform.basis.transposed()
	$Spatial/Spatial.global_transform.basis = transpose_basis
	$Spatial.force_update_transform()
	$Spatial/Spatial.force_update_transform()
	
	#yield(get_tree(), "idle_frame")
	var offset = $Spatial.global_transform.origin - self_attach_point.global_transform.origin
	$Spatial/Spatial.global_translate(offset)
	$Spatial.force_update_transform()
	$Spatial/Spatial.force_update_transform()
	
	#yield(get_tree(), "idle_frame")
	var tt = target_attach_point.global_transform.basis.rotated(target_attach_point.global_transform.basis.x.normalized(), PI)
	$Spatial.global_transform.basis = tt
	$Spatial/Spatial.force_update_transform()
	$Spatial.force_update_transform()
	
	#yield(get_tree(), "idle_frame")
	var v = target_attach_point.global_transform.origin - $Spatial.global_transform.origin
	$Spatial.global_translate(v)
	$Spatial/Spatial.force_update_transform()
	$Spatial.force_update_transform()
	
	#yield(get_tree(), "idle_frame")
	#$Spatial.rotate_object_local($Spatial.transform.basis.y, build_attach_rotate_index * PI / 2)
	$Spatial.global_transform.basis = $Spatial.global_transform.basis.rotated($Spatial.global_transform.basis.y.normalized(), build_attach_rotate_index * PI / 2)
	$Spatial.force_update_transform()
	
	#yield(get_tree(), "idle_frame")
	#if is_built:
	#	update_attached_cubes_areas(false)
	#else:
	#	update_attached_cubes_areas(false)
	erase_unvalid_attached_cubes_areas()

func init_attach_points():
	for i in AttachAreas.get_child_count():
		var area = AttachAreas.get_child(i)
		area_to_index[area] = i
		area.user = self
		#Global.connect_and_detect(area.connect("attached_area_changed", self, "_on_attached_area_changed"))

func smooth_change_LightBuild_energy(new_energy = 1, change_time = 0.3, delete_cube = false):
	if TweenLightBuild.is_inside_tree():
		LightBuild.visible = true
		TweenLightBuild.interpolate_property(LightBuild, "light_energy", LightBuild.light_energy, new_energy, change_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		TweenLightBuild.start()
		yield(TweenLightBuild, "tween_completed")
		if LightBuild.light_energy == 0:
			LightBuild.visible = false
		if delete_cube:
			queue_free()

func attached():
	area.input_ray_pickable = true
	is_built = true
	Model.set_layer_mask_bit(1, false)
	Model.set_layer_mask_bit(0, true)
	
	yield(get_tree(), "idle_frame")
	for i in attached_cubes.values():
		i.update_attached_cubes_areas()
	update_attached_cubes_areas()
	#print(attached_areas)
	#print(attached_cubes)
	#print("---")
	#$Spatial/Area.monitorable = true
	#$Spatial/Area.set_collision_layer_bit(0, true)
	#$Spatial/Area.set_collision_layer_bit(1, false)
	pass

func erased():
	yield(get_tree(), "idle_frame")
	for i in attached_cubes.values():
		i.update_attached_cubes_areas()
	update_attached_cubes_areas()
	#yield(get_tree(), "idle_frame")
	queue_free()
	pass

func rotated():
	yield(get_tree(), "idle_frame")
	for i in attached_cubes.values():
		i.update_attached_cubes_areas()
	update_attached_cubes_areas()
	pass

func switched():
	yield(get_tree(), "idle_frame")
	for i in attached_cubes.values():
		i.update_attached_cubes_areas()
	update_attached_cubes_areas()
	pass

func update_attached_cubes_areas():
	attached_areas.clear()
	attached_cubes.clear()
	for i in AttachAreas.get_child_count():
		var area : Area
		area = AttachAreas.get_child(i)
		var _attached_areas = area.get_overlapping_areas()
		#print(_attached_areas)
		if _attached_areas.size() == 0:
			continue
		for a in _attached_areas:
			var jud = false
			if a.has_method("attach_point"):
				if !a.user.is_built:
					continue
				if jud:
					print("error:update attached areas")
					return false
				jud = true
				#if a.user.attached_areas.values.has(area):
				#	print("error:update attached areas")
				#	return false
				attached_areas[area_to_index[area]] = a
				attached_cubes[area_to_index[area]] = a.user
	erase_unvalid_attached_cubes_areas()
	pass

func erase_unvalid_attached_cubes_areas():
	for i in attached_cubes:
		if !is_instance_valid(attached_cubes[i]):
			attached_cubes.erase(i)
	for i in attached_areas:
		if !is_instance_valid(attached_areas[i]):
			attached_areas.erase(i)

func set_outline(enabled := true, thickness := 0.1, color := Color.white):
	Model_outline_shader.set_shader_param("enable", enabled)
	Model_outline_shader.set_shader_param("outline_thickness", thickness)
	Model_outline_shader.set_shader_param("color", color)

func _on_attached_area_changed(area, attached_area):
	#if attached_area == null:
		#attached_cubes.erase(area_to_index[area])
	#if !attached_areas.values().has(attached_area):
	#	attached_areas[area_to_index[area]] = attached_area
	if is_instance_valid(attached_area):
		attached_cubes[area_to_index[area]] = attached_area.user
	yield(get_tree(), "idle_frame")
	erase_unvalid_attached_cubes_areas()

func _on_mouse_entered():
	if !is_built:
		return
	on_mouse = true
	#smooth_change_LightBuild_energy(1, 0.4)
	emit_signal("mouse_in", self)

func _on_mouse_exited():
	if !is_built:
		return
	on_mouse = false
	#smooth_change_LightBuild_energy(0, 0.25)
	emit_signal("mouse_out", self)


