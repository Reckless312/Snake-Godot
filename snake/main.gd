extends Node

var score
var started = false

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
	
	started = true

func _on_snake_head_apple_hit() -> void:
	if started == true:
		$Apple.hide()
		$Apple.place_randomly()
	if $Apple.has_overlapping_areas():
		$Apple.place_randomly()
