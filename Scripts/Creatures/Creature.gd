@icon("res://Assets/Mine/CreatureIcon.svg")
extends Resource
class_name BaseCreature

enum TYPES {
	NONE,
	NEUTRAL,
	FIRE,
	EARTH,
	WATER,
	NATURE,
	ELECTRIC,
	WIND,
	TOXIC,
	MENTAL,
	UNDEAD,
	DARKNESS,
	SHADOW,
	MARTIAL,
	ARCANA
}

@export var Name:String

@export var PartyTexture:Texture

@export var MainType:TYPES
@export var SubType:TYPES

@export var Base_HP:float

@export var Base_Speed: float

@export var Base_Special_Attack: float
@export var Base_Special_Defense: float

@export var Base_Attack: float
@export var Base_Defense: float

# FORMAT IS: LEVEL - [MOVE,MOVE]
@export var move_array:Dictionary = {}
# Dictonary with level as key, 
# contain a array of moves
