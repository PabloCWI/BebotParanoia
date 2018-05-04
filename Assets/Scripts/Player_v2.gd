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
onready var interactionRay = get_node("InteractionRay");
onready var carryNode = get_node("PlayerTop");
onready var playerID = 0;

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
	print("Player ID: ", playerID)
	pass
	
slave func set_pos(player_position):
	self.position = player_position;
	pass

func _process(delta):
	
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
	
	rpc_unreliable("set_pos", self.get_position_in_parent())

#MOVEMENT

func check_ray_collision():	
	if(interactionRay.is_colliding() and interactionRay.get_collider().get_groups() != null):
		if(!hasBox and interactionRay.get_collider().is_in_group("process") and actionLock == false):
			process = interactionRay.get_collider();
			request_box(process);
			actionLock = true;
			return;
		if(hasBox and interactionRay.get_collider().is_in_group("process") and actionLock == false):
			process = interactionRay.get_collider();
			deliver_box(process);
			actionLock = true;
			return;
	pass

func set_hasBox(boolStatus):
	hasBox = boolStatus;
	pass

#BOX GET AND DELIVER
func request_box(process):
	if(process.process_status() == "ReadyToDeliver"):
		carriedBox = process.deliver_box_to(player);
		print("This Box: ", carriedBox)
		carryNode.add_child(carriedBox);
		carriedBox.set_translation(Vector3(0,1.05,0));		
	else:
		print("Cannot Deliver Box");

func deliver_box(process):
	if(process.process_status() == "ReadyToReceive"):
		print("This Box: ", carriedBox)
		carryNode.remove_child(carriedBox);
		process.receive_box_from(carriedBox, self);	


	print("Delivered Box");
