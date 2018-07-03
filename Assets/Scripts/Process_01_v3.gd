extends StaticBody

var currentBox;
var boxHolder;
var hasBox;
var processUnderway;
var processTime;
var processStatus;
onready var nwMaster = get_parent().get_node("NetworkMaster");
onready var processEmptyMaterial = preload("res://Assets/Models/Textures/ProcessEmptyMaterial.tres");
onready var processReadyMaterial = preload("res://Assets/Models/Textures/ProcessReadyMaterial.tres");
onready var processWorkingMaterial = preload("res://Assets/Models/Textures/ProcessWorkingMaterial.tres");

func _ready():
	add_to_group("process");	
	boxHolder = get_node("BoxHolder");
	currentBox = null;
	hasBox = false;
	processStatus = "ReadyToReceive"
	self.get_node("MeshInstance").set_surface_material(0, processEmptyMaterial)
	processTime = 0.0;
	pass

func _process(delta):
	if(hasBox == false):
		processStatus = "ReadyToReceive"
		self.get_node("MeshInstance").set_surface_material(0, processEmptyMaterial)
	
	if(hasBox == true && processStatus != "ReadyToDeliver"):
		processStatus = "Processing";
		self.get_node("MeshInstance").set_surface_material(0, processWorkingMaterial)
			
	if(processStatus == "Processing"):
		do_process(delta);
	pass

func do_process(delta):
	processTime = processTime + delta;
	if(processTime > 3.0):
		currentBox = boxHolder.get_child(0);
		processStatus = "ReadyToDeliver";
		self.get_node("MeshInstance").set_surface_material(0, processReadyMaterial)
		processTime = 0.0;
	pass

func can_deliver_box():
	if(processStatus == "ReadyToDeliver"):
		return currentBox.get_name();
	else:
		return null;