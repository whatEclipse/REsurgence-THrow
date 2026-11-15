extends Node

const SPAWN_POINT_SCENE = preload("res://scenes/entities/spawn_point.tscn")
const MIN_SPEED = 200.0      
const MAX_SPEED = 600.0     
const MAX_CHARGE_TIME = 1.5  


var current_flag: RigidBody2D
var _charging := false
var _charge_time := 0.0


func _process(delta: float) -> void:
	if _charging:
		_charge_time = minf(_charge_time + delta, MAX_CHARGE_TIME)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_charging = true
			_charge_time = 0.0
		elif _charging:
			_charging = false
			_launch_flag()


func _launch_flag() -> void:
	var scene := get_tree().current_scene
	if scene == null or scene.scene_file_path == "res://scenes/entities/spawn_point.tscn":
		print("blocked: wrong scene")
		return

	var player := get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		print("blocked: no node in 'player' group")
		return

	var to_mouse := player.get_global_mouse_position() - player.global_position
	if to_mouse.is_zero_approx():
		return

	if is_instance_valid(current_flag):
		current_flag.queue_free()

	var flag := SPAWN_POINT_SCENE.instantiate()
	if not flag is RigidBody2D:
		push_error("spawn_point.tscn root is not a RigidBody2D")
		flag.queue_free()
		return


	current_flag = flag
	scene.add_child(current_flag)
	current_flag.global_position = player.global_position + Vector2(0, -8)

	var charge := _charge_time / MAX_CHARGE_TIME
	var speed := lerpf(MIN_SPEED, MAX_SPEED, charge)
	current_flag.linear_velocity = to_mouse.normalized() * speed

func respawn_player() -> bool:
	if not is_instance_valid(current_flag):
		return false

	var player := get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		return false

	player.global_position = current_flag.global_position + Vector2(0, -8)
	player.velocity = Vector2.ZERO
	return true
