extends Node2D

@export var audio_stream_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio_stream_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_audio_stream_player_finished() -> void:
	audio_stream_player.play()
