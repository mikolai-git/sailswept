extends Node3D  # or Camera3D if you're using the camera node directly

@export var boat_path: NodePath
var boat: Node3D

func _ready():
	boat = get_node(boat_path)

func _process(delta):
	if boat:
		# Copy boat position (center camera on boat), but keep camera rotation fixed
		global_position.x = boat.global_position.x
		global_position.z = boat.global_position.z
