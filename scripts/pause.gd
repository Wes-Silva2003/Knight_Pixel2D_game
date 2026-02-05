extends CanvasLayer

var pending_action: String = ""

@onready var menu_holder: VBoxContainer = $menu_holder
@onready var resume: Button = $menu_holder/resume
@onready var restart: Button = $menu_holder/restart
@onready var save: Button = $menu_holder/save
@onready var loading: Button = $menu_holder/load
@onready var quit: Button = $menu_holder/quit
@onready var warning_screen: Control = $warning_screen
@onready var title: Label = $warning_screen/warning/title
@onready var message: Label = $warning_screen/warning/message
@onready var ok_btn: Button = $warning_screen/warning/ok
@onready var cancel_btn: Button = $warning_screen/warning/cancel
@onready var pop_click: AudioStreamPlayer = $pop_click

func _ready() -> void:
	GameManager.pause_game.connect(pause_menu) #sinal chamado ao clicar no icone de pausa
	
	#conecta o mouse para dar foco nos botões
	for button in menu_holder.get_children():
		if button is Button:
			button.mouse_entered.connect(button.grab_focus)

	if ok_btn: 
		ok_btn.pressed.connect(_on_ok_pressed)
		ok_btn.mouse_entered.connect(ok_btn.grab_focus)
		
	if cancel_btn: 
		cancel_btn.pressed.connect(_on_cancel_pressed)
		cancel_btn.mouse_entered.connect(cancel_btn.grab_focus)
	
	visible = false
	warning_screen.visible = false

func _process(_delta: float) -> void: #se pressionar "P" ou "Esc" chama o menu de pausa
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("pause"): 
		if warning_screen.visible:
			_on_cancel_pressed()
		elif visible:
			_on_resume_pressed()
		else:
			pause_menu()

#deixa visivel o menu de pausa
func pause_menu():
	visible = true
	menu_holder.visible = true
	warning_screen.visible = false
	get_tree().paused = true
	resume.grab_focus() #foca no resume para controlar pelo teclado alem do mouse

#oculta o menu de pausa
func _on_resume_pressed():
	pop_click.play()
	get_tree().paused = false
	visible = false

#reinicia a fase
func _on_restart_pressed():
	pop_click.play()
	show_warning("restart", "RESTART GAME", "Are you sure you want to restart the game?")

#salva o jogo
func _on_save_pressed():
	pop_click.play()
	show_warning("save", "SAVE GAME", "Are you sure you want to save the game?")

#carrega o ultimo save
func _on_load_pressed():
	pop_click.play()
	show_warning("load", "LOAD GAME", "Unsaved progress will be lost. Load last save?")

#volta para o menu inicial
func _on_quit_pressed():
	pop_click.play()
	show_warning("quit", "QUIT GAME", "Exit to menu? Unsaved progress will be lost.")

#para aparecer o painel de aviso
func show_warning(action: String, title_text: String, message_text: String):
	pending_action = action
	title.text = title_text
	message.text = message_text
	
	menu_holder.visible = false
	warning_screen.visible = true
	
	if cancel_btn: cancel_btn.grab_focus()

func _on_ok_pressed():
	pop_click.play()
	
	match pending_action:
		"restart":
			GameManager._reset_all_data()
			get_tree().paused = false
			get_tree().reload_current_scene()
			visible = false
		
		"save":
			GameManager.save_game()
			close_warning()
			
		"load":
			get_tree().paused = false
			visible = false
			GameManager.load_game()
			
		"quit":
			get_tree().paused = false
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
	pending_action = ""

func _on_cancel_pressed():
	pop_click.play()
	close_warning()

func close_warning():
	warning_screen.visible = false
	menu_holder.visible = true
	pending_action = ""
	resume.grab_focus()
