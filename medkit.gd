extends Area2D

@export var heal_amount: int = 30  # updated to 30 points

func _ready() -> void:
	# Connect signal so it works automatically
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node2D) -> void:
	# Check if the thing that touched is the player
	if body.is_in_group("player"):
		# Call player's take_damage with negative = heal
		if body.has_method("take_damage"):
			body.take_damage(-heal_amount)
			# Make sure health doesn't exceed max_health
			if body.current_health > body.max_health:
				body.current_health = body.max_health
				body.health_bar.value = body.current_health
		queue_free()  # remove medkit after pickup
