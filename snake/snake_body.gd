extends Area2D

class_name snake_body

signal was_entered

func _ready() -> void:
	$CollisionShape2D.set_deferred("disabled", true)

func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area is snake_head:
		was_entered.emit()
