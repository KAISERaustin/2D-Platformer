# res://scripts/ui/pause_menu.gd
extends Control

@export var resume_button_path:   		NodePath = NodePath("VBoxContainer/ResumeButton")
@export var options_button_path:  		NodePath = NodePath("VBoxContainer/OptionsButton")
@export var exit_button_path:     		NodePath = NodePath("VBoxContainer/ExitButton")
@export var in_game_options_menu_path : NodePath = NodePath("../InGameOptionMenu")

@onready var resume_button:       	Button  = get_node(resume_button_path)
@onready var options_button:      	Button  = get_node(options_button_path)
@onready var exit_button:         	Button  = get_node(exit_button_path)
@onready var in_game_option_menu:   Control = get_node(in_game_options_menu_path)

func _ready() -> void:
	visible = false

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	SceneManager.is_paused = false
	visible = false

func _on_options_button_pressed() -> void:
	visible = false
	in_game_option_menu.visible = true 

func _on_exit_button_pressed() -> void:
	SceneManager.change_scene("res://scenes/main_menu.tscn")
