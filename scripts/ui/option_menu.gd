# res://scripts/ui/option_menu.gd
extends Control

@export var enable_mobile_controls_path: NodePath = NodePath("BoxContainer/EnableMobileControls")
@export var main_menu_button_path:      NodePath = NodePath("BoxContainer/Main Menu")

@onready var enable_mobile_controls: CheckBox = get_node(enable_mobile_controls_path)
@onready var main_menu_button:       Button   = get_node(main_menu_button_path)

func _ready() -> void:
	# initialize toggle to current state
	# connect signals
	enable_mobile_controls.toggled.connect(_on_mobile_toggled)
	main_menu_button.pressed.connect(_on_main_menu_pressed)

func _on_mobile_toggled(enabled: bool) -> void:
	GameManager.toggle_mobile_controls()

func _on_main_menu_pressed() -> void:
	SceneManager.change_scene("res://scenes/main_menu.tscn")
