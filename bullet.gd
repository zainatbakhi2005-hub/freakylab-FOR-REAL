extends Area2D

@export var speed: float = 600.0
@export var damage: int = 50
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Connect collision signal safely
	if not is_connected("body_entered", Callable(self, "_on_body_entered")):
		connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta: float) -> void:
	# Move bullet in its assigned direction
	position += direction * speed * delta

	# Remove bullet if it leaves map bounds
	if position.x < 0 or position.y < 0 or position.x > 2048 or position.y > 2048:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Enemies") and body.has_method("take_damage"):
		body.take_damage(damage)
		queue_free()
		return

	# Optional: destroy bullet if it hits walls
	if body.is_in_group("walls"):
		queue_free()
