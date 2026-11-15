extends Node

@export var launch_sound: AudioStream
@export var death_sound: AudioStream
@export var win_sound: AudioStream


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # so sounds still play while paused


func play_launch() -> void:
	_play(launch_sound, 0.0, 0.1)


func play_death() -> void:
	_play(death_sound)


func play_win() -> void:
	_play(win_sound)


func _play(stream: AudioStream, volume_db := 0.0, pitch_variation := 0.0) -> void:
	if stream == null:
		return
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()
