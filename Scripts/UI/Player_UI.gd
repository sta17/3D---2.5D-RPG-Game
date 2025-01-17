extends Control

var is_single_open = false
var is_multi_open = false
var is_item_display_open = false

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

@onready var single_player:Control = $"CanvasLayer/Single Inventory/Control"
@onready var multi_player:Control = $"CanvasLayer/Multi Inventory/CenterContainer/GridContainer/Player"
@onready var multi_interact:Control = $"CanvasLayer/Multi Inventory/CenterContainer/GridContainer/Interactable"
@onready var player_Item_Display:Control = $"CanvasLayer/ItemDisplay Inventory/CenterContainer/GridContainer/Player"
@onready var party_Item_Display:Control = $"CanvasLayer/ItemDisplay Inventory/CenterContainer/GridContainer/PartyMember"

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
	$CanvasLayer/Party.visible = true
	$"CanvasLayer/Main Menu".visible = true
	#$"CanvasLayer/Single Inventory".visible = true
	$"CanvasLayer/Multi Inventory".visible = true
	$CanvasLayer/Tooltip.visible = true
	$"CanvasLayer/ItemDisplay Inventory".visible = true
	#$CanvasLayer/Options.visible = true
	#$CanvasLayer/Bestiary.visible = true
	
	update_cursor()
	
	partySection.PlayerParty = PlayerParty
	partySection._ready()
	PlayerParty.update.connect(update_slots_Party)
	update_slots_Party()
	
	single_player.setup(self,null)
	single_player.rescale(inv)
	
	multi_player.setup(self,self)
	multi_player.rescale(inv)
	
	multi_interact.setup(self,self)
	multi_interact.rescale(multi_inv)
	
	player_Item_Display.setup(self,self)
	player_Item_Display.rescale(inv)
	
	party_Item_Display.setup(self,self)
	
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
	closeMainMenu()
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

#region Inventory
func openSingle():
	is_single_open = true
	single_player.open()
	openItemDisplay()

func closeSingle():
	is_single_open = false
	single_player.close()
	closeItemDisplay()

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

func SetMultiSlot(newInv:Inv):
	multi_inv = newInv
	multi_interact.rescale(multi_inv)

func openMulti():
	is_multi_open = true
	multi_player.open()
	multi_interact.open()

func closeMulti():
	is_multi_open = false
	multi_player.close()
	multi_interact.close()

func openItemDisplay():
	is_item_display_open = true
	player_Item_Display.open()
	party_Item_Display.open()

func closeItemDisplay():
	is_item_display_open = false
	player_Item_Display.close()
	party_Item_Display.close()
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
