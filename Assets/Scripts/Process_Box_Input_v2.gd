extends StaticBody

var currentBox;
var hasBox;
var boxCounter;
var processTime;
var processStatus;
var player01Color;
var player02Color;
var owningPlayer = "";
onready var box = preload("res://Assets/Models/Objects/Box2.tscn");
onready var nwMaster = get_parent().get_node("NetworkMaster");
onready var rlMaster = get_parent().get_node("RuleMaster");

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
	var boxColor = Color();
	if(randi()%2 == 1):
		owningPlayer = "Player_01"
		#player01Color
		boxColor = Color(0.0,0.0,1.0,1.0);
	else:
		owningPlayer = "Player_02"
		#player02Color
		boxColor = Color(1.0,0.0,0.0,1.0);
	currentBox.set_name("Box_" + str(boxCounter).pad_zeros(10))
	currentBox._setOwner(owningPlayer);
	currentBox._setColor(boxColor);
	currentBox.Rules = rlMaster.add_rules_to_new_box_instance()	
	processTime = 0.0;
	get_node("BoxHolder").add_child(currentBox);
	hasBox = true;


