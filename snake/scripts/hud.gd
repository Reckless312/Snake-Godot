extends CanvasLayer

signal start_game
signal change_difficulty

var difficulty = 0
var difficulties = ["Easy", "Medium", "Hard"]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	
	await $MessageTimer.timeout
	
	$Message.text = "Snake!"
	$Message.show()
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$DifficultyButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)
	

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$DifficultyButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()


func _on_difficulty_button_pressed() -> void:
	difficulty = (difficulty + 1) % 3
	$DifficultyButton.text = difficulties[difficulty]
	change_difficulty.emit()
