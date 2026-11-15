extends Node

@export var launch_sound: AudioStream
@export_range(-40.0, 6.0, 0.5, "suffix:dB") var launch_volume_db := 0.0

@export var death_sound: AudioStream
@export_range(-40.0, 6.0, 0.5, "suffix:dB") var death_volume_db := 0.0

@export var win_sound: AudioStream
@export_range(-40.0, 6.0, 0.5, "suffix:dB") var win_volume_db := 0.0

var _win_player: AudioStreamPlayer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func play_launch() -> void:
	_play(launch_sound, launch_volume_db, 0.1)


func play_death() -> void:
	_play(death_sound, death_volume_db)


func play_win() -> void:
	AudioManager.set_music_paused(true)
	_win_player = _play(win_sound, win_volume_db)


func stop_win() -> void:
	if is_instance_valid(_win_player):
		_win_player.stop()
		_win_player.queue_free()
	_win_player = null


func _play(stream: AudioStream, volume_db := 0.0, pitch_variation := 0.0) -> AudioStreamPlayer:
	if stream == null:
		return null
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()
	return player
