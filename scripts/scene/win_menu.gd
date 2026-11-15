extends CanvasLayer

@onready var next_button: Button = $Control/CenterContainer/VBoxContainer/NextLevelButton
@onready var quit_button: Button = $Control/CenterContainer/VBoxContainer/QuitButton


func _ready() -> void:
	visible = false
	next_button.pressed.connect(_on_next_pressed)
	quit_button.pressed.connect(_on_quit_pressed)


func open() -> void:
	visible = true
	get_tree().paused = true
	next_button.visible = GameData.has_next_level()
	if next_button.visible:
		next_button.grab_focus()
	else:
		quit_button.grab_focus()


func _on_next_pressed() -> void:
	GameData.play_next_level()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
