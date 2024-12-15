extends Area2D

signal apple_hit
signal game_over

@export var speed = 400
var screen_size

func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()
	
var velocity = Vector2.ZERO

func _process(delta: float) -> void:
	var new_velocity = Vector2.ZERO
	velocity = velocity.normalized()
	
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
	
	if position.x < 0 or position.x > screen_size.x or position.y < 0 or position.y > screen_size.y:
		game_over.emit()
		reset()

func reset():
	position = Vector2.ZERO
	velocity = Vector2.ZERO
	$AnimatedSprite2D.rotation_degrees = 0
	
func start(pos):
	position = pos
	velocity.y -= 1
	show()
	$CollisionShape2D.disabled = false


func _on_apple_area_entered(area: Area2D) -> void:
	apple_hit.emit()
