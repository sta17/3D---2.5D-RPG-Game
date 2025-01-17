extends Control

var is_single_open = false
var is_multi_open = false

var is_main_menu_open = false
var is_party_open = false
var is_options_open = false
var is_bestiary_open = false

@onready var mainMenuSection:Control = $"CanvasLayer/Main Menu"
@onready var partySection:Control = $CanvasLayer/Party
@onready var optionsSection:Control = $CanvasLayer/Options
@onready var bestiarySection:Control = $CanvasLayer/Bestiary

@onready var PlayerParty: Party = preload("res://Scenes/Inventory/Party.tres")

#region Inventory
@onready var inv: Inv = preload("res://Scenes/Inventory/Player_Inventory.tres")
@onready var multi_inv: Inv = preload("res://Scenes/Inventory/MultiStorage.tres")

@onready var slots: Array = $"CanvasLayer/Single Inventory/NinePatchRect/GridContainer".get_children()
@onready var multi_Inventory_slots: Array = $"CanvasLayer/Multi Inventory/Control/Char_invent/GridContainer".get_children()
@onready var multi_Inventory_chest_slots: Array = $"CanvasLayer/Multi Inventory/Control/Chest_invent/GridContainer".get_children()

@onready var singleSection:Control = $"CanvasLayer/Single Inventory"
@onready var multiSection:Control = $"CanvasLayer/Multi Inventory"
#endregion

#region Tooltip
@onready var tooltip:Control = $CanvasLayer/Tooltip
@onready var tooltipName:Label = $CanvasLayer/Tooltip/NinePatchRect/MarginContainer/GridContainer/Tooltip_Name
@onready var tooltipDesc:Label = $CanvasLayer/Tooltip/NinePatchRect/MarginContainer/GridContainer/Tooltip_Properties
@onready var tooltipLoreTitle:Label = $CanvasLayer/Tooltip/NinePatchRect/MarginContainer/GridContainer/Tooltip_Lore_Title
@onready var tooltipLoreDesc:Label = $CanvasLayer/Tooltip/NinePatchRect/MarginContainer/GridContainer/Tooltip_Lore_Desc
@onready var tooltipRank:Label = $CanvasLayer/Tooltip/NinePatchRect/MarginContainer/GridContainer/Tooltip_Rank
#endregion

#region Cursors
@export var default_cursor: Texture
@export var coin_cursor: Texture
@export var book_cursor: Texture
@export var bottle_cursor: Texture
@export var setting_cursor: Texture
@export var cross_cursor: Texture
@export var compass_cursor: Texture
#endregion

func _process(delta):
	# Make tooltip location same as mouse location
	if tooltip.visible:
		tooltip.position = get_global_mouse_position()
		tooltip.position = tooltip.position + Vector2(6,8)

func _ready():
	# Misc
	update_cursor()
	# Inv Slots
	
	inv.update.connect(update_slots_inventory)
	for i in range(min(inv.slots.size(),slots.size())):
		slots[i].index = i
		slots[i].inv = inv
		slots[i].multi_handler = self
		slots[i].tooltiphandler = self
	inv.update.connect(update_multi_slots)
	for i in range(min(inv.slots.size(),multi_Inventory_slots.size())):
		multi_Inventory_slots[i].index = i
		multi_Inventory_slots[i].inv = inv
		multi_Inventory_slots[i].multi_handler = self
		multi_Inventory_slots[i].tooltiphandler = self
	multi_inv.update.connect(update_multi_slots)
	for i in range(min(multi_inv.slots.size(),multi_Inventory_chest_slots.size())):
		multi_Inventory_chest_slots[i].index = i
		multi_Inventory_chest_slots[i].inv = multi_inv
		multi_Inventory_chest_slots[i].multi_handler = self
		multi_Inventory_chest_slots[i].tooltiphandler = self
	update_slots_inventory()
	update_multi_slots()
	
	partySection.PlayerParty = PlayerParty
	partySection._ready()
	PlayerParty.update.connect(update_slots_Party)
	update_slots_Party()
	
	# Hide UIs
	closeUI()

