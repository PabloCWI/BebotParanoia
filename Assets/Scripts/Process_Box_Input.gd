extends StaticBody

var currentBox;
var boxReceiver;
var boxHolder;
var hasBox;
var processUnderway;
var processTime;
var processStatus;
onready var box = preload("res://Assets/Models/Objects/Box.tscn");

func _ready():
	add_to_group("process");
	boxReceiver = get_node("BoxReceiver");
	boxHolder = get_node("BoxHolder");
	currentBox = null;
	hasBox = false;
	processStatus = "Processing"
	processTime = 0.0;
	pass

func _process(delta):
	if(hasBox == false and processStatus == "Processing"):
		do_process(delta);

	pass

func do_process(delta):
	processTime = processTime + delta;
	
	if(processTime > 3.0):
		rpc("instantiate_box");
	pass


func process_status():	
	return processStatus;
	

# SAFE RPC CALLS

sync func instantiate_box():
	currentBox = box.instance();
	boxHolder.add_child(currentBox);		
	processStatus = "ReadyToDeliver";
	processTime = 0.0;

func deliver_box_to(player):
	if(player.hasBox == false):
		player.set_hasBox(true);
		processStatus = "Processing";
		hasBox = false;
		boxHolder.remove_child(currentBox);
		return currentBox;