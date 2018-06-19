extends Node

onready var score;
onready var factory_Health;
onready var computer_Patience;
onready var ui_patience = get_parent().get_node("ComputerPatience");
onready var ui_hp = get_parent().get_node("FactoryHP");

func _ready():
	score = 0;
	factory_Health = 100.0;
	computer_Patience = 100.0;
	ui_patience._set_current_computer_patience(computer_Patience);
	ui_hp._set_current_factory_hp(factory_Health);	
	pass

func _reduce_computer_patience():	
	ui_patience._reduce_computer_patience(10.0);
	pass

func _reduce_factory_hp():	
	ui_hp._reduce_factory_hp(10.0);
	pass