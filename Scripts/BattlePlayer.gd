extends Node

@onready var MAIN:Panel = $"../CanvasLayer/Battle UI/NinePatchRect/Panel/Panel - Main Actions"
@onready var MOVES:Panel = $"../CanvasLayer/Battle UI/NinePatchRect/Panel/Panel - Move List"

@onready var MOVE_BUTTON1: Button = $"../CanvasLayer/Battle UI/NinePatchRect/Panel/Panel - Move List/Choice/Move 1"
@onready var MOVE_BUTTON2: Button = $"../CanvasLayer/Battle UI/NinePatchRect/Panel/Panel - Move List/Choice/Move 2"
@onready var MOVE_BUTTON3: Button = $"../CanvasLayer/Battle UI/NinePatchRect/Panel/Panel - Move List/Choice/Move 3"
@onready var MOVE_BUTTON4: Button = $"../CanvasLayer/Battle UI/NinePatchRect/Panel/Panel - Move List/Choice/Move 4"

var UI_move_button_array:Array = [MOVE_BUTTON1,MOVE_BUTTON2,MOVE_BUTTON3,MOVE_BUTTON4]

var UI_creature_active_array:Array = [] # Contains all the creatures,
var UI_creature_index: int = -1
var active_turn_creature: int = -1
var selected_target_creature: int = -1

var UI_move_array:Array = [] # Contains all the moves
var UI_move_index: int = -1
var selected_move: int = -1
var selected_item: int = -1

var canFlee: bool = false:
	set(new_value):
		canFlee = new_value
	get:
		return canFlee

enum INPUT_STATE {
	NO_INPUT,
	MAIN_SELECTION, 	# DEFAULT / MAIN MENU / TOP MENU
	ITEM_CREATURE_SELECTION,	# SELECT TARGET for ITEM
	MOVE_CREATURE_SELECTION,	# SELECT TARGET for MOVE
	ITEM_SELECTION,		# SELECTING an ITEM
	PARTY_SELECTION,	# SELECTION a PARTY MEMBER
	MOVE_SELECTION		# SELECTING A MOVE FROM PARTY
}

var _INTERFACE_INPUT_STATE:INPUT_STATE = INPUT_STATE.MAIN_SELECTION

func _process(delta):
	match _INTERFACE_INPUT_STATE:
		INPUT_STATE.ITEM_CREATURE_SELECTION:
			HandleCreatureUINavigaion()
		INPUT_STATE.MOVE_CREATURE_SELECTION:
			HandleCreatureUINavigaion()
		INPUT_STATE.MOVE_SELECTION:
			HandleMOVEUINavigaion()

func StartTurn(id: int):
	active_turn_creature = id
	selected_target_creature = 0
	UI_move_index = 0
	selected_move = 0
	selected_item = 0
	UI_creature_index = 0
	_INTERFACE_INPUT_STATE = INPUT_STATE.MAIN_SELECTION
	# start the rest

func YieldTurn():
	pass

func HandleCreatureItem():
	_INTERFACE_INPUT_STATE = INPUT_STATE.NO_INPUT
	# Do Action
	# Use Item (selected_item,selected_target_creature)
	YieldTurn()

#region Creature Navigation
func HandleCreatureUINavigaion():
	# Get index of target node, and request action
	if Input.is_action_just_pressed("Up"):
		if UI_creature_index > 0:
			UI_creature_index -= 1
			switch_creature_focus(UI_creature_index,UI_creature_index+1)
	if Input.is_action_just_pressed("Down"):
		if UI_creature_index < UI_creature_active_array.size() - 1:
			UI_creature_index += 1
			switch_creature_focus(UI_creature_index,UI_creature_index-1)
	if Input.is_action_just_pressed("Positive"):
		UI_creature_active_array[UI_creature_index].unfocus()
		selected_target_creature = UI_creature_index
		UI_creature_index = 0
		match _INTERFACE_INPUT_STATE:
			INPUT_STATE.ITEM_CREATURE_SELECTION:
				HandleCreatureItem()
			INPUT_STATE.MOVE_CREATURE_SELECTION:
				HandleCreatureMove()
	if Input.is_action_just_pressed("Negative"):
		UI_creature_active_array[UI_creature_index].unfocus()
		UI_creature_index = 0
		selected_target_creature = -1
		match _INTERFACE_INPUT_STATE:
			INPUT_STATE.ITEM_CREATURE_SELECTION:
				_on_item_pressed()
			INPUT_STATE.MOVE_CREATURE_SELECTION:
				_on_attack_pressed()

