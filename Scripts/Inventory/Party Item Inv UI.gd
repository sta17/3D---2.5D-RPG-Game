extends Control

@export var inventorySize: int = 5

var is_items_open = false
var is_single_open = false
var is_many_open = false

var slotsSingle: Array
@export var invSingle: Inv

var slotsMany: Array
@export var invMany: Inv

var tooltiphandler: Object
var multi_handler: Object

var xSize: int
var ySize: int

@onready var singleSection:NinePatchRect = $Chest_invent

@onready var SlotholderMany:GridContainer = $Chest_invent/ManyItems
@onready var SlotholderSingle:GridContainer = $Chest_invent/SingleItem

@onready var slot1:Control = $"Chest_invent/GridContainer/Categorized Inv UI Slot"

func _ready():
	slotsMany = SlotholderMany.get_children()
	slotsSingle = SlotholderSingle.get_children()

func setup(Newtooltiphandler: Object,Newmulti_handler: Object):
	tooltiphandler = Newtooltiphandler
	if Newmulti_handler:
		multi_handler = Newmulti_handler

func rescale(invNew: Inv):
	DoDisConnect()
	
	if is_single_open:
		invSingle = invNew
		for i in range(0,slotsSingle.size()):
			slotsSingle[i].RemoveSlotData()
			slotsSingle[i].hide_main_slot_visual()
	elif is_many_open:
		invMany = invNew
		for i in range(0,slotsMany.size()):
			slotsMany[i].RemoveSlotData()
			slotsMany[i].hide_main_slot_visual()
	
	DoConnect()

func DoConnect():
	if is_single_open:
		invSingle.update.connect(update_slots_inventory)
		for i in invSingle.slots.size():
			slotsSingle[i].index = i
			slotsSingle[i].inv = invSingle
			if multi_handler:
				slotsSingle[i].multi_handler = multi_handler
			slotsSingle[i].tooltiphandler = tooltiphandler
			slotsSingle[i].show_main_slot_visual()
	elif is_many_open:
		pass
		invMany.update.connect(update_slots_inventory)
		for i in invMany.slots.size():
			slotsMany[i].index = i
			slotsMany[i].inv = invMany
			if multi_handler:
				slotsMany[i].multi_handler = multi_handler
			slotsMany[i].tooltiphandler = tooltiphandler
			slotsMany[i].show_main_slot_visual()
	update_slots_inventory()

func DoDisConnect():
	if invSingle:
		invSingle.update.disconnect(update_slots_inventory)
	if invMany:
		invMany.update.disconnect(update_slots_inventory)

func update_slots_inventory():
	if is_single_open:
		for i in invSingle.slots.size():
			slotsSingle[i].inv = invMany
			slotsSingle[i].update(invMany.slots[i])
	elif is_many_open:
		for i in invMany.slots.size():
			slotsMany[i].inv = invMany
			slotsMany[i].update(invMany.slots[i])

#region Open and Close
func open():
	singleSection.visible = true
	is_items_open = true

func close():
	singleSection.visible = false
	is_items_open = false

func openSingle():
	SlotholderSingle.visible = true
	is_single_open = true
	open()

func closeSingle():
	SlotholderSingle.visible = false
	is_single_open = false
	close()

func openMany():
	SlotholderMany.visible = true
	is_many_open = true
	open()

func closeMany():
	SlotholderMany.visible = false
	is_many_open = false
	close()
#endregion
