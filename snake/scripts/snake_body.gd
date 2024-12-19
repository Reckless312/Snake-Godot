extends Area2D

class_name snake_body

signal was_entered

var spawned_flag = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area is snake_head and spawned_flag == true:
		was_entered.emit()


func _on_area_exited(area: Area2D) -> void:
	if area is snake_head:
		spawned_flag = true
