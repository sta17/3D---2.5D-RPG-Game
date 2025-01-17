extends Control

#region Variables
@onready var P1:Control = $NinePatchRect/GridContainer/P1
@onready var P2:Control = $NinePatchRect/GridContainer/P2
@onready var P3:Control = $NinePatchRect/GridContainer/P3
@onready var P4:Control = $NinePatchRect/GridContainer/P4
@onready var P5:Control = $NinePatchRect/GridContainer/P5
@onready var P6:Control = $NinePatchRect/GridContainer/P6
@onready var PartyArray: Array = [P1,P2,P3,P4,P5,P6]
#endregion

@onready var PlayerParty: Party

func _ready():
	# Inv Slots
	for i in range(PartyArray.size()):
		PartyArray[i].index = i
		PartyArray[i].PlayerParty = PlayerParty
		PartyArray[i].hide_highlight()

func AddSlot(creature:CurrentCreature,slot:int):
	PartyArray[slot].update(creature)

func RemoveSlot(slot:int):
	PartyArray[slot].RemoveSlot()

func LoadParty():
	for i in range(min(PlayerParty.CreatureSlots.size(),PlayerParty.CreatureSlots.size())):
		var c = PlayerParty.getCreature(i)
		if c == null:
			RemoveSlot(i)
		else:
			AddSlot(PlayerParty.getCreature(i),i)

func ClearParty():
	var i:int = 0
	for creature in PartyArray:
		RemoveSlot(i)
		i=i+1

func SelectSlot(slot:int):
	PartyArray[slot].show_highlight()
	
func DeSelectSlot(slot:int):
	PartyArray[slot].hide_highlight()
	
func DeSelectAll():
	for i in range(PartyArray.size()):
		DeSelectSlot(i)
