extends Spatial

signal game_finished()

sync func update_score(add_to_left):
	var game_ended = false
	if (game_ended):
		get_node("exit_game").show()
		
func _on_exit_game_pressed():
	emit_signal("game_finished")

func _ready():
	
	# by default, all nodes in server inherit from master
	# while all nodes in clients inherit from slave
		
	if (get_tree().is_network_server()):		
		#if in the server, get control of player 2 to the other peeer, this function is tree recursive by default
		get_node("Player_01").set_network_master(get_tree().get_network_connected_peers()[0])
	else:
		#if in the client, give control of player 2 to itself, this function is tree recursive by default
		get_node("Player_02").set_network_master(get_tree().get_network_unique_id())
		
	get_node("Player_01").left=true
	get_node("Player_02").left=false
		

func _process(delta):
	pass
	
