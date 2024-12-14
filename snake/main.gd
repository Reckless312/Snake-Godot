extends Node

@export var apple_scene : PackedScene
var score

func _ready() -> void:
	new_game()

func _process(delta: float) -> void:
	pass

func _on_snake_head_hit() -> void:
	pass # Replace with function body.
	
func new_game():
	score = 0
	$snake_head.start($StartPosition.position)	
