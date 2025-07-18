# res://scripts/ui/pause_menu.gd
extends Control

@export var resume_button_path:          NodePath    = NodePath("VBoxContainer/ResumeButton")
@export var options_button_path:         NodePath    = NodePath("VBoxContainer/OptionsButton")
@export var exit_button_path:            NodePath    = NodePath("VBoxContainer/ExitButton")
@export var in_game_option_menu_scene:   PackedScene = preload("res://scenes/in_game_option_menu.tscn")

@onready var resume_button: Button   = get_node(resume_button_path)
@onready var options_button: Button  = get_node(options_button_path)
@onready var exit_button: Button     = get_node(exit_button_path)

func _ready() -> void:
	resume_button.pressed.connect(_on_resume_pressed)
	options_button.pressed.connect(_on_options_pressed)
	exit_button.pressed.connect(_on_exit_pressed)

func _on_resume_pressed() -> void:
	TimeManager.reset()
	AudioManager.play_level_music()
	queue_free()

func _on_options_pressed() -> void:
	var opt = in_game_option_menu_scene.instantiate()
	get_parent().add_child(opt)
	queue_free()

func _on_exit_pressed() -> void:
	SceneManager.change_scene("res://scenes/main_menu.tscn")
