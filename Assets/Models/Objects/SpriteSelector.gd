extends Sprite

onready var spriteP1 = preload("res://Assets/Models/Textures/TagP1.png");
onready var spriteP2 = preload("res://Assets/Models/Textures/TagP2.png");

func _ready():
	if(get_parent().get_name() == "Process_01"):
		self.texture = spriteP1;
	else:
		self.texture = spriteP2;
	pass

func _process(delta):
	var pos = get_parent().get_translation();
	var cam = get_tree().get_root().get_camera();
	var screenos = cam.unprojected_position(pos);
	self.set_pos(Vector2(screenPos.x, screenPos.y-80))
	pass