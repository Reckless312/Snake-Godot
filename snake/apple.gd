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
	while true:
		position = Vector2(rng.randi() % int(screen_size.x), rng.randi() % int(screen_size.y))
		await get_tree().process_frame
		if get_overlapping_bodies().size() == 0:
			break
	$AnimatedSprite2D.play(colors[randi() % colors.size()])
	show()
