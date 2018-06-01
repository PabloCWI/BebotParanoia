extends Node

var playerObject = load("res://Assets/Models/Objects/Player.tscn")
var boxHolder = ("BoxHolder")

func _ready():
	#instert player 1 onto scene
	var botP1 = playerObject.instance()
	get_parent().call_deferred("add_child",botP1)
	botP1.set_name("Player_01")
	botP1.translate(Vector3(-5,0.5,5))
	
	#instert player 2 onto scene
	var botP2 = playerObject.instance()
	get_parent().call_deferred("add_child",botP2)
	botP2.set_name("Player_02")
	botP2.translate(Vector3(5,0.5,5))	
	
	call_deferred("_set_players_on_network", botP1, botP2)

func _set_players_on_network(botP1, botP2):
	if (get_tree().is_network_server()):				
		#if in the server, get control of player 2 to the other peeer, this function is tree recursive by default
		#get_parent().get_node("Player_01").set_network_master(get_tree().get_network_unique_id())
		get_parent().get_node("Player_02").set_network_master(get_tree().get_network_connected_peers()[0])
	else:		
		#if in the client, give control of player 2 to itself, this function is tree recursive by default				
		get_parent().get_node("Player_02").set_network_master(get_tree().get_network_unique_id())
		#get_parent().get_node("Player_01").set_network_master(get_tree().get_network_connected_peers()[0])
	pass

func _on_player_deliver_box_to_process(player, process, box):
	print("Network master delivers box: ", box, " from ", player, " to ", process);
	
	_deliver_box_to_process_from_player(player, process, box);
	rpc("_deliver_box_to_process_from_player",player, process, box);

func _on_player_ask_box_from_process(player, process):
	var box = get_parent().get_node(process).can_deliver_box()
	print("Player ", player, " asked a box ", box, " from process ", process)
	_deliver_box_to_player_from_process(player, box, process)
	rpc("_deliver_box_to_player_from_process", player, box, process)	

remote func _deliver_box_to_player_from_process(player, box, process):
	if(box != null):
		var boxToDeliver = get_parent().get_node(process).get_node("BoxHolder").get_node(box)
		get_parent().get_node(process).get_node("BoxHolder").call_deferred("remove_child",boxToDeliver);
		get_parent().get_node(process).hasBox = false;
		get_parent().get_node(player).get_node("BoxHolder").call_deferred("add_child",boxToDeliver);
		get_parent().get_node(player).hasBox = true;
	else:
		print("No box found.")
	pass

remote func _deliver_box_to_process_from_player(player, process, box):
	if(box != null && get_parent().get_node(process).processStatus == "ReadyToReceive"):
		var boxToDeliver = get_parent().get_node(player).get_node("BoxHolder").get_node(box);
		get_parent().get_node(player).get_node("BoxHolder").call_deferred("remove_child", boxToDeliver);
		get_parent().get_node(player).hasBox = false;
		get_parent().get_node(process).get_node("BoxHolder").call_deferred("add_child", boxToDeliver);
		get_parent().get_node(process).hasBox = true;
		pass
	else:
		print("No box found.")	
	pass