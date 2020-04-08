extends Area

signal attached_area_changed(area, attached_area)

var attached_point : Area

var user : Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect_and_detect(connect("area_entered", self, "_on_area_entered"))
	Global.connect_and_detect(connect("area_exited", self, "_on_area_exited"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_area_entered(area : Area):
	if area.has_method("attach_point"):
		attach_point(area)

func _on_area_exited(area : Area):
	if area.has_method("attach_point"):
		attach_point(null)

func attach_point(area):
	attached_point = area
	emit_signal("attached_area_changed", self, attached_point)
