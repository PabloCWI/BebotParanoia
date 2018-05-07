extends Spatial

var main_menu = preload("res://Assets/Scenes/Main Menu.tscn");

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	get_tree().change_scene(main_menu);
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
