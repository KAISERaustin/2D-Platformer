# res://scripts/managers/game_manager.gd
extends Node

var mobile_controls_enabled = false
var _last_show_controls: bool = false

@export var player_path: NodePath = NodePath("Player")
signal score_changed(new_score)
signal player_died

var score: int = 0

func _ready() -> void:
	TimeManager.reset()
	process_mode = Node.PROCESS_MODE_ALWAYS	
	PoolManager.reset_all_pools()
	if not PoolManager.has_pool("Coin"):
		PoolManager.register_pool("Coin", preload("res://scenes/coin.tscn"), 20)
	if not PoolManager.has_pool("Mushroom"):
		PoolManager.register_pool("Mushroom", preload("res://scenes/mushroom_enemy.tscn"), 10)
		
func _process(_delta: float) -> void:
	var cur = get_tree().current_scene
	var show_controls = false
	
	if cur and mobile_controls_enabled:
		show_controls = cur.scene_file_path == "res://scenes/New Environment/NewEnvironment.tscn"
		
	if show_controls != _last_show_controls:
		MobileControls._on_mobile_controls_toggled(show_controls)
		_last_show_controls = show_controls

func add_point() -> void:
	score += 1
	emit_signal("score_changed", score)

func make_player_jump() -> void:
	var scene = get_tree().current_scene
	if scene and scene.has_node(player_path):
		var p = scene.get_node(player_path)
		if p is CharacterBody2D:
			p.landed_on_enemy_slime()
		else:
			push_error("GameManager: node at '%s' is not a CharacterBody2D" % player_path)
	else:
		push_error("GameManager: could not find Player at '%s' in current scene" % player_path)

func handle_player_death() -> void:
	emit_signal("player_died")
	
func toggle_mobile_controls() -> void:
	mobile_controls_enabled = !mobile_controls_enabled
	print("Mobile controls now:", mobile_controls_enabled)
	
func enable_double_jump() -> void:
	var scene = get_tree().current_scene
	if scene and scene.has_node(player_path):
		var p = scene.get_node(player_path)
		if p is CharacterBody2D:
			p.base_jumps += 1
			
func enable_dash() -> void:
	var scene = get_tree().current_scene
	if scene and scene.has_node(player_path):
		var p = scene.get_node(player_path)
		if p is CharacterBody2D:
			p.dash_active = true
