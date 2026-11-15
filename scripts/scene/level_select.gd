extends Control

@onready var grid: GridContainer = %GridContainer
@onready var back_button: Button = %BackButton

func _ready() -> void:
	for level in range(1, GameData.LEVEL_COUNT + 1):
		var button := Button.new()
		button.add_theme_font_size_override("font_size", 32)
		button.add_theme_font_override("font", load("res://assets/fonts/PixeloidSans-Bold.ttf"))
		button.text = str(level)
		button.custom_minimum_size = Vector2(80, 80)
		button.pressed.connect(GameData.play_level.bind(level))
		grid.add_child(button)

	back_button.pressed.connect(_on_back_pressed)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(GameData.MAIN_MENU_PATH)
