# res://scripts/ui/game_ui.gd
extends CanvasLayer

@export var pause_button_path: NodePath = NodePath("VBoxContainer/PauseButton")
@export var pause_menu_path:   NodePath = NodePath("PauseMenu")

@onready var pause_button: Button  = get_node(pause_button_path)
@onready var pause_menu:   Control = get_node(pause_menu_path)

func _ready() -> void:
	pause_button.pressed.connect(_on_pause_pressed)

func _on_pause_pressed() -> void:
	get_tree().paused = true
	SceneManager.is_paused = true
	pause_menu.visible = true
