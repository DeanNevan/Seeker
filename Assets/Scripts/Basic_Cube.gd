extends Spatial

export(int) var MAX_HEALTH = 100
export(float) var GENERATE_TIME = 0.4
export(float) var MASS = 1

var type = Cube.TYPE.BASE

var name_CN = "测试用基础方块"
var information = "这是一个测试用的基础方块"

#var attach_points := {}#{index:Position3D}

var attach_cubes := {}#{index:Cube}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
