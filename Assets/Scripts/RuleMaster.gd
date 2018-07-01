extends Node

onready var score_master = get_parent().get_node("ScoreMaster");
onready var network_master = get_parent().get_node("NetworkMaster");
onready var boxesToDeliver = 10;

func add_rules_to_new_box_instance():
	return generate_rule_set();
	pass

func _give_next_rule_to_box(box):
	if(get_parent().get_node(box) != null):
		get_parent().get_node(box).ruleSet.pop_front();
	else:
		_set_box_ready_to_exit(box);
	pass

func _set_box_ready_to_exit(box):
	get_parent().get_node(box).Status = "Complete";
	pass

func check_current_rule_is_correct_process(player, box, process):
	if(box != null && process != null && get_parent().get_node(player).get_node("BoxHolder").get_node(box).Rules.ProcessSteps[0] != null):
		if(get_parent().get_node(player).get_node("BoxHolder").get_node(box).Rules.ProcessSteps[0] == process):
			print("Correct Process");
		else:
			print("Incorrect Process")
			penalize_factory_health();
			pass
	pass

func check_current_rule_is_correct_player(box, process, player):	
	
	if(box != null && get_parent().get_node(process).currentBox.Rules.BoxOwnership == player):
		print("Correct Player");
	else:
		print("Incorrect Player")
		penalize_computer_patience();
		pass
	pass

func generate_rule_set():
	var ruleSet = {BoxOwnership = "", Status = "", ProcessSteps = []};
	ruleSet.BoxOwnership = ("Player_") + str(randi()%02+1).pad_zeros(2);
	var rule_steps = (randi()%2+3);
	for i in range(rule_steps):
		var process = ("Process_") + str(randi()%02+1).pad_zeros(2);
		ruleSet.ProcessSteps.push_back(process);
		pass
	return ruleSet;
	pass

func penalize_factory_health():
	score_master._reduce_factory_hp();
	network_master._set_game_over_status(score_master._get_game_over_status());
	pass

func penalize_computer_patience():
	score_master._reduce_computer_patience();
	network_master.rpc("_set_game_over_status",score_master._get_game_over_status());
	pass