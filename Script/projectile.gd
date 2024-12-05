extends CharacterBody2D

@export var SPEED = 200

var dir: float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	
func _physics_process(delta: float) -> void:
	velocity = Vector2(SPEED, 0).rotated(dir)
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i).get_collider()
		if collision.is_in_group("Enemy"):
			collision.state_chart.send_event("Damaged")
		self.queue_free()

	
