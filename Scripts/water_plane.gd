extends MeshInstance3D

@export var boat_wake_origin: Node3D

func _process(delta):
	var wake_origin_posit = boat_wake_origin.transform.origin
	
	get_surface_override_material(0).set_shader_parameter("wake_origin_pos", wake_origin_posit)
	
	#$WaterMesh.material_override.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
