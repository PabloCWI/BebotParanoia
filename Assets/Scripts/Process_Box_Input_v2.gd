extends StaticBody

var currentBox;
var hasBox;
var boxCounter;
var processTime;
var processStatus;
onready var box = preload("res://Assets/Models/Objects/Box.tscn");
onready var nwMaster = get_parent().get_node("NetworkMaster");

func _ready():
	add_to_group("process");
	currentBox = null;
	hasBox = false;
	boxCounter = 0;
	processStatus = "Processing"
	processTime = 0.0;
	pass

func _process(delta):
	if(hasBox == false):
		rpc("do_process", delta);
	pass

master func do_process(delta):
	processTime = processTime + delta;
	if(processTime > 3.0):
		rpc("instantiate_box", box);
	pass

func can_deliver_box():
	if(processStatus == "ReadyToDeliver"):
		return currentBox.get_name();
	else:
		return null

# SAFE RPC CALLS

sync func instantiate_box(new_box):
	processStatus = "ReadyToDeliver";
	currentBox = new_box.instance();
	boxCounter = boxCounter + 1;
	currentBox.set_name("Box_" + str(boxCounter).pad_zeros(2))
	processTime = 0.0;
	get_node("BoxHolder").add_child(currentBox);
	hasBox = true;


