extends Node

var score

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass                                                              
	
func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	await get_tree().create_timer(2).timeout
	
	$snake_head.start($StartPosition.position)	
	
	$Apple.place_randomly()
	
	$Music.play()

func _on_snake_head_apple_hit() -> void:
	$EatingApple.play()
	$Apple.hide()
	$Apple.place_randomly()
	$HUD.update_score(10)


func _on_snake_head_game_over() -> void:
	$HUD.show_game_over()
	$Apple.hide()
	$snake_head.hide()
