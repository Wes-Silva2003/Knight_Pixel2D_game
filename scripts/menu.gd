extends Control

const phase_1 = "res://Scenes/phase_1.tscn"

@onready var pop_click: AudioStreamPlayer = $pop_click

#ao clicar em novo jogo apaga tudo e volta para o padrão
func _on_new_game_pressed() -> void:
	pop_click.play()
	GameManager._reset_all_data()
	GameManager.save_game_scene(phase_1)

#volta para o ultimo save
func _on_continue_pressed() -> void:
	pop_click.play()
	GameManager.load_game()

#fecha o jogo
func _on_quit_pressed() -> void:
	pop_click.play()
	get_tree().quit()
