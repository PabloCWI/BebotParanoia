extends KinematicBody 

sync var Rules;

onready var process01Texture = preload("res://Assets/Models/Textures/BoxMaterialProcess01.tres")
onready var process02Texture = preload("res://Assets/Models/Textures/BoxMaterialProcess02.tres")
onready var process03Texture = preload("res://Assets/Models/Textures/BoxMaterialProcess03.tres")
onready var processDoneTexture = preload("res://Assets/Models/Textures/BoxMaterialProcessDone.tres")


func _ready():
	Rules.Status = "Incomplete";
	add_to_group("boxes");
	
	pass

sync func remove_step():
	if(Rules.ProcessSteps != []):
		Rules.ProcessSteps.pop_front();
	if(Rules.ProcessSteps != []):
		if(Rules.ProcessSteps[0] == "Process_01"):
			self.get_node("BoxMesh").set_surface_material(0, process01Texture);
		if(Rules.ProcessSteps[0] == "Process_02"):
			self.get_node("BoxMesh").set_surface_material(0, process02Texture);
		if(Rules.ProcessSteps[0] == "Process_03"):
			self.get_node("BoxMesh").set_surface_material(0, process03Texture);
	else:
		self.get_node("BoxMesh").set_surface_material(0, processDoneTexture);
	print("Process Steps: ", Rules.ProcessSteps)
	pass
