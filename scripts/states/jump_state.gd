# res://scenes/jump_state.gd
#
# Purpose:
#   Handles the player's jump state: applies the initial jump impulse,
#   allows limited mid-air horizontal control, clamps maximum jump height,
#   applies gravity, detects landing to transition back to idle,
#   and supports variable jump height via a short-hop mechanic.
# Author: Your Name

extends Node
class_name JumpState

# ── Exported Configuration ────────────────────────────────────────────────────
@export var jump_noise_path     : NodePath = NodePath("JumpNoise")     # NodePath to the jump sound effect
@export var jump_cut_multiplier : float    = 0.5                       # Multiplier to cut upward velocity on jump release
@export var max_jump_height     : float    = 240.0                     # Maximum rise (in pixels) before forcing descent

# ── Onready References ───────────────────────────────────────────────────────
@onready var jump_noise         : AudioStreamPlayer2D = get_node(jump_noise_path)

# ── Internal State ───────────────────────────────────────────────────────────
var _start_y : float    # Records the player's Y position at jump start

func enter(player_node) -> void:
	# Called once when entering the JumpState.
	# 1) Record the player's starting global Y position for height clamping.
	_start_y = player_node.global_position.y
	player_node.animated_sprite.play("jumping")
	# 2) Trigger the jump impulse on the player.
	player_node.perform_jump()
	# 3) Play the jump sound effect.
	jump_noise.play()

func physics_process(player_node, delta: float) -> void:
	# Main physics loop for jump behavior.

	# 1) Optional horizontal air control: adjust X velocity toward input direction.
	var dir = Input.get_axis("move_left", "move_right")
	if dir != 0:
		var target = dir * player_node.SPEED
		var accel = player_node.ACCELERATION * delta
		player_node.velocity.x = move_toward(player_node.velocity.x, target, accel)
		# Flip the sprite when moving left.
		player_node.animated_sprite.flip_h = dir < 0

	# 2) Clamp maximum jump height: if rising past max_jump_height, zero out upward velocity.
	if player_node.velocity.y < 0:
		var risen = _start_y - player_node.global_position.y
		if risen >= max_jump_height:
			player_node.velocity.y = 0

	# 3) Apply gravity and perform collision-aware movement.
	player_node.velocity += player_node.get_gravity() * delta
	player_node.move_and_slide()

	# 4) Landing detection: when back on floor and not moving upward, reset jumps and switch to IdleState.
	if player_node.is_on_floor() and player_node.velocity.y >= 0:
		player_node.reset_jumps()
		player_node.state_machine.enter_state(player_node.idle_state_scene)

func input(player_node, event) -> void:
	# Handles input events during the jump state.

	# a) Mid-air jump: allow extra jump if jumps remain.
	if event.is_action_pressed("jump") and player_node.jumps_remaining > 0:
		player_node.perform_jump()
		jump_noise.play()
		return

	# b) Short-hop cut: if player releases jump early while still rising,
	#    reduce upward velocity by jump_cut_multiplier.
	if event.is_action_released("jump") and player_node.velocity.y < 0:
		player_node.velocity.y *= jump_cut_multiplier

func exit(_player_node) -> void:
	# Called once when exiting the JumpState.
	# No cleanup required for this state.
	pass
