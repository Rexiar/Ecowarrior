extends Node

@export var spawner_timer: Timer
@export var logger_enemy: PackedScene
@export var orc_enemy: PackedScene
@export var archer_enemy: PackedScene

@export var boundary_top_left: Node2D
@export var boundary_bottom_right: Node2D

@export var player: CharacterBody2D

func _ready() -> void:
	#pass
	activate()

func _process(delta: float) -> void:
	pass

func activate():
	spawner_timer.start()

func deactivate():
	spawner_timer.stop()

func _on_spawner_timer_timeout() -> void:
	if spawner_timer.wait_time > 1.0:
		spawner_timer.start(spawner_timer.wait_time - 0.1)
	var num = randi_range(0, 3)
	match num:
		0:
			randomize_spawn(logger_enemy)
		1:
			randomize_spawn(archer_enemy)
		2:
			randomize_spawn(orc_enemy)

func randomize_spawn(enemy_type: PackedScene):
	var enemy = enemy_type.instantiate()
	get_parent().add_child(enemy)
	enemy.global_position = Vector2(randi_range(boundary_top_left.global_position.x, boundary_bottom_right.global_position.x), \
	randi_range(boundary_top_left.global_position.y, boundary_bottom_right.global_position.y))
	#enemy.player = player
