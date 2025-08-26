extends Node2D

@export var enemy_scene: PackedScene        # assign Enemy.tscn in inspector
@export var spawn_interval: float = 1.5

func _ready() -> void:
	if enemy_scene == null:
		push_warning("EnemySpawner: enemy_scene is not assigned in inspector.")
		return

	# gather spawn points (all Node2D children under this spawner)
	var spawn_points: Array[Node2D] = []
	for child in get_children():
		if child is Node2D and not child is Timer:
			spawn_points.append(child)

	print("EnemySpawner ready: %d spawn points" % spawn_points.size())

	# set up a timer for each spawn point
	for spawn_point in spawn_points:
		var t := Timer.new()
		t.wait_time = spawn_interval
		t.one_shot = false
		t.autostart = true
		add_child(t)
		t.timeout.connect(Callable(self, "_on_spawn_timer_timeout").bind(spawn_point))

func _on_spawn_timer_timeout(spawn_point: Node2D) -> void:
	if enemy_scene == null:
		return
	var enemy := enemy_scene.instantiate()
	enemy.global_position = spawn_point.global_position
	get_tree().current_scene.add_child(enemy)
	print("Spawned enemy at ", spawn_point.global_position)
