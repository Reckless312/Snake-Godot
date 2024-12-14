extends Node

@export var apple_scene : PackedScene
var score

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_snake_head_hit() -> void:
	$HUD.show_game_over()                                                                 
	
func new_game():
	score = 0
	$snake_head.start($StartPosition.position)	
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("apples", "queue_free")
	$Music.play()
