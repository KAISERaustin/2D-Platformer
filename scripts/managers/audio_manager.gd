# res://scripts/managers/audio_manager.gd
extends Node

@export var main_menu_player_path: NodePath    = NodePath("MainMenuMusic")
@export var level_music_player_path: NodePath = NodePath("LevelMusic")

@onready var main_menu_player: AudioStreamPlayer2D = get_node(main_menu_player_path)
@onready var level_music_player: AudioStreamPlayer2D = get_node(level_music_player_path)

func _ready() -> void:
	main_menu_player.play()
	process_mode = Node.PROCESS_MODE_ALWAYS
	SceneManager.connect("scene_loaded", Callable(self, "_on_scene_loaded"))
	GameManager.connect("player_died",   Callable(self, "_on_player_died"))

func _on_scene_loaded() -> void:
	var new_path = get_tree().current_scene.scene_file_path
	var old_path = SceneManager.previous_scene

	if old_path.ends_with("main_menu.tscn") and new_path.ends_with("game.tscn"):
		main_menu_player.stop()
		level_music_player.play()
	elif old_path.ends_with("game.tscn") and new_path.ends_with("main_menu.tscn"):
		main_menu_player.play()
		level_music_player.stop()

func _on_player_died() -> void:
	main_menu_player.stop()
	level_music_player.stop()

func _on_player_won() -> void:
	main_menu_player.stop()
	level_music_player.stop()
