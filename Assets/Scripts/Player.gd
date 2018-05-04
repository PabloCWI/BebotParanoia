extends KinematicBody

var hasBox;
var carriedBox;
var color;
var nickName;
var madeMistake;
var collidedBox;
var collider;
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
	pass

func _process(delta):
	
	if(Input.is_action_just_pressed("player_interact")):
		check_ray_collision();
	
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

#MOVEMENT

func check_ray_collision():
	if(!interactionRay.is_colliding() and interactionRay.get_collider().get_groups() != null):
		print("Just Collided With: ", interactionRay.get_collider().get_groups())
		if(!hasBox and interactionRay.is_colliding()):
			if(interactionRay.get_collider().is_in_group("boxes")):
				collider = interactionRay.get_collider();
				get_box(collider);
				return;
		if(hasBox and interactionRay.is_colliding()):
			if(interactionRay.get_collider().is_in_group("process")):
				collider = interactionRay.get_collider();
				deliver_box(collider);
				return;

#BOX GET AND DELIVER
func get_box(collider):
	var parent = collider.get_parent();
	parent.remove_child(collider);
	collider.set_translation(Vector3(0,1.05,0));
	carryNode.add_child(collider);
	carriedBox = collider;
	hasBox = true;

func deliver_box(collider):
	var parent = collider.get_parent();
	carryNode.remove_child(carriedBox);
	collider.add_child(carriedBox);
	carriedBox.set_translation(Vector3(0,1.5,0));
	collider.receive_box(carriedBox, self);
	carriedBox = null;
	hasBox = false;
	
	print("Delivered Box");
