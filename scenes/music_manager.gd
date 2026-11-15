extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stream=load("res://audio/music/Sweet 70s.wav")
	play()
	
