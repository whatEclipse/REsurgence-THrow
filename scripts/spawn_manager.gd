extends Node

const SPAWN_POINT_SCENE = preload("res://scenes/spawn_point.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var scene := get_tree().current_scene
		if scene == null or scene.scene_file_path == "res://scenes/game.tscn":
			return

		var spawn_point := SPAWN_POINT_SCENE.instantiate()
		scene.add_child(spawn_point)
		spawn_point.global_position = spawn_point.get_global_mouse_position()
