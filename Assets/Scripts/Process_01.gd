extends StaticBody

var current_box;
var box_receiver;
var box_holder;
var has_box;

func _ready():
	add_to_group("process");
	box_receiver = get_node("BoxReceiver");
	box_holder = get_node("BoxHolder");
	current_box = null;
	has_box = false;
	pass

func _process(delta):

	pass

func do_process():
	print("Performing Process: ");
	
func deliver_box(box, player):
	print("Delivering Box");
	
func receive_box(box, player):
	if (box.is_in_group("boxes")):
		
		print("Box Received: ", box.ID);


