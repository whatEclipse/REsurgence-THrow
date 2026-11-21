extends Node2D
var SPEED = 50

var direction = 1

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_bottom_r: RayCast2D = $RayCastBottomR
@onready var ray_cast_bottom_l: RayCast2D = $RayCastBottomL

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
		
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
		
	if not ray_cast_bottom_r.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
		
	if not ray_cast_bottom_l.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	
	position.x += direction * SPEED * delta


func _on_jump_on_body_entered(body: Node2D) -> void:
		if body.has_method("jumpOn"):
			body.jumpOn()
