extends TextureButton

signal changed_BuildTarget(BuildTarget)

export(PackedScene) var CUBE_BUILD
export(float) var UNSELECTED_ALPHA = 0.5
export(float) var SELECTED_ALPHA = 1

var name_CN = "1"
var information = "2"

var is_pressed = false

var SelectionBar : TextureProgress

var InfoLabel = preload("res://Assets/Scenes/GUI/Info.tscn")
var InfoLabelInstance

onready var TweenSelectionBar = Tween.new()
# Called when the node enters the scene tree for the first time.
func _init():
	add_to_group("ButtonBuildCubes")

func _ready():
	add_child(TweenSelectionBar)
	Global.connect_and_detect(connect("pressed", self, "_pressed"))
	Global.connect_and_detect(connect("button_down", self, "_on_button_down"))
	Global.connect_and_detect(connect("button_up", self, "_on_button_up"))
	Global.connect_and_detect(connect("mouse_entered", self, "_on_mouse_entered"))
	Global.connect_and_detect(connect("mouse_exited", self, "_on_mouse_exited"))
	update_info()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_mouse_entered(change_time = 0.3):
	#TweenSelectionBar.interpolate_property(SelectionBar, "value", SelectionBar.value, 99.9, change_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	#if !TweenSelectionBar.is_active():
	#	TweenSelectionBar.start()
	InfoLabelInstance = InfoLabel.instance()
	InfoLabelInstance.set_text("[center]" + name_CN + "[/center]" + "\n----------------------\n" + information + "\n----------------------")
	InfoLabelInstance.user = self
	InfoLabelInstance.rect_global_position = rect_global_position
	Gui.add_child(InfoLabelInstance)
	pass

func _on_mouse_exited(change_time = 0.2):
	if InfoLabelInstance != null:
		InfoLabelInstance.judge_free()
		InfoLabelInstance = null
	if is_pressed:
		return
	#TweenSelectionBar.interpolate_property(SelectionBar, "value", SelectionBar.value, 0, change_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	#if !TweenSelectionBar.is_active():
	#	TweenSelectionBar.start()
	pass

func _pressed():
	for i in get_tree().get_nodes_in_group("ButtonBuildCubes"):
		if i != self:
			i.cancel_select()
		else:
			select()
	pass

func _on_button_down():
	
	pass

func _on_button_up():
	pressed = true
	pass

func select():
	is_pressed = true
	TweenSelectionBar.interpolate_property(self, "modulate", modulate, Color(modulate.r, modulate.g, modulate.b, SELECTED_ALPHA), 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenSelectionBar.start()
	emit_signal("changed_BuildTarget", CUBE_BUILD)
	pass

func cancel_select():
	is_pressed = false
	_on_mouse_exited()
	#pressed = false
	TweenSelectionBar.interpolate_property(self, "modulate", modulate, Color(modulate.r, modulate.g, modulate.b, UNSELECTED_ALPHA), 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	TweenSelectionBar.start()
	pass

func update_info():
	if CUBE_BUILD == null:
		return
	var instance = CUBE_BUILD.instance()
	instance.update_info()
	name_CN = instance.name_CN
	information = instance.information
	instance.queue_free()
	pass
