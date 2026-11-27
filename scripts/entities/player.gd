extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_box: CollisionShape2D = $CollisionBox
@onready var aim_pivot: Node2D = $AimPivot
@onready var arrow: AnimatedSprite2D = $AimPivot/Arrow

const SPEED = 100.0
const JUMP_VELOCITY = -170.0
var isDying = false
var push_force = 30
var charging := false

var start_position: Vector2

func _ready() -> void:
	start_position = global_position
	aim_pivot.visible = false

func _physics_process(delta: float) -> void:

	if isDying == false:
		if not is_on_floor():
			velocity += get_gravity()* delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
			
		if is_on_floor():
			if direction == 0:
				animated_sprite.play("Idle")
			else:
				animated_sprite.play("Walking")
		elif velocity.y < 0:
			animated_sprite.play("Jump")
		else:
			animated_sprite.play("Fall")
			
		if direction == 1:
			animated_sprite.flip_h = true;
		if direction == -1:
			animated_sprite.flip_h = false;

		move_and_slide()
		
		
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider().is_in_group("pushable"):
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if not charging:
			charging = true
			aim_pivot.visible = true
			arrow.play("default")
		aim_pivot.look_at(get_global_mouse_position())
	elif charging:
		charging = false
		aim_pivot.visible = false
		arrow.stop()
		var dir := (get_global_mouse_position() - global_position).normalized()

func die():
	velocity = Vector2.ZERO
	if isDying:
		return
	isDying = true
	SFXManager.play_death()
	animated_sprite.play("Death")
	await animated_sprite.animation_finished
	velocity = Vector2.ZERO
	if not SpawnManager.respawn_player():
		global_position = start_position #no flag placed yet
	animated_sprite.play_backwards("Death")
	await animated_sprite.animation_finished
	isDying = false
	
	
func jumpOn():
	if isDying == false:
		velocity.y = -1*abs(velocity.y* 0.5) - 200
