extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	var x = 4
	var y = 3
	var z = sqrt(x^2 + y^2)
	if z < x + y:
		print("不构成图形")
	elif z == x + y:
		print("构成线段")
	else:
		print("构成三角形，第三边的边长为：", z)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


	
