extends Area2D

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	var colors = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(colors[randi() % colors.size()])
	rng.randomize()
	hide()

func _process(delta: float) -> void:
	pass
	
func place_randomly():
	var screen_size = get_viewport().get_visible_rect().size
	position = Vector2(rng.randi() % int(screen_size.x), rng.randi() % int(screen_size.y))
	show()
	
