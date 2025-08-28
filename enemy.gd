extends CharacterBody2D

@export var speed: float = 60.0
@export var damage: int = 10
@export var damage_interval: float = 0.5
@export var max_hits: int = 2

@onready var anim: AnimatedSprite2D = $enemysprite

var player: Node2D = null
var is_touching_player: bool = false
var damage_timer: float = 0.0
var is_dead: bool = false
var current_hits: int = 0

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

	if has_node("Area2D"):
		$Area2D.body_entered.connect(_on_Area2D_body_entered)
		$Area2D.body_exited.connect(_on_Area2D_body_exited)

	add_to_group("Enemies")

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		anim.play("crawl")
		if direction.x < 0:
			anim.flip_h = false
		elif direction.x > 0:
			anim.flip_h = true

	if is_touching_player and player and player.has_method("take_damage"):
		damage_timer -= delta
		if damage_timer <= 0.0:
			player.take_damage(damage)
			damage_timer = damage_interval

# Area2D contact
func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		is_touching_player = true
		damage_timer = 0.0

func _on_Area2D_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		is_touching_player = false

# Hit by player
func take_damage(amount: int) -> void:
	if is_dead:
		return
	current_hits += amount
	anim.play("hurt")
	if current_hits >= max_hits:
		die()

func die() -> void:
	is_dead = true
	anim.play("spiderdie")
	set_physics_process(false)
	set_process(false)
	await anim.animation_finished
	queue_free()
