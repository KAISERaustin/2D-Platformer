# res://scripts/ui/option_menu.gd
extends Control
class_name InGameOptionMenu

@export var enable_mobile_controls_button_path: NodePath = NodePath("BoxContainer/EnableMobileControls")
@export var pause_menu_button_path:              NodePath = NodePath("BoxContainer/Pause Menu")
@export var pause_menu_scene: PackedScene

@onready var enable_mobile_controls_button: Button = get_node(enable_mobile_controls_button_path)
@onready var pause_menu_button:              Button = get_node(pause_menu_button_path)

func _ready() -> void:
	pass

func _on_enable_mobile_controls_pressed() -> void:
	GameManager.toggle_mobile_controls()

func _on_pause_menu_pressed() -> void:
	var menu = pause_menu_scene.instantiate()
	add_child(menu)
	queue_free()
