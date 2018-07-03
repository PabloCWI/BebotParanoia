extends Node2D

var max_hp_value = 100.0;
var current_hp_value = 100.0;
var percentage;
onready var HPNode = get_node("HP");

func _ready():
	
	pass

func _set_current_factory_hp(value):	
	current_hp_value = value;

func _get_current_factory_hp():
	return current_hp_value;

sync func _reduce_factory_hp(value):	
	current_hp_value = current_hp_value - value;
	if(current_hp_value < 0):
		
		current_hp_value = 0;
	percentage = current_hp_value / max_hp_value;
	HPNode.set_scale(Vector2(percentage,1))
	pass



