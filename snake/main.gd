extends Node

var apples = preload("res://apple.tscn")
var snake_bodies = preload("res://snake_body.tscn")

var mutex : Mutex = Mutex.new()

var rng = RandomNumberGenerator.new()
var screen_size
var score
var apple
var body_list = []
var position_queue = []
var spacing = 62
var pause_body = false

func _ready() -> void:
	rng.randomize()
	screen_size = get_viewport().get_visible_rect().size

func _process(delta: float) -> void:
	if pause_body == true:
		return
	
	position_queue.append($snake_head.position)
	
	while position_queue.size() > (body_list.size() + 1) * spacing:
		position_queue.pop_front()
		
	for i in range(body_list.size()):
		if (i + 1) * spacing - 1 < position_queue.size():
			body_list[i].position = position_queue[(i + 1) * spacing - 1]
		elif position_queue.size() != 0:
			body_list[i].position = position_queue[position_queue.size() - 1]
		else:
			body_list[i].position = $snake_head.position

func new_game():
	#$Music.play()
	
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	await get_tree().create_timer(2).timeout    
	
	create_an_apple()
	
	$snake_head.start($StartPosition.position)
	position_queue.clear()
	body_list.clear()

func create_an_apple():
	apple = apples.instantiate()
	add_child(apple)
	
	mutex.lock()
	if apple == null:
		mutex.unlock()
		return
	place_apple_randomly()
	apple.connect("was_eaten", self._on_snake_apple_hit)
	mutex.unlock()

func _on_snake_apple_hit() -> void:
	#$EatingApple.play()
	
	mutex.lock()
	if apple != null:
		apple.queue_free()
	mutex.unlock()
	create_an_apple()
	
	var new_body = snake_bodies.instantiate()
	new_body.position = $snake_head.position
	
	body_list.append(new_body)
	new_body.connect("was_entered", $snake_head.reset)
	
	add_child(new_body)
	
	score += 10
	$HUD.update_score(score)

func _on_snake_head_game_over() -> void:
	pause_body = true
	$HUD.show_game_over()
	await get_tree().create_timer(2.0).timeout
	mutex.lock()
	if apple != null:
		apple.queue_free()
	mutex.unlock()
	
	for body in body_list:
		body.queue_free()
		
	body_list.clear()
	position_queue.clear()
	
	pause_body = false

func place_apple_randomly():
	while true:
		apple.position = Vector2(rng.randi() % int(screen_size.x), rng.randi() % int(screen_size.y))
		await get_tree().process_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		if apple.get_overlapping_areas().size() == 0:
			break
	apple.show()
