# res://scripts/ui/in_game_option_menu.gd
extends Control

@export var enable_mobile_control_path:  	NodePath = NodePath("BoxContainer/EnableMobileControls")
@export var pause_menu_path:      			NodePath = NodePath("../PauseMenu")

@onready var enable_mobile_control: Button 		= get_node(enable_mobile_control_path)
@onready var pause_menu:      		Control   	= get_node(pause_menu_path)

func _ready() -> void:
	visible = false

func _on_pause_menu_pressed() -> void:
	visible = false
	pause_menu.visible = true

func _on_enable_mobile_controls_pressed() -> void:
	GameManager.toggle_mobile_controls()
