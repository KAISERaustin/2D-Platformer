# res://scenes/idle_state.gd
#
# Purpose:
#   Idle state for the player: decelerates horizontal movement,
#   applies gravity when airborne, and handles transitions to run or jump.
# Author: Your Name

extends Node
class_name IdleState

func enter(_player_node) -> void:
	# Called once when the player enters the idle state.
	# Use this to reset any state-specific flags or play an idle sound, if desired.
	_player_node.animated_sprite.play("idle")
	pass

func exit(_player_node) -> void:
	# Called once when the player exits the idle state.
	# Clean up or stop state-specific effects here.
	pass

func physics_process(player_node, delta: float) -> void:
	
	# 1) Read horizontal input axis: -1 for left, +1 for right, 0 for none
	var dir = Input.get_axis("move_left", "move_right")

	# 2) We want to come to a stop in idle: target velocity is 0
	var target = 0.0

	# 3) Compute how much to decelerate this frame
	var decel_rate = player_node.DECELERATION * delta

	# 4) Smoothly move current velocity.x toward zero
	player_node.velocity.x = move_toward(player_node.velocity.x, target, decel_rate)

	# 5) If the player is in the air, apply gravity each frame
	if not player_node.is_on_floor():
		player_node.velocity += player_node.get_gravity() * delta

	# 6) If the player presses left or right, switch to the run state
	if dir != 0:
		player_node.state_machine.enter_state(player_node.run_state_scene)

	# 7) Perform movement and slide along collisions
	player_node.move_and_slide()

func input(_player_node, _event) -> void:
	# Listen for jump input while idling
	if _event.is_action_pressed("jump") and _player_node.is_on_floor():
		# Transition to the jump state to handle jump logic
		_player_node.state_machine.enter_state(_player_node.jump_state_scene)
