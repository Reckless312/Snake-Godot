extends Node

#Load the required scenes
var apples = preload("res://scenes/apple.tscn")
var snake_bodies = preload("res://scenes/snake_body.tscn")
var easter_egg = preload("res://scenes/easter_egg.tscn")
var speeds = [400, 600, 800]
var spacings = [60, 40, 30]
var current_speed = 0
var mutex : Mutex = Mutex.new()
var mutex_egg : Mutex = Mutex.new()

#Prepare the variables
var rng = RandomNumberGenerator.new()
var screen_size
var score
var apple
var egg
var body_list = []
var position_queue = []
var spacing = 60
var pause_body = false

func _ready() -> void:
	#Random seed + information at startup
	rng.randomize()
	screen_size = get_viewport().get_visible_rect().size

func _process(delta: float) -> void:
	if pause_body == true:
		return
		
	position_queue.append($snake_head.position)
	
	#Get number of required positions
	while position_queue.size() > (body_list.size() + 1) * spacing:
		position_queue.pop_front()
		
	#Assign a position to each part of the snake	
	for i in range(body_list.size()):
		if (i + 1) * spacing - 1 < position_queue.size():
			body_list[i].position = position_queue[(i + 1) * spacing - 1]
		elif position_queue.size() != 0:
			body_list[i].position = position_queue[position_queue.size() - 1]
		else:
			body_list[i].position = $snake_head.position

#Reset game
func new_game():
	$EasterEgg.stop()
	$Music.play()
	
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	await get_tree().create_timer(2).timeout    
	
	create_an_apple()
	
	$snake_head.start($StartPosition.position)
	position_queue.clear()
	body_list.clear()
	
	mutex_egg.lock()
	if egg != null:
		egg.queue_free()
	mutex_egg.unlock()

func create_an_apple():
	apple = apples.instantiate()
	add_child(apple)
	
	mutex.lock()
	if apple == null:
		mutex.unlock()
		return
	place_scene_randomly(apple)
	apple.connect("was_eaten", self._on_snake_apple_hit)
	mutex.unlock()
	
	if randi() % 100 == 0:
		mutex_egg.lock()
		if egg != null:
			egg.queue_free()
		mutex_egg.unlock()
		egg = easter_egg.instantiate()
		add_child(egg)
		mutex_egg.lock()
		if egg == null:
			mutex_egg.unlock()
			return
		place_scene_randomly(egg)
		egg.connect("easter_egg", self._on_snake_egg_hit)
		mutex_egg.unlock()

func _on_snake_egg_hit() -> void:
	mutex_egg.lock()
	if egg != null:
		egg.queue_free()
	mutex_egg.unlock()
	$Music.stop()
	if $EasterEgg.playing == false:
		$EasterEgg.play()

func _on_snake_apple_hit() -> void:
	$EatingApple.play()
	
	#Clear the apple	
	mutex.lock()
	if apple != null:
		apple.queue_free()
	mutex.unlock()
	create_an_apple()
			
	#Create new body part
	var new_body = snake_bodies.instantiate()
	new_body.position = $snake_head.position
	new_body.assign_animation($snake_head.type)
	body_list.append(new_body)
	new_body.connect("was_entered", $snake_head.reset)
	
	add_child(new_body)
	
	#Update score
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

#Attempt to generate a scene in an empty space
func place_scene_randomly(scene):
	while true:
		scene.position = Vector2(rng.randi() % int(screen_size.x), rng.randi() % int(screen_size.y))
		await get_tree().process_frame
		await get_tree().physics_frame
		await get_tree().physics_frame
		if scene == null or scene.get_overlapping_areas().size() == 0:
			break
	if scene != null:
		scene.show()


func _on_hud_change_difficulty() -> void:
	current_speed = (current_speed + 1) % 3
	$snake_head.speed = speeds[current_speed]
	spacing = spacings[current_speed]


func _on_easter_egg_finished() -> void:
	$Music.play()


func _on_music_finished() -> void:
	$Music.play()
