extends Node

var playerObject = load("res://Assets/Models/Objects/Player.tscn")

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
	botP2.translate(Vector3(-5,0.5,5))
	
	call_deferred("_set_players_on_network")

func _set_players_on_network():
	if (get_tree().is_network_server()):				
		#if in the server, get control of player 2 to the other peeer, this function is tree recursive by default
		#get_parent().get_node("Player_01").set_network_master(get_tree().get_network_unique_id())
		get_parent().get_node("Player_02").set_network_master(get_tree().get_network_connected_peers()[0])
	else:		
		#if in the client, give control of player 2 to itself, this function is tree recursive by default		
		get_parent().get_node("Player_02").set_network_master(get_tree().get_network_unique_id())
		#get_parent().get_node("Player_01").set_network_master(get_tree().get_network_connected_peers()[0])
	pass

func _on_player_deliver_box_to_process(player, box, process):
	pass

func _on_player_ask_box_from_process(player, process):
	#print("NetPlayer: ", player, " asked for a box from: ", process)
	var box = rpc("get_box_from_process", process);
	print("NetPlayer: ", player, " asked for a box: ", box, " from: ", process)
	rpc("_deliver_box_to_player_from_process", player, box, process)
	pass

sync func get_box_from_process(process):
	var box = process.can_deliver_box();
	if (box != null):
		print("Process:", process, " can deliver box: ", box)
		return box;
	else:
		print("Process: ", process, " cannot deliver box.")
		return null;
	pass

sync func _deliver_box_to_player_from_process(player, box, process):
	print("Network master delivers box: ", box, " from process", process)
	process.remove_child(box);
	player.get_node("PlayerTop").add_child(box);
	pass

sync func _deliver_box_to_process_from_player(player, box, process):
	pass



func _on_Player_01_ask_box_from_process(player, process):
	print("NetPlayer: ", player, " asked for a box from: ", process)
	#var box = get_box_from_process(process);
	#rpc("_deliver_box_to_player_from_process", player, box, process)
	pass