func switch_creature_focus(to,from):
	UI_creature_active_array[to].focus()
	UI_creature_active_array[from].unfocus()
#endregion

#region MAIN_SELECTION BUTTONS
func _on_item_pressed():
	if _INTERFACE_INPUT_STATE == INPUT_STATE.MAIN_SELECTION:
		_INTERFACE_INPUT_STATE = INPUT_STATE.ITEM_SELECTION
		MAIN.hide()
	
		# Do item navigation and item selection,
		# if item can be used, and more than 0 valid targets
	
		# filter unvalid away
		# start navigation
	
		# Remember desired Item
		# selected_item = item
		_INTERFACE_INPUT_STATE = INPUT_STATE.ITEM_CREATURE_SELECTION
		selected_target_creature = 0 # set to first valid target

func _on_attack_pressed():
	if _INTERFACE_INPUT_STATE == INPUT_STATE.MAIN_SELECTION:
		_INTERFACE_INPUT_STATE = INPUT_STATE.MOVE_SELECTION
		UI_move_index = 0
		MAIN.hide()
		UI_move_array = UI_creature_active_array[active_turn_creature].getMoves()
	
		# Populate Move UI / Update Button UI text
		for i in UI_move_button_array.size():
			UI_move_button_array[i].text = UI_move_array[i]#.text
	
		MOVES.show()

func _on_flee_pressed():
	if _INTERFACE_INPUT_STATE == INPUT_STATE.MAIN_SELECTION:
		if canFlee:
			# Do attempt calc FUNC
			if true:
				_INTERFACE_INPUT_STATE = INPUT_STATE.NO_INPUT
				# call battle end FUNC
			else:
				_INTERFACE_INPUT_STATE = INPUT_STATE.NO_INPUT
				YieldTurn()

func _on_party_pressed():
	if _INTERFACE_INPUT_STATE == INPUT_STATE.MAIN_SELECTION:
		_INTERFACE_INPUT_STATE = INPUT_STATE.PARTY_SELECTION
		MAIN.hide()
		# Show UI for party members, and enable party switch,
		# if switch success
		_INTERFACE_INPUT_STATE = INPUT_STATE.NO_INPUT
		YieldTurn()
		# else, do nothing
		#_INTERFACE_INPUT_STATE = INPUT_STATE.MAIN_SELECTION
#endregion

#region Move Handling
func HandleMOVEUINavigaion():
	# Listen for Navigation keys,
	# UP and DOWN,
	if Input.is_action_just_pressed("Up"):
		if UI_move_index > 0:
			UI_move_index -= 2
			switch_move_focus(UI_move_index,UI_move_index+2)
	if Input.is_action_just_pressed("Down"):
		if (UI_move_index) < UI_move_array.size() - 2:
			UI_move_index += 2
			switch_move_focus(UI_move_index,UI_move_index-2)
	# LEFT and RIGHT
	if Input.is_action_just_pressed("Left"):
		if UI_move_index > 0:
			UI_move_index -= 1
			switch_move_focus(UI_move_index,UI_move_index+1)
	if Input.is_action_just_pressed("Right"):
		if UI_move_index < UI_move_array.size() - 1:
			UI_move_index += 1
			switch_move_focus(UI_move_index,UI_move_index-1)
	# move Player UI Focus.
	if Input.is_action_just_pressed("Positive"):
		UI_move_array[UI_move_index].unfocus()
		selected_move = UI_move_index
		UI_move_index = 0
	if Input.is_action_just_pressed("Negative"):
		UI_move_array[UI_move_index].unfocus()
		selected_move = -1
		UI_move_index = 0
		
	pass

func switch_move_focus(to,from):
	# turn highlight on and off
	# [to].focus() # Highlight on
	# [from].unfocus() # Highlight off
	pass

func _on_move_1_pressed():
	move_pressed(1)

func _on_move_2_pressed():
	move_pressed(2)

func _on_move_3_pressed():
	move_pressed(3)

func _on_move_4_pressed():
	move_pressed(4)

func move_pressed(move:int):
	# Check if valid targets,
	# according to move,
	
	# if 2 or more valid targets, start navigation,
	# _INTERFACE_INPUT_STATE = INPUT_STATE.MOVE_CREATURE_SELECTION
	# creature_target = 0 # set to first valid target
	selected_move = move
	# Start Move Navigation
	
	# else if with 1 valid target
	selected_move = move
	HandleCreatureMove() 
	
	pass
	
func HandleCreatureMove():
	_INTERFACE_INPUT_STATE = INPUT_STATE.NO_INPUT
	# Do creature Move (selected_move,selected_target_creature)
	YieldTurn()
#endregion
