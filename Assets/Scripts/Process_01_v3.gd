extends StaticBody

var currentBox;
var boxHolder;
var hasBox;
var processUnderway;
var processTime;
var processStatus;
onready var nwMaster = get_parent().get_node("NetworkMaster");

func _ready():
	add_to_group("process");	
	boxHolder = get_node("BoxHolder");
	currentBox = null;
	hasBox = false;
	processStatus = "ReadyToReceive"
	processTime = 0.0;	
	pass

func _process(delta):
	if(hasBox == true and processStatus == "Processing"):
		rpc("do_process", delta);

	pass

master func do_process(delta):
	processTime = processTime + delta;
	if(processTime > 3.0):
		processStatus = "ReadyToDeliver";
		processTime = 0.0;
	pass

func can_deliver_box():
	if(processStatus == "ReadyToDeliver"):
		return currentBox.get_name();
	else:
		return null;