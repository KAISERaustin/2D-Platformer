# res://scripts/ui/option_menu.gd
extends Control
class_name OptionMenu

func _ready() -> void:
	pass

func _on_enable_mobile_controls_pressed() -> void:
	GameManager.toggle_mobile_controls()

func _on_main_menu_pressed() -> void:
	SceneManager.go_back()
