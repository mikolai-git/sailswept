extends RigidBody3D

@onready var rudder = $"BoatMesh/Sailboat/Rudder"
@onready var boom = $BoatMesh/Sailboat/Boom

@onready var main = get_tree().get_root().get_node("Main")

# Boat physics
@export var water_level: float = 0.0
@export var buoyancy_force: float = 10.0
@export var forward_force: float = 5
@export var turn_speed_degrees: float = 90.0  # degrees per second

# Sail physics
@export var boom_turn_speed: float = 200
@export var boom_max_angle: float = 90

func _physics_process(delta):
	# Buoyancy
	if global_position.y < water_level:
		var force = Vector3.UP * buoyancy_force
		apply_central_force(force)
		
	# Reduce sideways drift
	var local_velocity = global_transform.basis.inverse() * linear_velocity
	local_velocity.x = lerp(local_velocity.x, 0.0, 1.5 * delta)  # Kill sideways movement
	linear_velocity = global_transform.basis * local_velocity


	# Handle turning
	var turn_input = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	if turn_input != 0:
		# Rotate instantly (or at fixed rate) without physics torque
		var angle_change = turn_input * turn_speed_degrees * delta
		rotate_y(deg_to_rad(angle_change))  # rotate_y expects radians

	# Move forward in the new direction
	var forward_dir = -transform.basis.z.normalized()
	apply_central_force(forward_dir * forward_force)
	

var rudder_angle := 0.0
var rudder_turn_speed := 50.0
var rudder_max_angle := 30.0

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		rudder_angle += rudder_turn_speed * delta
	elif Input.is_action_pressed("ui_right"):
		rudder_angle -= rudder_turn_speed * delta
	else:
		rudder_angle = lerp(rudder_angle, 0.0, 2 * delta)

	rudder_angle = clamp(rudder_angle, -rudder_max_angle, rudder_max_angle)

	rudder.rotation_degrees.z = rudder_angle
	
	if boom == null:
		return
		
	var wind_direction = main.get_wind_direction()
	print("wind_dir: " + str(wind_direction))

	# Transform wind direction to boat’s local space
	var local_wind = global_transform.basis.inverse() * wind_direction
	print("local_wind: " + str(local_wind))
	
	# Compute target angle (in degrees) in the local XZ plane
	var target_angle = rad_to_deg(atan2(local_wind.x, local_wind.z))
	
	
	print("tar: " + str(target_angle))

	# Clamp to realistic boom swing limits
	target_angle = clamp(target_angle, -boom_max_angle, boom_max_angle)

	# Smoothly rotate the boom toward the target
	var current_angle = boom.rotation_degrees.y
	print("cur: " + str(current_angle))
	
	boom.rotation_degrees.y = target_angle
		

	var angle_diff = wrapf(target_angle - current_angle, -180, 180)
	var step = clamp(angle_diff, -boom_turn_speed * delta, boom_turn_speed * delta)
	boom.rotation_degrees.y = current_angle + step


	
