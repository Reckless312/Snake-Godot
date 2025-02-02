extends Area2D

signal easter_egg

func _ready() -> void:
	hide()

func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	#if area is snake_head:
		#$CollisionShape2D.set_deferred("disabled", true)
	easter_egg.emit()
