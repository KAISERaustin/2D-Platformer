# res://scenes/run_state.gd
#
# Purpose:
#   Handles the player's run state: accelerates or decelerates horizontal movement,
#   applies gravity when airborne, flips the sprite based on movement direction,
#   and transitions back to idle or into jump when appropriate.
# Author: Your Name

extends Node
class_name RunState

func enter(_player_node) -> void:
	# Called once when entering the run state.
	# Use to reset flags or play a running sound if desired.
	_player_node.animated_sprite.play("run")
	pass

func exit(_player_node) -> void:
	# Called once when exiting the run state.
	# Clean up or stop run-specific effects here.
	pass

func physics_process(player_node, delta: float) -> void:
	# 1) Read horizontal input: -1 (left), +1 (right), or 0 (none)
	var dir = Input.get_axis("move_left", "move_right")
	# 2) Determine target velocity based on input direction and player speed
	var target = dir * player_node.SPEED
	# 3) Choose acceleration when input exists, otherwise deceleration
	var accel_rate = (player_node.ACCELERATION * delta) if abs(target) > 0.1 else (player_node.DECELERATION * delta)
	# 4) Move current velocity.x toward the target velocity
	player_node.velocity.x = move_toward(player_node.velocity.x, target, accel_rate)
	# 5) Flip the sprite horizontally if running left
	player_node.animated_sprite.flip_h = dir < 0
	# 6) If in the air, apply gravity each frame
	if not player_node.is_on_floor():
		player_node.velocity += player_node.get_gravity() * delta
	# 7) If no horizontal input, switch back to the idle state
	if dir == 0:
		player_node.state_machine.enter_state(player_node.idle_state_scene)
	# 8) Perform the movement and slide along collisions
	player_node.move_and_slide()

func input(_player_node, _event) -> void:
	# a) Handle jump input while running
	if _event.is_action_pressed("jump") and _player_node.is_on_floor():
		# Transition to the jump state to handle jump logic
		_player_node.state_machine.enter_state(_player_node.jump_state_scene)
