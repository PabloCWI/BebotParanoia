
extends Control

const DEFAULT_PORT = 8910  # some random number, pick your port properly
onready var GAME_IP = "127.0.0.1"
onready var PLAYER_CHOOSEN_COLOR;
onready var DEFAULT_COLOR_WHITE = Color(1.0,1.0,1.0,1.0);

#### Network callbacks from SceneTree ####

# callback from SceneTree
func _player_connected(id):
	#someone connected, start the game!
	var bebotParanoia = load("res://Assets/Scenes/Level.tscn").instance()
	bebotParanoia.connect("game_finished",self,"_end_game",[],CONNECT_DEFERRED) # connect deferred so we can safely erase it from the callback
	
	get_tree().get_root().add_child(bebotParanoia)
	
	_set_player_info(PLAYER_CHOOSEN_COLOR)
	
	hide()

func _set_player_info(color):	
	get_tree().get_root().get_node("Level").get_node("NetworkMaster").set_player_info(color);
	pass

func _player_disconnected(id):
	get_tree().quit()

	if (get_tree().is_network_server()):
		_end_game("Client disconnected")
	else:
		_end_game("Server disconnected")

# callback from SceneTree, only for clients (not server)
func _connected_ok():
	# will not use this one
	pass
	
# callback from SceneTree, only for clients (not server)	
func _connected_fail():

	_set_status("Couldn't connect",false)
	
	get_tree().set_network_peer(null) #remove peer
	
	get_node("Start_Button").set_disabled(false)		

func _server_disconnected():
	get_tree().quit()
	_end_game("Server disconnected")
	
##### Game creation functions ######

func _end_game(with_error=""):
	if (has_node("/root/bebotParanoia")):
		#erase pong scene
		get_node("/root/bebotParanoia").free() # erase immediately, otherwise network might show errors (this is why we connected deferred above)
		show()
	
	get_tree().set_network_peer(null) #remove peer
	
	get_node("Start_Button").set_disabled(false)	
	
	_set_status(with_error,false)

func _set_status(text,isok):
	#simple way to show status		
	if (isok):
		get_node("Connection_Status_Ok").set_text(text)
		get_node("Connection_Status_Error").set_text("")
	else:
		get_node("Connection_Status_Ok").set_text("")
		get_node("Connection_Status_Error").set_text(text)

func _on_Start_Button_pressed():
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = host.create_server(DEFAULT_PORT,1) # max: 1 peer, since it's a 2 players game
	if (err!=OK):
		#is another server running?
		_set_status("Can't host, address in use.",false)
		join_server();
		return
	get_tree().set_network_peer(host)
	_set_status("Waiting for player..",true)

func join_server():
	if (not GAME_IP.is_valid_ip_address()):
		_set_status("IP address is invalid",false)
		return	
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	host.create_client(GAME_IP,DEFAULT_PORT)
	get_tree().set_network_peer(host)
	
	_set_status("Connecting..",true)

### INITIALIZER ####
	
func _ready():
	# set default color picker color
	get_node("ColorPickerButton").color = DEFAULT_COLOR_WHITE;
	# connect all the callbacks related to networking
	get_tree().connect("network_peer_connected",self,"_player_connected")
	get_tree().connect("network_peer_disconnected",self,"_player_disconnected")
	get_tree().connect("connected_to_server",self,"_connected_ok")
	get_tree().connect("connection_failed",self,"_connected_fail")
	get_tree().connect("server_disconnected",self,"_server_disconnected")
	


func _on_ColorPickerButton_color_changed(color):
	PLAYER_CHOOSEN_COLOR = color;	
	pass # replace with function body
