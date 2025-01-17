extends Node3D

@onready var PLAYERS = $Player
@onready var ENEMIES = $Enemy

var enemies: Array = []
var players: Array = []

var turnorder: Array = []

var turnStart = true
var turnYielded = true

var canFlee: bool = false

# JRPG Turn Based Combat Tutorial in Godot 4
# https://www.youtube.com/watch?v=HEexLmt7enc

# How to create a Turn-based Combat System in Godot
# https://www.youtube.com/watch?v=ifXGvlAn0bY

# UI Elements for Main: Attack moves, Items, Party, Flee
# Inventory - Inventory UI Hook, send item to BattleScene and get reaction.
# Party Do party List, switch currently selected slot out with party.
# Attack moves, list of legal moves.
#	- Show Name, how much to left to spend of stamina / PP moves left and Move type
# Flee, flee if wild creature battle.

func _ready():
	players = PLAYERS.get_children()
	enemies = ENEMIES.get_children()
	
	PLAYERS.set("canFlee",canFlee)
	PLAYERS.set("player",PLAYERS)
	ENEMIES.set("canFlee",canFlee)
	ENEMIES.set("player",ENEMIES)

func _process(delta):
	if turnYielded and turnorder.size() == 0:
		TurnOverHandling()
		turnStart = true
	
	if turnStart:
		SortTurnOrderBySpeed()
		turnStart = false
	
	# await signal, from creature about act over.
	if turnYielded:
		turnYielded = false
		SignalNextCreature()
	
func YieldTurn():
	# attach to players somehow 
	# and have them use at end
	turnYielded = true
	
func SortTurnOrderBySpeed():
	turnorder = players
	# Add again later after testing
	#turnorder.append_array(enemies)
	#turnorder.sort_custom(sort_ascending)

func TurnOverHandling():
	# resolve all outstanding status effects,
	# check if living teams,
	# declear victory if team ended
	# Do victory handling.
	# End with signal system to handle battle / overworld continue
	# End with queue.free()
	pass

func SignalNextCreature():
	turnorder[0].player.StartTurn(turnorder[0])
	turnorder.remove_at(0)

func sort_ascending(a, b):
	if a[0].speed < b[0].speed:
		return true
	return false
