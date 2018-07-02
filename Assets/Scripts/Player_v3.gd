extends KinematicBody

export var left=false

var actionLock;
var actionLockTimer;
var hasBox;
var currentBox;
var color;
var nickName;
var madeMistake;
var collidedBox;
var process;
var player;
var playerUNID;
var speedMultiplier = 0.250;
onready var camera = get_node("Camera");
onready var interactionRay = get_node("InteractionRay");
onready var boxHolder = get_node("BoxHolder");
onready var playerID = 0;
onready var cameraStart = true;
onready var nwMaster = get_parent().get_node("NetworkMaster");
onready var player01Material = preload("res://Assets/Models/Textures/BoxMaterialPlayer01.tres")
onready var player02Material = preload("res://Assets/Models/Textures/BoxMaterialPlayer02.tres")

signal ask_box_from_process(player, process);
signal deliver_box_to_process(player, process);


func _ready():	
	add_to_group("players");
	hasBox = false;
	currentBox = null;
	color = [randi() % 255, randi() % 255, randi() % 255];
	playerID = playerID + 1;
	nickName = "";
	madeMistake = false;
	player = self;
	playerUNID = get_tree().get_network_unique_id();
	actionLock = false;
	actionLockTimer = 0.0;
	player.connect("ask_box_from_process", nwMaster, "_on_player_ask_box_from_process")
	player.connect("deliver_box_to_process", nwMaster, "_on_player_deliver_box_to_process")
	pass

func _set_player_color(target):
	if(target == "Player_01"):
		self.get_node("MeshInstance").set_surface_material(0, player01Material);
	if(target == "Player_02"):
		self.get_node("MeshInstance").set_surface_material(0, player02Material);
	pass

sync func set_pos(player_position):
	transform = player_position;
	pass

func _process(delta):
	if(is_network_master()):
		if(cameraStart):
			camera.make_current();
			cameraStart = false;
		loop(delta)
		rpc_unreliable("set_pos", transform)

func loop(delta):
	if(is_network_master()):
		if(Input.is_action_just_pressed("player_interact") and actionLock == false):
			check_ray_collision();		
	
		if(actionLock == true):
			actionLockTimer = actionLockTimer + delta;
			if(actionLockTimer > 0.5):
				actionLockTimer = 0.0;
				actionLock = false;
			
			pass
	
		#KEY DETECTION
		if(Input.is_action_pressed("player_move_right")):
			move_and_collide(Vector3(1.0 * speedMultiplier, 0, 0));

		if(Input.is_action_pressed("player_move_left")):
			move_and_collide(Vector3(-1.0 * speedMultiplier, 0, 0));

		if(Input.is_action_pressed("player_move_forward")):
			move_and_collide(Vector3(0, 0, -1.0 * speedMultiplier))

		if(Input.is_action_pressed("player_move_backward")):
			move_and_collide(Vector3(0, 0, 1.0 * speedMultiplier))
	
	pass

func check_ray_collision():	
	if(interactionRay.is_colliding() and interactionRay.get_collider().get_groups() != null):
		if(!hasBox and interactionRay.get_collider().is_in_group("process") and actionLock == false):
			process = interactionRay.get_collider().get_name();
			emit_signal("ask_box_from_process", self.get_name(), process);
			return;
		
		if(hasBox and interactionRay.get_collider().is_in_group("process") and actionLock == false):
			process = interactionRay.get_collider().get_name();
			emit_signal("deliver_box_to_process", self.get_name(), process, boxHolder.get_child(0).get_name());
			return;
		actionLock = true;
	pass


