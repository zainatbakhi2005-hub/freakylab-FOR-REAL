extends Node2D

@export var medkit_scene: PackedScene
@export var spawn_points: Array[Node2D] = []
@export var spawn_interval: float = 3.0

var timer: float = 0.0

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		spawn_medkits()
		timer = spawn_interval

func spawn_medkits():
	for point in spawn_points:
		if medkit_scene:
			var medkit = medkit_scene.instantiate()
			get_parent().add_child(medkit)  # add to MainScene
			medkit.global_position = point.global_position
