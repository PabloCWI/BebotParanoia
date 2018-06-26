extends Node2D

var max_patience_value = 100;
var current_patience_value = 100;
var percentage;
onready var CPNode = get_node("Patience");

func _ready():
	
	pass

func _set_current_computer_patience(value):
	print("Setting patience value to: ", value)
	current_patience_value = value;

func _get_current_computer_patience():
	return current_patience_value;

sync func _reduce_computer_patience(value):
	print("Reducing current patience: ", current_patience_value, " by: ", value)
	current_patience_value = current_patience_value - value;
	if(current_patience_value < 0):
		current_patience_value = 0;
	percentage = current_patience_value / max_patience_value;
	CPNode.set_scale(Vector2(percentage,1))
	pass



