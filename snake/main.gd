extends Node

var apples = preload("res://apple.tscn")
var snake_bodies = preload("res://snake_body.tscn")

var score
var apple
var body_list = []
var position_queue = []
var spacing = 62

func _ready() -> void:
	pass

func _process(delta: float) -> void:
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
	
	apple.place_randomly()
	apple.connect("was_eaten", self._on_snake_apple_hit)

func _on_snake_apple_hit() -> void:
	apple.queue_free()
	create_an_apple()
	
	var new_body = snake_bodies.instantiate()
	new_body.position = $snake_head.position
	body_list.append(new_body)
	add_child(new_body)
	
	score += 10
	$HUD.update_score(score)

func _on_snake_head_game_over() -> void:
	if apple != null:
		apple.queue_free()
	
	for body in body_list:
		body.queue_free()
		
	body_list.clear()
	position_queue.clear()
		
	$HUD.show_game_over()
