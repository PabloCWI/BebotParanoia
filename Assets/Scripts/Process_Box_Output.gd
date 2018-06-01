extends StaticBody

var currentBox;
var boxReceiver;
var boxHolder;
var hasBox;
var processUnderway;
var processTime;
var processStatus;
onready var nwMaster = get_parent().get_node("NetworkMaster");

func _ready():
	add_to_group("process");
	boxReceiver = get_node("BoxReceiver");
	boxHolder = get_node("BoxHolder");
	currentBox = null;
	hasBox = false;
	processStatus = "ReadyToReceive"
	processTime = 0.0;
	pass

func _process(delta):
	if(hasBox == true and processStatus == "ReadyToReceive"):
		processStatus = "Processing";
		print("Preparing to remove");
	
	if(hasBox == true and processStatus == "Processing"):
		do_process(delta);

	pass

func do_process(delta):
	processTime = processTime + delta;
	
	if(processTime > 3.0):
		print("Removing");
		processStatus = "ReadyToReceive";
		processTime = 0.0;
		hasBox = false;
		currentBox = boxHolder.get_child(0);
		currentBox.visible = false;
		currentBox.queue_free();
	pass
	
func can_deliver_box():
		return null;