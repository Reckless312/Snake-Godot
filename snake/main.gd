extends Node

var score

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_snake_head_hit() -> void:
	$HUD.show_game_over()                                                                 
	
func new_game():
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	
	$snake_head.start($StartPosition.position)	
	
	$Apple.place_randomly()
	
	$Music.play()


func _on_apple_hit() -> void:
	$Apple.place_randomly()
