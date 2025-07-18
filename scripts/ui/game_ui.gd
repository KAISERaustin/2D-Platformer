# res://scripts/ui/game_ui.gd
extends CanvasLayer

@export var pause_button_path: NodePath    = NodePath("PauseButton")
@export var pause_menu_scene: PackedScene
@onready var pause_button: Button         = get_node(pause_button_path)

func _ready() -> void:
	pause_button.pressed.connect(_on_pause_pressed)

func _on_pause_pressed() -> void:
	SceneManager.is_paused = true
	TimeManager.set_scale(0)
	var menu = pause_menu_scene.instantiate()
	add_child(menu)
