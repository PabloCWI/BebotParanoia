extends KinematicBody 

var Box_Color
var BoxOwnership = ""
var Status
onready var Rules

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	Status = "Incomplete";
	add_to_group("boxes");
	
	pass
