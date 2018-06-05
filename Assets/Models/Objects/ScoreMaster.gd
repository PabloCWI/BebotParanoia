extends Node

onready var score;
onready var factory_Health;
onready var computer_Patience;

func _ready():
	score = 0;
	factory_Health = 100;
	computer_Patience = 100;
	
	pass

func _process(delta):
	updateScore();
	pass

func updateScore():
	pass
