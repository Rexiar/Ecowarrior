extends CharacterBody2D

@export var slash_sound: AudioStreamWAV
@export var hurt_sound: AudioStreamWAV
@export var jump_sound: AudioStreamWAV


@export var audio_player: AudioStreamPlayer2D
@onready var attack_sprite = $Attack
@onready var animation_player = $AnimationPlayer
@onready var main = get_tree().get_root().get_node("/root/")
@onready var projectile = load("res://Scenes/projectile.tscn")

@export var attack_area: Area2D
@export var area: Area2D

@export var state_chart: StateChart

signal dead()

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

#var health: int = 100

func shoot():
	var instance = projectile.instantiate()
	if attack_sprite.flip_h:
		instance.dir = 3.14
	else:
		instance.dir = 0
	instance.spawnPos = global_position
	instance.spawnRot = global_rotation
	main.add_child.call_deferred(instance)
	

func _physics_process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		attack()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	

	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED
		

	move_and_slide()
	if velocity.x != 0:
		var isLeft = velocity.x < 0
		if isLeft:
			attack_area.position.x = -24
			%Sprite2D.flip_h = false
			attack_sprite.flip_h = true
		else:
			attack_area.position.x = 24
			%Sprite2D.flip_h = true
			attack_sprite.flip_h = false
		
	if Input.is_action_just_pressed("Attack"):
		#pass
		shoot()

func attack():
	audio_player.stream = slash_sound
	audio_player.play()
	animation_player.play("attack")
	
func attacked():
	audio_player.stream = hurt_sound
	audio_player.play()
	GameManager.health -= 20
	modulate = Color.RED
	if GameManager.health <= 0:
		state_chart.send_event("Dead")
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	state_chart.send_event("Normal")

func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		body.state_chart.send_event("Damaged")

func _on_damaged_state_entered() -> void:
	await attacked()

func _on_normal_state_entered() -> void:
	pass # Replace with function body.

func _on_dead_state_entered() -> void:
	dead.emit()
