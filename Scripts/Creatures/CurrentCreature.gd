@icon("res://Assets/Mine/CreatureIcon.svg")
extends Resource
class_name CurrentCreature

enum CREATURE_TYPES {
	STANDARD,
	PERSON
}

@export var baseCreature: BaseCreature

@export var creaturetype: CREATURE_TYPES = CREATURE_TYPES.STANDARD

@export var DisplayName:String
@export var Current_HP:float

@export var Current_Level:int
@export var Current_Experience:float

@export var Current_Speed: float
@export var Current_Special_Attack: float
@export var Current_Special_Defense: float
@export var Current_Attack: float
@export var Current_Defense: float

@export var index:int

# List of all moves,
@export var move_array:Dictionary = {}
