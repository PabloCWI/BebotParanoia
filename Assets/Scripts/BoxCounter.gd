extends Node2D

onready var numberOfBoxesToWin;
onready var boxCounterValue = get_node("Number");

func _ready():
	
	pass

sync func _set_number_of_boxes_left(value):
	boxCounterValue.text = str(value);
	pass
