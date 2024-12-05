extends Control

@export var level: PackedScene

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(level)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
