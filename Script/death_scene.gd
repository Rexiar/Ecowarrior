extends Control

var game_scene = "res://Scenes/main.tscn"

@export var score_label: Label
@export var highscore_label: Label

func _ready() -> void:
	score_label.text = "Score: " + str(GameManager.score)
	highscore_label.text = "Highscore: " + str(GameManager.highscore)


func _process(delta: float) -> void:
	pass


func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file(game_scene)

func _on_exit_button_pressed() -> void:
	get_tree().quit()
