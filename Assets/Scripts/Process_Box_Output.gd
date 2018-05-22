extends StaticBody

var currentBox;
var boxReceiver;
var boxHolder;
var hasBox;
var processUnderway;
var processTime;
var processStatus;

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
	if(hasBox == true and processStatus == "Processing"):		
		rpc("do_process", delta);

	pass

sync func do_process(delta):
	processTime = processTime + delta;
	
	if(processTime > 3.0):
		processStatus = "ReadyToReceive";
		processTime = 0.0;
		currentBox.visible = false;
		currentBox.queue_free();
	pass
	
sync func process_status():	
	return processStatus;

sync func receive_box_from(box, player):
	if (player.hasBox == true and processStatus == "ReadyToReceive" and box.is_in_group("boxes") ):
		player.set_hasBox(false);
		boxHolder.add_child(box);
		currentBox = box;
		box.set_translation(Vector3(0,0,0));
		processStatus = "Processing";
		hasBox = true;