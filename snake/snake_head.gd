extends Area2D
@export var speed = 400
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	
var velocity = Vector2.ZERO

func _process(delta: float) -> void:
	var new_velocity = Vector2.ZERO
	if Input.is_action_pressed("right"):
		new_velocity.x = 1
	elif Input.is_action_pressed("left"):
		new_velocity.x = -1
	elif Input.is_action_pressed("down"):
		new_velocity.y = 1
	elif Input.is_action_pressed("up"):
		new_velocity.y = -1
	
	if !new_velocity.is_equal_approx(Vector2.ZERO):
		velocity = new_velocity
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
