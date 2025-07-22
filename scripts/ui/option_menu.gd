# res://scripts/ui/option_menu.gd
extends Control

@export var enable_mobile_controls_path: NodePath = NodePath("BoxContainer/EnableMobileControls")
@export var main_menu_button_path:      NodePath = NodePath("BoxContainer/Main Menu")

@onready var enable_mobile_controls: Button 	= get_node(enable_mobile_controls_path)
@onready var main_menu_button:       Button   	= get_node(main_menu_button_path)

func _on_main_menu_pressed() -> void:
	SceneManager.change_scene("res://scenes/main_menu.tscn")

func _on_enable_mobile_controls_pressed() -> void:
	GameManager.toggle_mobile_controls()
