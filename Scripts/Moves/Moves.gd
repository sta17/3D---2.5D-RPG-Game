@icon("res://Assets/Mine/CreatureIcon.svg")
extends Resource
class_name AbilityMoves

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

enum CATEGORIES {
	NONE,
	PHYSICAL,
	SPECIAL,
	STATUS
}

enum TARGETS {
	NONE,
	SELF,
	ALLY,
	FOE
}

@export var Name:String

@export var MoveType:TYPES
@export var Category:CATEGORIES

@export var PowerPoints: float
@export var Power: float
@export var Accuracy: float

@export var ValidTargets:Array
