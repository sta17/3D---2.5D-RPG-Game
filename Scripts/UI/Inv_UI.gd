extends Control

var is_single_open = false
var is_multi_open = false

@onready var inv: Inv = preload("res://Scenes/Inventory/Player_Inventory.tres")
@onready var multi_inv: Inv = preload("res://Scenes/Inventory/MultiStorage.tres")
@onready var slots: Array = $"Single Inventory/NinePatchRect/GridContainer".get_children()
@onready var multi_Inventory_slots: Array = $"Multi Inventory/Char_invent/GridContainer".get_children()
@onready var multi_Inventory_chest_slots: Array = $"Multi Inventory/Chest_invent/GridContainer".get_children()

@onready var singleSection:Control = $"Single Inventory"
@onready var multiSection:Control = $"Multi Inventory"

@onready var tooltip:Control = $Tooltip
@onready var tooltipName:Label = $Tooltip/NinePatchRect/MarginContainer/GridContainer/Tooltip_Name
@onready var tooltipDesc:Label = $Tooltip/NinePatchRect/MarginContainer/GridContainer/Tooltip_Properties
@onready var tooltipLoreTitle:Label = $Tooltip/NinePatchRect/MarginContainer/GridContainer/Tooltip_Lore_Title
@onready var tooltipLoreDesc:Label = $Tooltip/NinePatchRect/MarginContainer/GridContainer/Tooltip_Lore_Desc
@onready var tooltipRank:Label = $Tooltip/NinePatchRect/MarginContainer/GridContainer/Tooltip_Rank


@export var default_cursor: Texture
@export var coin_cursor: Texture
@export var book_cursor: Texture
@export var bottle_cursor: Texture
@export var setting_cursor: Texture
@export var cross_cursor: Texture
@export var compass_cursor: Texture

func _process(delta):
	# Make tooltip location same as mouse location
	if tooltip.visible:
		tooltip.position = get_global_mouse_position()
		tooltip.position = tooltip.position + Vector2(6,8)

func _ready():
	inv.update.connect(update_slots)
	for i in range(min(inv.slots.size(),slots.size())):
		slots[i].index = i
		slots[i].inv = inv
		slots[i].tooltiphandler = self
	inv.update.connect(update_multi_slots)
	for i in range(min(inv.slots.size(),multi_Inventory_slots.size())):
		multi_Inventory_slots[i].index = i
		multi_Inventory_slots[i].inv = inv
		multi_Inventory_slots[i].tooltiphandler = self
	multi_inv.update.connect(update_multi_slots)
	for i in range(min(multi_inv.slots.size(),multi_Inventory_chest_slots.size())):
		multi_Inventory_chest_slots[i].index = i
		multi_Inventory_chest_slots[i].inv = multi_inv
		multi_Inventory_chest_slots[i].tooltiphandler = self
	update_slots()
	update_multi_slots()
	close()
	update_cursor()
	hide_tooltip()

func update_slots():
	for i in range(min(inv.slots.size(),slots.size())):
		slots[i].update(inv.slots[i])

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

func open():
	singleSection.visible = true
	is_single_open = true

func openMulti():
	multiSection.visible = true
	is_multi_open = true

func close():
	singleSection.visible = false
	multiSection.visible = false
	is_single_open = false
	is_multi_open = false

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
