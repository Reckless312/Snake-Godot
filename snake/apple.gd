extends Area2D

func _ready() -> void:
	var colors = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(colors[randi() % colors.size()])

func _process(delta: float) -> void:
	pass