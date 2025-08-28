extends CharacterBody2D

@export var speed: float = 200.0
@export var max_health: int = 150
var current_health: int

@onready var anim: AnimatedSprite2D = $kidsprite
@onready var health_bar: ProgressBar = $HealthBar

var is_damaged: bool = false
var damage_display_time: float = 0.3
var damage_timer: float = 0.0

var controls_reversed: bool = false
var flip_timer: float = 0.0
var flip_interval: float = 5.0

# New: mechanics change timer
var mechanic_timer: float = 15.0  # every 15 seconds

func _ready() -> void:
	current_health = max_health
	health_bar.max_value = max_health
	health_bar.value = current_health
	add_to_group("player")
	flip_timer = flip_interval

func _physics_process(delta: float) -> void:
	# Damaged animation timer
	if is_damaged:
		damage_timer -= delta
		if damage_timer <= 0:
			is_damaged = false

	# Control flip timer
	flip_timer -= delta
	if flip_timer <= 0:
		controls_reversed = not controls_reversed
		flip_timer = flip_interval

	# Mechanics timer
	mechanic_timer -= delta
	if mechanic_timer <= 0:
		change_mechanics()
		mechanic_timer = 15.0  # reset timer

	# Movement
	var input_vector := Vector2.ZERO
	if not is_damaged:
		if controls_reversed:
			input_vector.x = Input.get_action_strength("MoveLeft") - Input.get_action_strength("MoveRight")
			input_vector.y = Input.get_action_strength("MoveUp") - Input.get_action_strength("MoveDown")
		else:
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

	# Click to "shoot" enemy
	if Input.is_action_just_pressed("shoot"):
		var mouse_pos = get_global_mouse_position()
		var enemies = get_tree().get_nodes_in_group("Enemies")
		for e in enemies:
			if e.global_position.distance_to(mouse_pos) < 50:
				if e.has_method("take_damage"):
					e.take_damage(1)

# Function called every 15 seconds
func change_mechanics() -> void:
	# Example changes:
	# 1. Randomize speed between 150-250
	speed = randi() % 100 + 150
	# 2. Toggle control flip
	controls_reversed = not controls_reversed
	print("Mechanics changed! Speed:", speed, "Controls reversed:", controls_reversed)

# Player takes damage from enemy
func take_damage(amount: int) -> void:
	current_health -= amount
	if current_health < 0:
		current_health = 0
	health_bar.value = current_health
	is_damaged = true
	damage_timer = damage_display_time
	if current_health <= 0:
		die()

func die() -> void:
	anim.play("die")
	set_physics_process(false)
	await anim.animation_finished
	queue_free()
	#get_tree().change_scene_to_file("res://game_over_01r.tscn")
