extends MeshInstance3D

@export var trail_length := 30
@export var trail_width := 0.2
@export var source_node_path: NodePath

var points := []
var source_node: Node3D

func _ready():
	source_node = get_node(source_node_path)

func _process(delta):
	# Add new point
	points.append(source_node.global_transform.origin)
	if points.size() > trail_length:
		points.pop_front()

	# Rebuild trail mesh
	var mesh = ImmediateMesh.new()
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)

	for i in range(points.size() - 1):
		var dir = (points[i+1] - points[i]).normalized()
		var side = dir.cross(Vector3.UP).normalized() * trail_width
		mesh.surface_add_vertex(points[i] + side)
		mesh.surface_add_vertex(points[i] - side)

	mesh.surface_end()
	self.mesh = mesh
