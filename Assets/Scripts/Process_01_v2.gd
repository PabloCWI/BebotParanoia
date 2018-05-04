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
		do_process(delta);

	pass

func do_process(delta):
	processTime = processTime + delta;
	
	if(processTime > 3.0):
		processStatus = "ReadyToDeliver";
		processTime = 0.0;
	pass
	
func process_status():	
	return processStatus;
	
func deliver_box_to(player):
	if(player.hasBox == false):
		player.set_hasBox(true);
		processStatus = "ReadyToReceive";
		hasBox = false;
		boxHolder.remove_child(currentBox);
		return currentBox;

func receive_box_from(box, player):
	if (player.hasBox == true and processStatus == "ReadyToReceive" and box.is_in_group("boxes") ):
		player.set_hasBox(false);
		boxHolder.add_child(box);
		currentBox = box;
		box.set_translation(Vector3(0,0,0));
		processStatus = "Processing";
		hasBox = true;