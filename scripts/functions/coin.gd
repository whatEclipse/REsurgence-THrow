extends Node2D

var score = 0

func _on_area_2d_body_entered(_dbody: Node2D) -> void:
	score += 1
	queue_free()
	
