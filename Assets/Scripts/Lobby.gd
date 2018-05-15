extends Control

const PORT = 8910 # some random number, pick your port properly

#### Network callbacks from SceneTree ####

var player_bot = null;
var players = [];

# callback from SceneTree
func _player_connected(id):
	#someone connected, start the game!
	var bebotParanoia = load("res://Assets/Scenes/Level.tscn").instance()
	bebotParanoia.connect("game_finished",self,"_end_game",[],CONNECT_DEFERRED) # connect deferred so we can safely erase it from the callback
	
	get_node("Main Menu").free()
	get_tree().get_root().add_child(bebotParanoia)
	hide()

func _player_disconnected(id):

	if (get_tree().is_network_server()):
		_end_game("Client disconnected")
	else:
		_end_game("Server disconnected")

func _connected_fail():

	_set_status("Couldn't connect",false)
	
	get_tree().set_network_peer(null) #remove peer
	
	get_node("panel/join").set_disabled(false)
	get_node("panel/host").set_disabled(false)

func _server_disconnected():
	_end_game("Server disconnected")
	
##### Game creation functions ######

func _end_game(with_error=""):
	if (has_node("/root/bebotParanoia")):
		#erase pong scene
		get_node("/root/bebotParanoia").free() # erase immediately, otherwise network might show errors (this is why we connected deferred above)
		show()
	
	get_tree().set_network_peer(null) #remove peer
	
	get_node("panel/join").set_disabled(false)
	get_node("panel/host").set_disabled(false)
	
	_set_status(with_error,false)

func _set_status(text,isok):
	#simple way to show status		
	if (isok):
		get_node("panel/status_ok").set_text(text)
		get_node("panel/status_fail").set_text("")
	else:
		get_node("panel/status_ok").set_text("")
		get_node("panel/status_fail").set_text(text)

func _on_host_pressed():
	
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = host.create_server(PORT,1) # max: 1 peer, since it's a 2 players game
	if (err!=OK):
		#is another server running?
		_set_status("Can't host, address in use.",false)
		return
	get_tree().set_network_peer(host)
	get_node("panel/join").set_disabled(true)
	get_node("panel/host").set_disabled(true)
	_set_status("Waiting for player..",true)
	_connected_ok()
	pass

func _connected_ok():
	rpc("register_player", get_tree().get_network_unique_id())
	register_player(get_tree().get_network_unique_id())
	get_tree().get_root().get_node("Lobby").queue_free()
	pass # replace with function body

remote func register_player(player_id):
	var p = player_bot.instance()
	p.set_network_master(player_id)
	p.name = str(player_id)
	get_tree().get_root().add_child(p);
	if (get_tree().get_network_unique_id() == 1):
		if (player_id != 1):
			for i in players:
				rpc_id(player_id, "register_player", i)
		players.append(player_id);
	pass


func _on_join_pressed():
	
	var ip = get_node("panel/address").get_text()
	if (not ip.is_valid_ip_address()):
		_set_status("IP address is invalid",false)
		return
	
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	host.create_client(ip,PORT)
	get_tree().set_network_peer(host)
	
	_set_status("Connecting..",true)

### INITIALIZER ####
	
func _ready():
	player_bot = preload("res://Assets/Models/Objects/Player.tscn")
	# connect all the callbacks related to networking
	get_tree().connect("network_peer_connected",self,"_player_connected")
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
	get_tree().connect("connected_to_server",self,"_connected_ok")
	get_tree().connect("connection_failed",self,"_connected_fail")
	get_tree().connect("server_disconnected",self,"_server_disconnected")
	
