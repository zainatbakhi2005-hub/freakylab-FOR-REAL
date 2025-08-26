extends CharacterBody2D

@export var speed: float = 200.0
@export var max_health: int = 150
var current_health: int

@onready var anim: AnimatedSprite2D = $kidsprite
@onready var health_bar: ProgressBar = $HealthBar

var is_damaged: bool = false
var damage_display_time: float = 0.3 # seconds to show damaged animation
var damage_timer: float = 0.0

func _ready() -> void:
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health
	add_to_group("player") # enemies can find this group

func _physics_process(delta: float) -> void:
	# Handle damaged animation timer
	if is_damaged:
		damage_timer -= delta
		if damage_timer <= 0:
			is_damaged = false

	# Movement input (only if not dead or damaged)
	var input_vector := Vector2.ZERO
	if not is_damaged:
		input_vector.x = Input.get_action_strength("MoveRight") - Input.get_action_strength("MoveLeft")
		input_vector.y = Input.get_action_strength("MoveDown") - Input.get_action_strength("MoveUp")
		input_vector = input_vector.normalized()

		velocity = input_vector * speed
		move_and_slide()

	# Animation
	if is_damaged:
		anim.play("damaged")
	else:
		if input_vector == Vector2.ZERO:
			anim.play("idle")
		else:
			anim.play("walk")
			if input_vector.x < 0:
				anim.flip_h = true
			elif input_vector.x > 0:
				anim.flip_h = false

# Player taking damage
func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health < 0:
		current_health = 0

	health_bar.value = current_health
	print("Player health: ", current_health)

	# Play damaged animation
	is_damaged = true
	damage_timer = damage_display_time

	if current_health <= 0:
		die()

func die() -> void:
	anim.play("die")
	set_physics_process(false) # stop movement
	await anim.animation_finished
	queue_free()
