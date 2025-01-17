extends CharacterBody3D

@onready var _focus = $focus
@onready var progress_bar = $SubViewport/ProgressBar
@onready var animation_player = $AnimationPlayer

@export var MAX_HP:float = 10
@export var current_HP:float = 10

@export var is_Defeated: bool = false

@export var speed: float
@export var evasion: float
@export var accuracy: float

@export var special_attack: float
@export var special_defense: float

@export var attack: float
@export var defense: float

@export var move_array:Array = [] # Contains all the moves

@export var player: Node

func takeDamage(value):
	current_HP -= value
	if current_HP < 0:
		current_HP = 0
		is_Defeated = true
	_update_progressbar()
	_play_animation()
		
func _update_progressbar():
	progress_bar.value = (current_HP/MAX_HP) * 100

func _play_animation():
	animation_player.play("Hurt")
	
func focus():
	_focus.show()

func unfocus():
	_focus.hide()

func set_max_heatlth(value):
	MAX_HP = value
	current_HP = value

func set_heatlth(value):
	current_HP = value

func getMoves() -> Array:
	return move_array

func addMove(move:Object) -> void:
	move_array.append(move)

func removeMove(index:int) -> void:
	move_array.remove_at(index)

func changeMovePosition(index1:int,index2:int) -> void:
	var tempMove1 = move_array[index1]
	move_array[index1] = move_array[index2]
	move_array[index2] = tempMove1
