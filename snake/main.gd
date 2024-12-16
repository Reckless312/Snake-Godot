extends Node

var score
var apples = preload("res://apple.tscn")
var apple

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass                                                              
	
func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	await get_tree().create_timer(2).timeout	
	
	create_an_apple()
	
	$snake.reset($StartPosition.position)
	
	$Music.play()

func create_an_apple():
	apple = apples.instantiate()
	add_child(apple)
	apple.place_randomly()
	apple.connect("was_eaten", self._on_snake_apple_hit)

func _on_snake_apple_hit() -> void:
	$EatingApple.play()
	apple.queue_free()
	create_an_apple()
	$snake.create_body()
	$HUD.update_score(10)


func _on_snake_game_over() -> void:
	$HUD.show_game_over()
	$Apple.hide()
