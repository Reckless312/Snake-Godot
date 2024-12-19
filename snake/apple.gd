extends Area2D

signal was_eaten

var rng = RandomNumberGenerator.new()
var colors

func _ready() -> void:
	rng.randomize()
	colors = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(colors[rng.randi() % colors.size()])
	hide()

func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if area is snake_head:
		was_eaten.emit()
