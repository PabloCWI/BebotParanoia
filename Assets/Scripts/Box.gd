extends KinematicBody 

sync var Rules;

func _ready():
	Rules.Status = "Incomplete";
	add_to_group("boxes");
	
	pass
