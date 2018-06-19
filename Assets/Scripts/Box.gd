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

func _setColor(boxColor):
	self.get_node("BoxMesh").get_surface_material(1).albedo_color = boxColor;
	pass

func _setOwner(owningPlayer):
	BoxOwnership = owningPlayer;
	pass

func _setStatus(status):
	Status = status;

