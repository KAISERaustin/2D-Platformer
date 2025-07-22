# res://scripts/managers/scene_manager.gd
extends Node

signal scene_changing
signal scene_loaded

@export var fade_layer_path: NodePath = "FadeLayer"
@export var fade_rect_path:  NodePath = "FadeLayer/ColorRect"
@export var fade_duration:   float   = 0.5

@onready var _fade_layer := get_node(fade_layer_path) as CanvasLayer
@onready var _fade_rect  := get_node(fade_rect_path)  as ColorRect

var _next_scene: String    = ""
var previous_scene: String = ""
var is_paused: bool        = false

func _ready() -> void:
	_fade_layer.visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func change_scene(path: String) -> void:
	var cur = get_tree().current_scene
	if cur:
		previous_scene = cur.scene_file_path
	_next_scene = path
	emit_signal("scene_changing")
	_fade_layer.visible = true
	_fade_rect.modulate.a = 0.0
	var tw = create_tween().bind_node(self).set_ignore_time_scale(true)
	tw.tween_property(_fade_rect, "modulate:a", 1.0, fade_duration)
	tw.tween_callback(Callable(self, "_on_fade_out_done"))

func go_back() -> void:
	if is_paused:
		TimeManager.reset()
		is_paused = false
	change_scene(previous_scene)

func _on_fade_out_done() -> void:
	if get_tree().change_scene_to_file(_next_scene) != OK:
		push_error("Couldn’t load: " + _next_scene)
		return
	_fade_rect.modulate.a = 1.0
	var tw = create_tween().bind_node(self).set_ignore_time_scale(true)
	tw.tween_property(_fade_rect, "modulate:a", 0.0, fade_duration)
	tw.tween_callback(Callable(self, "_on_fade_in_done"))

func _on_fade_in_done() -> void:
	_fade_layer.visible = false
	emit_signal("scene_loaded")

func reload_current() -> void:
	TimeManager.reset()
	var cur = get_tree().current_scene.scene_file_path
	change_scene(cur)

func return_mushroom_to_pool(mushroom: CharacterBody2D) -> void:
	mushroom.mushroom_is_dead       = false
	mushroom.visible             = false
	mushroom.velocity            = Vector2.ZERO
	mushroom.direction           = 1
	mushroom.head_hit_check.set_deferred("monitoring", true)
	mushroom.body_check.set_deferred("monitoring", true)
	mushroom.ground_check.set_deferred("disabled", false)
	mushroom.death_timer.stop()
	mushroom.mushroom_kill.stop()
	mushroom.animated_sprite.flip_h = false
	mushroom.animated_sprite.play("default")
	mushroom.set_physics_process(false)
	mushroom.set_process(false)
	PoolManager.free_instance("mushroom", mushroom)
