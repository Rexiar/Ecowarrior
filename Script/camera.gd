extends Camera2D

@export var follow_point: Node2D

@export var score_label: Label
@export var health_label: Label

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if follow_point != null:
		global_position = global_position.lerp(Vector2(follow_point.global_position.x, follow_point.global_position.y), 0.1)
	score_label.text = str(GameManager.score)
	health_label.text = str(GameManager.health)

func finish_game():
	$EndGame.initialize()
