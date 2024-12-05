extends CharacterBody2D

@export var state_chart: StateChart
@export var attack_timer: Timer
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D

@export var arrow: PackedScene

var health: int = 100
var player: Node2D

var player_in_range: bool = false

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func _on_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = true
		player = body
		state_chart.send_event("Move")
		

func _on_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		player = null
		state_chart.send_event("Idle")
		velocity.x = 0
		

func _on_attack_state_processing(delta: float) -> void:
	check_side()
	if self.global_position.distance_squared_to(player.global_position) >= 6400:
		state_chart.send_event("Move")
		return
	await get_tree().create_timer(2).timeout
	_on_attack_timer_timeout()
	#if attack_timer.is_stopped():
		#attack_timer.start()
	

func _on_attack_timer_timeout() -> void:
	if player != null:
		animation_player.play("Attack")
		var arrow_instance = arrow.instantiate()
		add_child(arrow_instance)
		arrow_instance.global_position = self.global_position
		arrow_instance.global_rotation = self.global_rotation
		if player.global_position.x > self.global_position.x: arrow_instance.dir = 0.0
		else: arrow_instance.dir = PI



func _on_idle_state_processing(delta: float) -> void:
	pass


func _on_move_state_processing(delta: float) -> void:
	check_side()
	#if !player_in_range:return
	if self.global_position.distance_squared_to(player.global_position) < 2000:
		state_chart.send_event("Attack")
		return
	var direction: Vector2 = (- self.global_position + player.global_position).normalized()
	velocity.x = direction.x * 10000.0 * delta
	if player.global_position.y < self.global_position.y - 60.0 and is_on_floor():
		jump()

func jump():
	velocity.y =  -300.0

func attacked():
	health -= 20
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE

func _on_normal_state_processing(delta: float) -> void:
	pass


func _on_damaged_state_entered() -> void:
	await attacked() 
	if health <= 0: 
		state_chart.send_event("Dead")
		GameManager.score += 10
	else: state_chart.send_event("Normal")


func _on_dead_state_entered() -> void:
	queue_free()


func _on_attack_state_entered() -> void:
	pass
	#animation_player.play("Attack")


func _on_idle_state_entered() -> void:
	animation_player.play("Idle")


func _on_move_state_entered() -> void:
	animation_player.play("Move")

func check_side():
	if player != null:
		if player.global_position.x < self.global_position.x:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
