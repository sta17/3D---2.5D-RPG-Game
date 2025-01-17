extends Node3D

var enemies: Array = []
var players: Array = []

var turnorder: Array = []

# JRPG Turn Based Combat Tutorial in Godot 4
# https://www.youtube.com/watch?v=HEexLmt7enc

# UI Elements for Main: Attack moves, Items, Party, Flee
# Inventory - Inventory UI Hook, send item to BattleScene and get reaction.
# Party Do party List, switch currently selected slot out with party.
# Attack moves, list of legal moves.
#	- Show Name, how much to left to spend of stamina / PP moves left and Move type
# Flee, flee if wild creature battle.

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
