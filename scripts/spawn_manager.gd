extends Node

const SPAWN_POINT_SCENE = preload("res://scenes/game.tscn")
const MIN_SPEED = 200.0
const MAX_SPEED = 1000.0
const SPEED_PER_PIXEL = 3.0

var current_flag: RigidBody2D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("click received")
		var scene := get_tree().current_scene
		if scene == null or scene.scene_file_path == "res://scenes/game.tscn":
			print("blocked: wrong scene")
			return

		var player := get_tree().get_first_node_in_group("player") as Node2D
		if player == null:
			print("blocked: no node in 'player' group")
			return
		print("throwing")
		return

		if is_instance_valid(current_flag):
			current_flag.queue_free()

		current_flag = SPAWN_POINT_SCENE.instantiate()
		scene.add_child(current_flag)
		current_flag.global_position = player.global_position

		var to_mouse := player.get_global_mouse_position() - player.global_position
		var speed := clampf(to_mouse.length() * SPEED_PER_PIXEL, MIN_SPEED, MAX_SPEED)
		current_flag.linear_velocity = to_mouse.normalized() * speed
