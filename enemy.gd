extends CharacterBody2D

@export var speed: float = 60.0
@export var damage: int = 10
@export var damage_interval: float = 0.5 # seconds between hits

@onready var anim: AnimatedSprite2D = $enemysprite

var player: Node2D = null
var is_touching_player: bool = false
var damage_timer: float = 0.0
var is_dead: bool = false

func _ready() -> void:
	# Find the player
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

	# Connect Area2D signals
	$Area2D.body_entered.connect(_on_Area2D_body_entered)
	$Area2D.body_exited.connect(_on_Area2D_body_exited)

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if player:
		# Move toward player using velocity so collisions work
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

		# Play crawl animation
		anim.play("crawl")

		# Flip sprite based on direction
		if direction.x < 0:
			anim.flip_h = false
		elif direction.x > 0:
			anim.flip_h = true

	# Deal continuous damage if touching player
	if is_touching_player and player and player.has_method("take_damage"):
		damage_timer -= delta
		if damage_timer <= 0.0:
			player.take_damage(damage)
			damage_timer = damage_interval

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		is_touching_player = true
		damage_timer = 0.0

func _on_Area2D_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		is_touching_player = false

func take_damage(amount: int) -> void:
	if is_dead:
		return
	# add health/damage logic if needed

func die() -> void:
	is_dead = true
	anim.play("spiderdie")
	set_physics_process(false)
	set_process(false)
	await anim.animation_finished
	queue_free()
