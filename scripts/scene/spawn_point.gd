extends RigidBody2D


func _ready() -> void:
	lock_rotation = true
	contact_monitor = true
	max_contacts_reported = 1
	body_entered.connect(_on_body_entered)


func _on_body_entered(_body: Node) -> void:
	set_deferred("freeze", true)  
