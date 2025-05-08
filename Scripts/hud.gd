extends SubViewport

@onready var arrow = $WindArrow
@onready var main = get_tree().get_root().get_node("Main")

	
func _process(_delta):
	var wind_dir = main.wind_direction.normalized()
	var target_position = arrow.global_transform.origin + wind_dir
	arrow.look_at(target_position, Vector3.UP)
