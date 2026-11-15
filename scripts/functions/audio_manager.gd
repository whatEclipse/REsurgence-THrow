extends Node

signal sound_toggled(enabled: bool)

var sound_enabled: bool = true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	sound_enabled = GameData.sound_enabled
	_apply()

func set_sound_enabled(enabled: bool) -> void:
	sound_enabled = enabled
	GameData.sound_enabled = enabled
	GameData.save_data()
	_apply()
	sound_toggled.emit(enabled)

func _apply() -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), not sound_enabled)
