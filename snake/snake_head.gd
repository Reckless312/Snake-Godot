extends Area2D

signal hit

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
	position = position.clamp(Vector2.ZERO, screen_size)
	


func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
