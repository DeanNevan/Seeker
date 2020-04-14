extends Control

signal changed_BuildTarget(BuildTarget)

var BaseBuildCube

onready var Tween1 = Tween.new()

func _ready():
	add_child(Tween1)
	Tween1.interpolate_property($Info, "rect_size", $Info.rect_size, Vector2(264, 0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	Tween1.start()
	
	for i in get_tree().get_nodes_in_group("ButtonBuildCubes"):
		Global.connect_and_detect(i.connect("changed_BuildTarget", self, "_on_changed_BuildTarget"))
	for i in $BuildList/VBoxContainer/SwitchList.get_children():
		Global.connect_and_detect(i.connect("pressed", self, "_on_SwitchListButton_pressed", [i.get_index()]))
	$Button.connect("toggled", self, "_on_button_toggled")
	$Button.pressed = true
	set_process(false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(BaseBuildCube):
		$Info/Info.bbcode_text = "[center]" + BaseBuildCube.name_CN + "[/center]\n----------------------\n" + BaseBuildCube.information + "\n----------------------\n"
		$Info/Info.bbcode_text += ""
	pass

func _on_BaseBuildCube_changed(_BaseBuildCube):
	if is_instance_valid(_BaseBuildCube):
		Tween1.interpolate_property($Info, "rect_size", $Info.rect_size, Vector2(264, 600), 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		Tween1.start()
		BaseBuildCube = _BaseBuildCube
		set_process(true)
	else:
		Tween1.interpolate_property($Info, "rect_size", $Info.rect_size, Vector2(264, 0), 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		Tween1.start()
		set_process(false)
		pass

func _on_changed_BuildTarget(BuildTarget):
	emit_signal("changed_BuildTarget", BuildTarget)
	pass

func _on_SwitchListButton_pressed(index):
	for i in $BuildList/VBoxContainer/Control.get_child_count():
		$BuildList/VBoxContainer/Control.get_child(i).visible = false
	$BuildList/VBoxContainer/Control.get_child(index + 1).visible = true
	$BuildList/VBoxContainer/Control/Background.visible = true
	pass

func _on_button_toggled(is_pressed):
	if is_pressed:
		$BuildList.visible = true
		$Button.text = "收起"
	else:
		$BuildList.visible = false
		$Button.text = "展开"

func _on_build_mode_changed(target_mode : int):
	match target_mode:
		0:
			$BrushModeLabel.text = "笔刷模式：添加"
		1:
			$BrushModeLabel.text = "笔刷模式：擦除"
		2:
			$BrushModeLabel.text = "笔刷模式：旋转"
		3:
			$BrushModeLabel.text = "笔刷模式：切换"
	pass

func _on_camera_mode_changed(target_mode : int):
	match target_mode:
		0:
			$CameraModeLabel.text = "相机模式：飞行"
		1:
			$CameraModeLabel.text = "相机模式：锚定"
