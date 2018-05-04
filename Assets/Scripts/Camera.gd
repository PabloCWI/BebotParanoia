
extends Camera

# Member variables
var collision_exception = []
export var min_distance = 0.5
export var max_distance = 4.0
export var angle_v_adjust = 0.0
export var autoturn_ray_aperture = 25
export var autoturn_speed = 50
var max_height = 2.0
var min_height = 0

func _physics_process(dt):
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var up = Vector3(0, 1, 0)
	
	var delta = pos - target
	
	# Regular delta follow
		
	# Apply lookat
	if (delta == Vector3()):
		delta = (pos - target).normalized()*0.0001

	pos = target + delta
	
	look_at_from_position(pos, target, up)
	
	# Turn a little up or down
	var t = get_transform()
	t.basis = Basis(t.basis[0], deg2rad(angle_v_adjust))*t.basis
	set_transform(t)


func _ready():
	# Find collision exceptions for ray
	set_physics_process(true)
	# This detaches the camera transform from the parent spatial node
	set_as_toplevel(true)
