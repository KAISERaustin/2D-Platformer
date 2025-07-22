# res://scripts/ui/main_menu.gd
extends Control

@export var start_button_path:    NodePath = NodePath("VBoxContainer/StartButton")
@export var options_button_path:  NodePath = NodePath("VBoxContainer/OptionsButton")
@export var quit_button_path:     NodePath = NodePath("VBoxContainer/QuitButton")

@onready var start_button:    Button = get_node(start_button_path)
@onready var options_button:  Button = get_node(options_button_path)
@onready var quit_button:     Button = get_node(quit_button_path)

func _on_start_button_pressed() -> void:
	get_tree().paused = false
	SceneManager.is_paused = false
	SceneManager.change_scene("res://scenes/New Environment/NewEnvironment.tscn")
	TimeManager.reset()

func _on_options_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/option_menu.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
