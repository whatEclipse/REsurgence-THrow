extends Node

const LEVEL_COUNT := 5 
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
func get_current_level() -> int:
	var scene := get_tree().current_scene
	if scene != null:
		var regex := RegEx.create_from_string("level_(\\d+)\\.tscn$")
		var result := regex.search(scene.scene_file_path)
		if result:
			return int(result.get_string(1))
	return last_level


func has_next_level() -> bool:
	return get_current_level() < LEVEL_COUNT


func play_next_level() -> void:
	play_level(get_current_level() + 1)
	
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("respawn"):
		get_tree().reload_current_scene()