func update_cursor():
	# USED FOR SCALING CURSOR
	#var current_window_size_Width = ProjectSettings.get_setting("display/window/size/viewport_width")
	#var current_window_size_Height = ProjectSettings.get_setting("display/window/size/viewport_height")
	#var scale_multiple = current_window_size_Width / current_window_size_Height

	#AVAILABLE CURSORS

	#default_cursor
	#coin_cursor
	#book_cursor
	#bottle_cursor
	#setting_cursor
	#cross_cursor
	#compass_cursor

	#							  CURSOR TO USE		  USE CASE		  ARROW TIP
	Input.set_custom_mouse_cursor(default_cursor, Input.CURSOR_ARROW,Vector2(7, 6))
	Input.set_custom_mouse_cursor(default_cursor, Input.CURSOR_CAN_DROP,Vector2(7, 6))
	#								TODO: NO ACTION / CROSS
	Input.set_custom_mouse_cursor(cross_cursor, Input.CURSOR_FORBIDDEN,Vector2(7, 6))

func closeUI():
	closeMainMenu()
	closeSingle()
	closeMulti()
	closeParty()
	hide_tooltip()

func NegativeInput():
	pass

func PositiveInput():
	pass

#region Main Menu
func _on_bestiary_button_pressed():
	pass # Replace with function body.

func _on_party_button_pressed():
	closeMainMenu()
	openParty()

func _on_inventory_button_pressed():
	closeMainMenu()
	openSingle()
	is_single_open = true

func _on_options_button_pressed():
	pass # Replace with function body.

func _on_save_button_pressed():
	pass # Replace with function body.

func _on_exit_button_pressed():
	get_tree().quit()

func openMainMenu():
	mainMenuSection.visible = true
	is_main_menu_open = true

func closeMainMenu():
	mainMenuSection.visible = false
	is_main_menu_open = false
#endregion

#region Party
func update_slots_Party():
	partySection.LoadParty()

func openParty():
	partySection.visible = true
	is_party_open = true

func closeParty():
	partySection.visible = false
	is_party_open = false
#endregion

#region Single Window Inventory
func update_slots_inventory():
	for i in range(min(inv.slots.size(),slots.size())):
		slots[i].update(inv.slots[i])

func openSingle():
	singleSection.visible = true
	is_single_open = true

func closeSingle():
	singleSection.visible = false
	is_single_open = false
#endregion

#region Multi Window Inventory
func moveDoubleClick(data : Dictionary):
	if data["inv"] == multi_inv:
		var result = inv.AddWithAmount(data["SlotData"].Item,data["SlotData"].amount)
		if result:
			data["inv"].Remove_at_Index(data["Slot"].index)
			data["Slot"].RemoveSlotData()
		
	elif data["inv"] == inv:
		var result = multi_inv.AddWithAmount(data["SlotData"].Item,data["SlotData"].amount)
		if result:
			data["inv"].Remove_at_Index(data["Slot"].index)
			data["Slot"].RemoveSlotData()

func update_multi_slots():
	for i in range(min(inv.slots.size(),multi_Inventory_slots.size())):
		multi_Inventory_slots[i].update(inv.slots[i])
	for i in range(min(multi_inv.slots.size(),multi_Inventory_chest_slots.size()),max(multi_inv.slots.size(),multi_Inventory_chest_slots.size())):
		multi_Inventory_chest_slots[i].hide_main_slot_visual()
	for i in range(min(multi_inv.slots.size(),multi_Inventory_chest_slots.size())):
		multi_Inventory_chest_slots[i].show_main_slot_visual()
		multi_Inventory_chest_slots[i].inv = multi_inv
		multi_Inventory_chest_slots[i].update(multi_inv.slots[i])

func SetMultiSlot(newInv:Inv):
	multi_inv = newInv
	update_multi_slots()

func openMulti():
	multiSection.visible = true
	is_multi_open = true

func closeMulti():
	multiSection.visible = false
	is_multi_open = false
#endregion

#region Tooltip
func setToolTipName(name: String,desc: String):
	tooltipName.text = name
	if desc == "":
		tooltipDesc.visible = false
	else:
		tooltipDesc.visible = true
		tooltipDesc.text = desc

func setToolTipLore(desc: String,title = "Lore"):
	if desc == "":
		tooltipLoreTitle.visible = false
		tooltipLoreDesc.visible = true
	else:
		tooltipLoreTitle.visible = true
		tooltipLoreDesc.visible = true
		tooltipLoreTitle.text = title
		tooltipLoreDesc.text = desc

func setToolTipRank(Rank: ItemCategory,hide:bool=false):
	if hide:
		tooltipRank.visible = true
	else:
		tooltipRank.visible = false
		tooltipRank.add_theme_color_override("font_color",Rank.color)
		tooltipRank.text = Rank.name

func show_tooltip():
	tooltip.visible = true
	
func hide_tooltip():
	tooltip.visible = false
#endregion
