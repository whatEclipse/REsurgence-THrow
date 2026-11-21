extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var speed = 50
var player_saw = false
var starting_pos
var direction

func _ready() -> void:
	starting_pos = position

func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_saw = true
		
func _physics_process(delta: float) -> void:
	if player_saw == true and get_tree().get_first_node_in_group("player") != null:
		direction = (get_tree().get_first_node_in_group("player").position - position).normalized()
		global_position += direction * speed * delta
	#elif global_position != starting_pos and player_saw == false:
		#direction = (starting_pos.position - position).normalized()
		#global_position += direction * speed * delta
	

func _on_trigger_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_saw = false
	
		
