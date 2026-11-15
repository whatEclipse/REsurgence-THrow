extends CanvasLayer

@onready var restart_button: Button = $Control/CenterContainer/VBoxContainer/PlayButton
@onready var level_select_button: Button = $Control/CenterContainer/VBoxContainer/LevelSelectButton
@onready var quit_button: Button = $Control/CenterContainer/VBoxContainer/QuitButton
@onready var sound_check_box: BaseButton = $Control/CheckButton

func _ready() -> void:
	print("Pause menu ready")
	visible = false
	restart_button.pressed.connect(_on_restart_pressed)
	level_select_button.pressed.connect(_on_level_select_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	sound_check_box.toggled.connect(AudioManager.set_sound_enabled)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause() -> void:
	visible = not visible
	get_tree().paused = visible
	if visible:
		sound_check_box.set_pressed_no_signal(AudioManager.sound_enabled)
		restart_button.grab_focus()

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_level_select_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(GameData.LEVEL_SELECT_PATH)

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
