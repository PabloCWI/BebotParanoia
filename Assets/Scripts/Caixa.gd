extends Spatial

var ID = 100000
var Box_Color

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	add_to_group("boxes");
	ID + 1;
	Box_Color  = "RED";
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func get_Color():
	return Box_Color;