extends Node3D

@export var wind_direction := Vector3.ZERO

func get_wind_direction() -> Vector3:
	return wind_direction
	

var wind_label := ""

func _ready():
	randomize()  # Ensures better randomness
	$WindTimer.timeout.connect(wind_logic)
	$WindTimer.start()
	
	wind_direction = Vector3(0, 0, -1)


func wind_logic():
	var random = randi() % 2

	match random:

		0:
			wind_direction = Vector3(0, 0, 1)
			wind_label = "South"
		1:
			wind_direction = Vector3(-1, 0, 0)
			wind_label = "West"
	
	#print("Wind changed to: %s (%s)" % [wind_label, wind_direction])
