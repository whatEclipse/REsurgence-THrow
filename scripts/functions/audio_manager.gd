extends Node

signal sound_toggled(enabled: bool)

@export var menu_music: AudioStream          # main menu and level select
@export var early_levels_music: AudioStream  # levels 1-5
@export var late_levels_music: AudioStream   # levels 6 and up

const EARLY_LEVELS_MAX := 5
const FADE_TIME := 0.5
const SILENT_DB := -40.0

var sound_enabled: bool = true

var _music_player := AudioStreamPlayer.new()
var _current_scene_path := ""
var _current_track: AudioStream
var _tween: Tween


func _ready() -> void:
	print("Audio ready")
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_music_player)
	sound_enabled = GameData.sound_enabled
	_apply()


func _process(_delta: float) -> void:
	var scene := get_tree().current_scene
	if scene == null:
		return
	var path := scene.scene_file_path
	if path == _current_scene_path:
		return
	_current_scene_path = path
	_play_track(_track_for_scene(path))


func set_sound_enabled(enabled: bool) -> void:
	sound_enabled = enabled
	GameData.sound_enabled = enabled
	GameData.save_data()
	_apply()
	sound_toggled.emit(enabled)


func _apply() -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), not sound_enabled)


func _track_for_scene(path: String) -> AudioStream:
	if path == GameData.MAIN_MENU_PATH or path == GameData.LEVEL_SELECT_PATH:
		return menu_music

	var result := RegEx.create_from_string("level_(\\d+)\\.tscn$").search(path)
	if result:
		var level := int(result.get_string(1))
		return early_levels_music if level <= EARLY_LEVELS_MAX else late_levels_music

	return _current_track 


func _play_track(track: AudioStream) -> void:
	if track == _current_track:
		return 
	_current_track = track

	if _tween:
		_tween.kill()
	_tween = create_tween()
	if _music_player.playing:
		_tween.tween_property(_music_player, "volume_db", SILENT_DB, FADE_TIME)
	_tween.tween_callback(_switch_stream.bind(track))
	_tween.tween_property(_music_player, "volume_db", 0.0, FADE_TIME)


func _switch_stream(track: AudioStream) -> void:
	if track == null:
		_music_player.stop()
		return
	_music_player.stream = track
	_music_player.volume_db = SILENT_DB
	_music_player.play()
