extends Control

signal changed_BuildTarget(BuildTarget)

func _ready():
	for i in get_tree().get_nodes_in_group("ButtonBuildCubes"):
		Global.connect_and_detect(i.connect("changed_BuildTarget", self, "_on_changed_BuildTarget"))
	for i in $BuildList/VBoxContainer/SwitchList.get_children():
		Global.connect_and_detect(i.connect("pressed", self, "_on_SwitchListButton_pressed", [i.get_index()]))
	$Button.connect("toggled", self, "_on_button_toggled")
	$Button.pressed = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
