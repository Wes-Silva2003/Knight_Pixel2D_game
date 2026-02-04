extends Node

@onready var label_points: Label = $Control/LabelPoints
@onready var label_lifes: Label = $Control/LabelLifes
@onready var label_record: Label = $Control/LabelRecord
@onready var button_pause: Button = $Button_pause
@onready var pop_click: AudioStreamPlayer = $pop_click

#atualiza as informações na tela o tempo todo
func _process(_delta):
	label_points.text = "Points: " + str(GameManager.points)
	label_record.text = "Record: " + str(GameManager.record)
	label_lifes.text = "Lifes: " + str(GameManager.lifes)

#se precionar o icone de pausa emite um sinal para pausar o jogo
func _on_button_pause_pressed() -> void:
	pop_click.play()
	GameManager.pause_game.emit()
	
