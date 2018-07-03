extends Node

onready var boxesLeft;
onready var factory_Health;
onready var computer_Patience;
onready var ui_patience = get_parent().get_node("ComputerPatience");
onready var ui_hp = get_parent().get_node("FactoryHP");
onready var ui_boxCounter = get_parent().get_node("BoxCounter");
onready var gameOver;

func _ready():
	boxesLeft = 0;
	factory_Health = 100.0;
	computer_Patience = 100.0;
	ui_patience._set_current_computer_patience(computer_Patience);
	ui_hp._set_current_factory_hp(factory_Health);	
	pass

func _reduce_computer_patience():	
	ui_patience.rpc("_reduce_computer_patience",10.0);
	if(ui_patience._get_current_computer_patience() == 0.0):
		gameOver = "FAIL";
	pass

func _reduce_factory_hp():	
	ui_hp.rpc("_reduce_factory_hp",10.0);
	if(ui_hp._get_current_factory_hp() == 0.0):
		gameOver = "FAIL";
	pass

func _set_boxes_left(value):
	if(value <= 0):
		gameOver = "WIN";
		pass
	ui_boxCounter.rpc("_set_number_of_boxes_left", value);


func _get_game_over_status():
	return gameOver;