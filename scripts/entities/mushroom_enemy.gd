# res://scripts/entities/mushroom_enemy.gd
#
# A Goomba‐style enemy that:
#  • Patrols back and forth (walls & other mushrooms)
#  • Dies when stomped
#  • Uses physics‐based movement & collisions
#
# Author: Your Name

extends CharacterBody2D

const SPEED = 30  # Horizontal speed in pixels/sec
const WALL_THRESHOLD = 0.87

# ── Exported NodePaths ───────────────────────────────────────────────────────
@export var head_hit_check_path:   NodePath = NodePath("HeadHitCheck")
@export var body_check_path:       NodePath = NodePath("BodyCheck")
@export var ground_check_path:     NodePath = NodePath("GroundCheck")
@export var animated_sprite_path:  NodePath = NodePath("AnimatedSprite2D")
@export var mushroom_kill_path:    NodePath = NodePath("MushroomKill")
@export var death_timer_path:      NodePath = NodePath("DeathTimer")

# ── Onready References ───────────────────────────────────────────────────────
@onready var head_hit_check:   Area2D              = get_node(head_hit_check_path)
@onready var body_check:       Area2D              = get_node(body_check_path)
@onready var ground_check:     CollisionShape2D    = get_node(ground_check_path)
@onready var animated_sprite:  AnimatedSprite2D    = get_node(animated_sprite_path)
@onready var mushroom_kill:    AudioStreamPlayer2D = get_node(mushroom_kill_path)
@onready var death_timer:      Timer               = get_node(death_timer_path)

@onready var game_manager:     Node                = GameManager
@onready var scene_manager:    Node                = SceneManager

# ── State ────────────────────────────────────────────────────────────────────
var mushroom_is_dead: bool = false
var direction:       int  = 1  # -1 = left, +1 = right

func _ready() -> void:
	head_hit_check.area_entered.connect(_on_head_hit_check_area_entered)
	death_timer.timeout.connect(_on_death_timer_timeout)

func _physics_process(delta: float) -> void:
	if mushroom_is_dead:
		return

	# ── Movement setup ─────────────────────────────────────────────
	velocity.x = direction * SPEED
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	else:
		velocity.y = 0

	# ── Move & slide ────────────────────────────────────────────────
	move_and_slide()

	# ── 1) Simple wall check ────────────────────────────────────────
	if is_on_wall():
		direction = -direction
		animated_sprite.flip_h = direction < 0
		return  # no need to do slide‐collision loop this frame

	# ── 2) Slide‐collision fallback ─────────────────────────────────
	# (catches other kinematic bodies you might bump into)
	for i in range(get_slide_collision_count()):
		var col = get_slide_collision(i)
		var nx = col.get_normal().x
	# velocity.x * nx < 0 still guards against flipping twice
		if abs(nx) > WALL_THRESHOLD and velocity.x * nx < 0:
			direction = -direction
			animated_sprite.flip_h = direction < 0
			break

func _on_head_hit_check_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		game_manager.make_player_jump()
		mushroom_kill.play()
		mushroom_is_dead = true

		# Disable all sensors & collisions
		head_hit_check.set_deferred("monitoring", false)
		body_check.set_deferred("monitoring", false)
		ground_check.set_deferred("disabled", true)

		animated_sprite.play("Death")
		death_timer.start()

func _on_death_timer_timeout() -> void:
	scene_manager.return_mushroom_to_pool(self)
