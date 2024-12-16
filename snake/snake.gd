extends Node2D

signal game_over

var screen_size
var snake_body = preload("res://snake_body.tscn")
var bodies = []

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	if $snake_head.position.x < 0 or $snake_head.position.x > screen_size.x or $snake_head.position.y < 0 or $snake_head.position.y > screen_size.y:
		game_over.emit()
		$snake_head.reset()
		$snake_head.hide()
	
	# position += velocity * delta
	for i in range(bodies.size() - 1, 0, -1):
		bodies[i].rotation_degrees = bodies[i - 1].rotation_degrees
	if bodies.size() > 0:
		bodies[0].rotation_degrees = $snake_head.rotation_degrees

func reset(pos):
	$snake_head.start(pos)

func get_valid_position(body):
	if body.rotation_degrees == 0:
		return Vector2(body.position.x, body.position.y - 40)
	if body.rotation_degrees == 90:
		return Vector2(body.position.x - 40, body.position.y)
	if body.rotation_degrees == 180:
		return Vector2(body.position.x, body.position.y + 40)
	else:
		return Vector2(body.position.x + 40, body.position.y)

func create_body():
	var body = snake_body.instantiate()
	add_child(body)
	if bodies.size() == 0:
		body.position = get_valid_position($snake_head)
	else:
		body.position = get_valid_position(bodies[bodies.size() - 1])
	bodies.append(body)
