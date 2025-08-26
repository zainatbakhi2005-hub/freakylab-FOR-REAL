extends Node2D

# ✅ Preload enemy scene so you never have to drag it in the inspector
@export var enemy_scene: PackedScene = preload("res://Enemy.tscn")
@export var spawn_interval: float = 1.5  # seconds per spawn

func _ready() -> void:
	if enemy_scene == null:
		push_warning("EnemySpawner: enemy_scene not set!")
		return

	# Collect spawn points (Node2D children under this spawner)
	var spawn_points: Array[Node2D] = []
	for child in get_children():
		if child is Node2D and not child is Timer:
			spawn_points.append(child)

	print("EnemySpawner ready with %d spawn points" % spawn_points.size())

	# Create a timer for each spawn point
	for spawn_point in spawn_points:
		var t := Timer.new()
		t.wait_time = spawn_interval
		t.one_shot = false
		t.autostart = true
		add_child(t)
		# Godot 4.4: bind the spawn_point so the timer knows where to spawn
		t.timeout.connect(Callable(self, "_spawn_enemy").bind(spawn_point))

# Called every time a spawn point timer triggers
func _spawn_enemy(spawn_point: Node2D) -> void:
	if enemy_scene == null:
		return
	var enemy := enemy_scene.instantiate()
	enemy.position = spawn_point.position   # ✅ use local position relative to spawner
	add_child(enemy)  # spawn under spawner node
	print("Spawned enemy at ", enemy.global_position)
