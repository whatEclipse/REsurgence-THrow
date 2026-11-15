extends Node2D

var score

func _on_area_2d_body_entered(body: Node2D) -> void:
	score += 1
	queue_free()
	
