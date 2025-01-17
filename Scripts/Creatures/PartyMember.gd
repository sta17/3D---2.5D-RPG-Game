@icon("res://Assets/Mine/CreatureIcon.svg")
extends "res://Scripts/Creatures/CurrentCreature.gd"
class_name PartyMember

@export var BodyAttribute:float
@export var BodyAttribute_INCREASE_PER_LEVEL:float
@export var FinesseAttribute:float
@export var FinesseAttribute_INCREASE_PER_LEVEL:float
@export var MindAttribute:float
@export var MindAttribute_INCREASE_PER_LEVEL:float
@export var ConstitutionAttribute:float
@export var ConstitutionAttribute_INCREASE_PER_LEVEL:float
@export var AetherAttribute:float
@export var AetherAttribute_INCREASE_PER_LEVEL:float

@export var HP_INCREASE_PER_LEVEL:float
@export var Speed_INCREASE_PER_LEVEL: float
@export var Special_Attack_INCREASE_PER_LEVEL: float
@export var Special_Defense_INCREASE_PER_LEVEL: float
@export var Attack_INCREASE_PER_LEVEL: float
@export var Defense_INCREASE_PER_LEVEL: float

# FORMAT IS: SKILL - [MOVE,MOVE]
@export var skill_array:Dictionary = {}
# Dictonary with skill as key, 
# contain a array of moves

# List of item slots for equipment, personal inventory.

func _ready():
	creaturetype = CREATURE_TYPES.PERSON
