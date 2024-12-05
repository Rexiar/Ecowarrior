extends Node2D

@export var death_scene: PackedScene
@export var player_scene: PackedScene

@export var end_screen: PackedScene

@export var camera: Camera2D

@export var spawner_manager: Node

var player

func _ready() -> void:
	player = player_scene.instantiate()
	add_child(player)
	player.global_position = Vector2(872, 526)
	camera.follow_point = player
	player.dead.connect(dead)

	GameManager.score = 0

	spawner_manager.player = player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func finish_level(body: Node2D):
	print("FINISH!")
	get_tree().change_scene_to_packed(end_screen)

func dead():
	if GameManager.score > GameManager.highscore: GameManager.highscore = GameManager.score
	get_tree().change_scene_to_packed(death_scene)
