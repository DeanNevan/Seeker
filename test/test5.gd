extends Spatial



# Called when the node enters the scene tree for the first time.
func _ready():
	var x = 4
	var y = 3
	var z = sqrt(pow(x, 2) + pow(y, 2))
	if z > x + y:
		print("不构成图形")
	if z == x + y:
		print("构成线段")
	if z < x + y:
		print("构成三角形，第三边的边长为：", z)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
