extends Area2D

var rng = RandomNumberGenerator.new()
var screen_size
var colors

func _ready() -> void:
	rng.randomize()
	screen_size = get_viewport().get_visible_rect().size
	colors = $AnimatedSprite2D.sprite_frames.get_animation_names()
	hide()

func _process(delta: float) -> void:
	pass
	
func place_randomly():
	position = Vector2(rng.randi() % int(screen_size.x), rng.randi() % int(screen_size.y))
	$AnimatedSprite2D.play(colors[randi() % colors.size()])
	show()
