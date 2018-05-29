extends KinematicBody

export var left=false

var actionLock;
var actionLockTimer;
var hasBox;
var carriedBox;
var color;
var nickName;
var madeMistake;
var collidedBox;
var process;
var player;
var speedMultiplier = 0.250;
onready var camera = get_node("Camera");
onready var interactionRay = get_node("InteractionRay");
onready var carryNode = get_node("PlayerTop");
onready var playerID = 0;
onready var cameraStart = true;

signal ask_box_from_process;


func _ready():
	add_to_group("players");
	hasBox = false;
	carriedBox = null;
	color = [randi() % 255, randi() % 255, randi() % 255];
	playerID = playerID + 1;
	nickName = "";
	madeMistake = false;
	player = self;
	actionLock = false;
	actionLockTimer = 0.0;
	#connect("network_peer_connected",self,"_player_connected")
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
	
		if(hasBox):
			carryNode.get_child(0).set_translation(Vector3(0,1.05,0));
	
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
	print("Player ", get_tree().get_network_unique_id(), " Checking Collision")
	if(interactionRay.is_colliding() and interactionRay.get_collider().get_groups() != null):
		if(!hasBox and interactionRay.get_collider().is_in_group("process") and actionLock == false):
			process = interactionRay.get_collider();
			print("Player ", self, " is emiting signal to process: ", process)
			emit_signal("ask_box_from_process", self, process)
			var box = process.can_deliver_box();
			print(box)
			actionLock = true;
			return;
		#if(hasBox and interactionRay.get_collider().is_in_group("process") and actionLock == false):
		#	process = interactionRay.get_collider();
		#	rpc("deliver_box", process);
		#	actionLock = true;
		#	return;
	pass
