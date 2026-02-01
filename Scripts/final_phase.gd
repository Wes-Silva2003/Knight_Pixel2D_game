extends Area2D

@export var next_level = ""

@onready var timer_next_phase: Timer = $TimerNextPhase
@onready var win: AudioStreamPlayer2D = $Win

func _on_body_entered (_body: Node2D) -> void:
	if timer_next_phase.is_stopped():
		timer_next_phase.start()
		win.play()
	
func charge_level():
	get_tree().change_scene_to_file("res://Scenes/" + next_level + ".tscn")

func _on_timer_next_phase_timeout() -> void:
	call_deferred("charge_level")
