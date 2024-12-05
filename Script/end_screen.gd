extends Node

@export var menu_screen: String = "res://Scenes/menu.tscn"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file(menu_screen)
