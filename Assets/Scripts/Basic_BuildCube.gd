extends Spatial

signal mouse_in(cube)
signal mouse_out(cube)

export(PackedScene) var CUBE

var name_CN = "3"
var information = "4"

var build_attach_point_index = 0
var build_attach_rotate_index = 0

var area_to_index := {}#{area:index}

var attached_cubes := {}#{index:Cube}

onready var area = $Spatial/Spatial/Area
onready var AttachAreas = $Spatial/Spatial/AttachAreas

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
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#返回area
func get_attach_point(pos : Vector3):
	var min_distance = 1000
	var attach_area : Area
	for i in AttachAreas.get_child_count():
		var area = AttachAreas.get_child(i)
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
	
	self.transform = Transform()
	$Spatial.transform = Transform()
	$Spatial/Spatial.transform = Transform()
	force_update_transform()
	$Spatial.force_update_transform()
	$Spatial/Spatial.force_update_transform()
	
	var self_attach_point : Area
	self_attach_point = AttachAreas.get_child(build_attach_point_index)
	var target_attach_point = _build_attach_point
	
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
	var tt = target_attach_point.global_transform.basis.rotated(target_attach_point.global_transform.basis.x, PI)
	$Spatial.global_transform.basis = tt
	$Spatial/Spatial.force_update_transform()
	$Spatial.force_update_transform()
	
	#yield(get_tree(), "idle_frame")
	var v = target_attach_point.global_transform.origin - $Spatial.global_transform.origin
	$Spatial.global_translate(v)
	$Spatial/Spatial.force_update_transform()
	$Spatial.force_update_transform()
	
	#yield(get_tree(), "idle_frame")
	$Spatial.rotate_object_local($Spatial.global_transform.basis.y, build_attach_rotate_index * PI / 2)
	$Spatial.force_update_transform()

func init_attach_points():
	for i in AttachAreas.get_child_count():
		var area = AttachAreas.get_child(i)
		area_to_index[area] = i
		area.user = self
		Global.connect_and_detect(area.connect("attached_area_changed", self, "_on_attached_area_changed"))

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

func build():
	area.input_ray_pickable = true
	#$Spatial/Area.monitorable = true
	#$Spatial/Area.set_collision_layer_bit(0, true)
	#$Spatial/Area.set_collision_layer_bit(1, false)
	pass

func _on_attached_area_changed(area, attached_area):
	if attached_area == null:
		attached_cubes.erase([area_to_index[area]])
	else:
		attached_cubes[area_to_index[area]] = attached_area.user

func _on_mouse_entered():
	smooth_change_LightBuild_energy(1, 0.4)
	emit_signal("mouse_in", self)

func _on_mouse_exited():
	smooth_change_LightBuild_energy(0, 0.25)
	emit_signal("mouse_out", self)
