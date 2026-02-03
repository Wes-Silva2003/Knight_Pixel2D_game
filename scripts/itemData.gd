extends Resource

#declara a classe 
class_name ItemData 

#define se é moeda ou vida
@export_enum("Coin", "Life") var item_type: String = "Coin"

#define o valor
@export var value: int = 1

#animação da tela
@export var animation_frames: SpriteFrames

#o som da coleta do item
@export var sound_effect: AudioStream
