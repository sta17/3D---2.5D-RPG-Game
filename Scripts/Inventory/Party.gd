extends Resource
class_name Party

signal update

@export var CreatureSlots: Array[CurrentCreature]

func _ready():
	var i: int = 0
	for slot in CreatureSlots:
		slot.index = i
		i = i + 1

func Add(creature: CurrentCreature):
	var emptyslots = CreatureSlots.filter(func(slot): return slot == null)
	if !emptyslots.is_empty():
		emptyslots[0] = creature
	update.emit()

func Add_at_Index(creature: CurrentCreature, slotnumber: int) -> bool:
	if CreatureSlots[slotnumber] == null:
		CreatureSlots[slotnumber] = creature
		update.emit()
		return true
	return false

func Check_Addable_at_Index(creature: CurrentCreature, slotnumber: int) -> bool:
	if CreatureSlots[slotnumber] == creature:
		return true
	else:
		if CreatureSlots[slotnumber] == null:
			return true
	return false

func Remove_at_Index(slotnumber: int) -> bool:
	CreatureSlots[slotnumber] = null
	update.emit()
	return true

func getCreature(i:int):
	return CreatureSlots[i]
	
