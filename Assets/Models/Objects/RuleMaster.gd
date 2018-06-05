extends Node

onready var rule_steps = 3;

func _ready():
	
	pass

func add_rules_to_new_box_instance():
	return generate_rule_set();
	pass

func _give_next_rule_to_box(box):
	get_parent().get_node(box).ruleSet.pop_front();
	pass

func _set_box_ready_to_exit(box):
	pass

func check_current_rule_is_correct_process(box, process):
	pass

func check_current_rule_is_correct_player(box, process, player):	
	if(get_parent().get_node(process).currentBox.Rules[0].Player == player):
		print("Correct Player");
	else:
		print("Incorrect Player")
		pass
	pass

func generate_rule_set():
	var ruleSet = [];
	for i in range(rule_steps):
		var process = ("Process_") + str(randi()%02+1).pad_zeros(2);
		var player = ("Player_") + str(randi()%02+1).pad_zeros(2);
		var rule = rule_dictionary(player, process);		
		ruleSet.push_back(rule);
		pass
	return ruleSet;
	pass

func rule_dictionary(_Player, _Process):
	return {Player = _Player, Process = _Process};