extends Button

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Button_pressed():
	get_tree().quit()
	_end_game("Server disconnected")
	pass # replace with function body
	
func _end_game(with_error=""):
	if (has_node("/root/bebotParanoia")):
		#erase pong scene
		get_node("/root/bebotParanoia").free() # erase immediately, otherwise network might show errors (this is why we connected deferred above)
		show()
	
	get_tree().set_network_peer(null) #remove peer