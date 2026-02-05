extends Control

const phase_1 = "res://Scenes/phase_1.tscn"

@onready var pop_click: AudioStreamPlayer = $pop_click
@onready var menu_buttons_container: VBoxContainer = $PanelContainer/VBoxContainer 
@onready var new_game: Button = $PanelContainer/VBoxContainer/new_game
@onready var continue_btn: Button = $PanelContainer/VBoxContainer/continue
@onready var quit: Button = $PanelContainer/VBoxContainer/quit

func _ready() -> void:
	#conecta o passar do mouse ao foco
	for button in menu_buttons_container.get_children():
		if button is Button:
			button.mouse_entered.connect(button.grab_focus)
	
	if new_game:
		continue_btn.grab_focus()

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
