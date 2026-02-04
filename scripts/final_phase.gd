extends Area2D

@export var scene: String = ""

@onready var timer_next_phase: Timer = $TimerNextPhase

# se o player colidir emite um signal para acontecer a animação de win do personagem e inicia um cronometro para trocar de fase e load
func _on_body_entered(_body: Node2D) -> void:
	if timer_next_phase.is_stopped():
		GameManager.state_win.emit()
		timer_next_phase.start()

#quando o cromometro chegar ao fim chama a função para trocar de cena
func _on_timer_next_phase_timeout() -> void:
	call_deferred("charge_scene")

#carrega e nova cena
func charge_scene():
	var path_scene = "res://Scenes/" + scene + ".tscn"
	GameManager.save_game_scene(path_scene)
