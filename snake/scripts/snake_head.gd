extends Area2D

class_name snake_head

signal game_over

var snake_type = ["green_snake", "yellow_snake"]
var snake_dead = ["green_dead", "yellow_dead"]
@export var type = 0
var rng = RandomNumberGenerator.new()

@export var speed = 400
var screen_size
var pause_head = true

func _ready() -> void:
	rng.randomize()
	type = rng.randi() % 2
	$AnimatedSprite2D.animation = snake_type[type]
	screen_size = get_viewport_rect().size
	hide()
	
var velocity = Vector2.ZERO

func _process(delta: float) -> void:
	if pause_head == true:
		return
	
	var new_velocity = Vector2.ZERO
	velocity = velocity.normalized()
	
	#Movement
	if Input.is_action_pressed("right") and velocity.x != -1:
		new_velocity.x = 1
		$AnimatedSprite2D.rotation_degrees = 90
	elif Input.is_action_pressed("left") and velocity.x != 1:
		new_velocity.x = -1
		$AnimatedSprite2D.rotation_degrees = 270
	elif Input.is_action_pressed("down") and velocity.y != -1:
		new_velocity.y = 1
		$AnimatedSprite2D.rotation_degrees = 180
	elif Input.is_action_pressed("up") and velocity.y != 1:
		new_velocity.y = -1
		$AnimatedSprite2D.rotation_degrees = 0
	
	if !new_velocity.is_equal_approx(Vector2.ZERO):
		velocity = new_velocity
	
	velocity = velocity * speed
	$AnimatedSprite2D.play()
		
	position += velocity * delta
	
	#Out of bounds - Game over
	if position.x < 0 or position.x > screen_size.x or position.y < 0 or position.y > screen_size.y:
		reset()

func reset():
	pause_head = true
	$AnimatedSprite2D.animation = snake_dead[type]
	
	game_over.emit()
	
	velocity = Vector2.ZERO
	await get_tree().create_timer(2.0).timeout
	
	position = Vector2.ZERO
	
	$AnimatedSprite2D.rotation_degrees = 0
	$CollisionShape2D.set_deferred("disabled", true)
	
	hide()
	type = rng.randi() % 2
	$AnimatedSprite2D.animation = snake_type[type]
	
func start(pos):
	position = pos
	velocity.y -= 1
	show()
	pause_head = false
	$CollisionShape2D.disabled = false
