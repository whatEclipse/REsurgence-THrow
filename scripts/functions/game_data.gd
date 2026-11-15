extends Node

const LEVEL_COUNT := 10 
const LEVEL_PATH := "res://levels/level_%d.tscn"
const MAIN_MENU_PATH := "res://scenes/menus/main_menu.tscn"
const LEVEL_SELECT_PATH := "res://scenes/menus/level_select.tscn"
const SAVE_PATH := "user://save.cfg"

var last_level: int = 1
var sound_enabled: bool = true

func _ready() -> void:
	load_data()

func load_data() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	last_level = cfg.get_value("progress", "last_level", 1)
	sound_enabled = cfg.get_value("settings", "sound_enabled", true)

func save_data() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "last_level", last_level)
	cfg.set_value("settings", "sound_enabled", sound_enabled)
	cfg.save(SAVE_PATH)

func play_level(level: int) -> void:
	var path := LEVEL_PATH % level
	if not ResourceLoader.exists(path):
		push_error("Level scene not found: " + path)
		return
	last_level = level
	save_data()
	get_tree().paused = false
	get_tree().change_scene_to_file(path)
