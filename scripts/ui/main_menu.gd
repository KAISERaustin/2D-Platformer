# res://scripts/ui/main_menu.gd
extends Control

@export var start_button_path:   NodePath = NodePath("StartButton")
@export var options_button_path: NodePath = NodePath("OptionsButton")
@export var exit_button_path:    NodePath = NodePath("ExitButton")
@export var background_path:     NodePath = NodePath("BackgroundImage")

@onready var _start_button   := get_node(start_button_path)   as Button
@onready var _options_button := get_node(options_button_path) as Button
@onready var _exit_button    := get_node(exit_button_path)    as Button

func _ready() -> void:
	_start_button.pressed.connect(_on_start_button_pressed)
	_options_button.pressed.connect(_on_options_button_pressed)
	_exit_button.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed() -> void:
	print("▶ Start pressed")
	SceneManager.change_scene("res://scenes/game.tscn")


func _on_options_button_pressed() -> void:
	print("▶ Options pressed")
	SceneManager.change_scene("res://scenes/option_menu.tscn")

func _on_exit_button_pressed() -> void:
	print("▶ Exit pressed")
	get_tree().quit()
