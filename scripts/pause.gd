extends CanvasLayer

@onready var resume: Button = $menu_holder/resume
@onready var restart: Button = $menu_holder/restart
@onready var save: Button = $menu_holder/save
@onready var loading: Button = $menu_holder/load
@onready var quit: Button = $menu_holder/quit
@onready var pop_click: AudioStreamPlayer = $pop_click

func _ready() -> void:
	GameManager.pause_game.connect(menu_pause) #sinal chamado ao clicar no icone de pausa
	visible = false

func _process(_delta: float) -> void: #se pressionar "P" ou "Esc" chama o menu de pausa
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("pause"): # Esc ou P
		if visible:
			_on_resume_pressed()
		else:
			menu_pause()

#deixa visivel o menu de pausa
func menu_pause():
		visible = true
		get_tree().paused = true
		resume.grab_focus() #foca no resume para controlar pelo teclado alem do mouse

#oculta o menu de pausa
func _on_resume_pressed() -> void:
	pop_click.play()
	get_tree().paused = false
	visible = false

#reinicia a fase 
func _on_restart_pressed() -> void:
	pop_click.play()
	GameManager._reset_all_data()
	get_tree().paused = false
	get_tree().reload_current_scene()
	visible = false

#salva o jogo
func _on_save_pressed() -> void:
	pop_click.play()
	GameManager.save_game()

#carrega o ultimo save
func _on_load_pressed() -> void:
	pop_click.play()
	get_tree().paused = false
	visible = false
	GameManager.load_game()

#volta para o menu inicial
func _on_quit_pressed() -> void:
	pop_click.play()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
