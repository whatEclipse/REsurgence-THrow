extends Area2D

@onready var victory_menu: CanvasLayer = $VictoryMenu

var _triggered := false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	SFXManager.play_win()
	if _triggered or not body.is_in_group("player"):
		return
	_triggered = true
	victory_menu.open()
