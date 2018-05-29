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
		rpc("do_process", delta);

	pass

master func do_process(delta):
	processTime = processTime + delta;

	if(processTime > 3.0):
		rpc("instantiate_box", box);
	pass

func process_status():
	return processStatus;

func can_deliver_box():
	print("Process: ", self, " is delivering box: ", currentBox)
	print(hasBox, " ", processStatus)	
	if(hasBox == true && processStatus == "ReadyToDeliver"):
		hasBox = false;
		#boxHolder.remove_child(currentBox);
		print("Process ready to remove box.")
		return currentBox;
	else:
		print("Process cannot deliver box.")
		return null;


# SAFE RPC CALLS

sync func instantiate_box(new_box):
	processStatus = "ReadyToDeliver";
	currentBox = new_box.instance();
	processTime = 0.0;
	boxHolder.add_child(currentBox);
	hasBox = true;


