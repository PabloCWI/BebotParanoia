extends StaticBody

var currentBox;
var hasBox;
var boxCounter;
var processTime;
var processStatus;
var inputPlayer01Color;
var inputPlayer02Color;
var owningPlayer = "";
onready var player_colors = []
onready var box = preload("res://Assets/Models/Objects/Box2.tscn");
onready var nwMaster = get_parent().get_node("NetworkMaster");
onready var rlMaster = get_parent().get_node("RuleMaster");
onready var player01Material = preload("res://Assets/Models/Textures/BoxMaterialPlayer01.tres")
onready var player02Material = preload("res://Assets/Models/Textures/BoxMaterialPlayer02.tres")

func _ready():
	add_to_group("process");
	currentBox = null;
	hasBox = false;
	boxCounter = 0;
	processStatus = "Processing"
	processTime = 0.0;
	
	pass

func _set_players_color(player1Color, player2Color):
	print("P1:", player1Color, " P2: ",player2Color);	
	inputPlayer01Color = player1Color
	inputPlayer02Color = player2Color
	rpc("set_material_color");
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

sync func set_material_color():
	player01Material.albedo_color = inputPlayer01Color;
	player02Material.albedo_color = inputPlayer02Color;
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
	if(randi()%50 > 25):
		owningPlayer = "Player_01";		
		currentBox.get_node("BoxMesh").set_surface_material(1, player01Material)		
	else:
		owningPlayer = "Player_02";
		currentBox.get_node("BoxMesh").set_surface_material(1, player02Material)		
	currentBox.set_name("Box_" + str(boxCounter).pad_zeros(10))
	currentBox.BoxOwnership = owningPlayer;
	currentBox.Status = "Incomplete";
	currentBox.Rules = rlMaster.add_rules_to_new_box_instance()	
	processTime = 0.0;
	get_node("BoxHolder").add_child(currentBox);
	hasBox = true;


