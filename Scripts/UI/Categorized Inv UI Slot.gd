extends "res://Scripts/UI/Inv_UI_Slot.gd"

@export var ItemSilhouette:Texture
@export var categories : Array[ItemCategory]

@onready var Silhouette:Sprite2D = $Silhouette

func _ready():
	if ItemSilhouette:
		Silhouette.texture = ItemSilhouette
		Silhouette.visible = true

func update(slot: InvSlot):
	if !slot.Item:
		hide_slot_visual()
		filled = false
	else:
		slotData = slot
		item_visual.texture = slot.Item.icon
		amount_text.visible = false
		if slot.amount > 1 :#or slot.amount != null:
			amount_text.text = str(slot.amount)
			amount = slot.amount
			amount_text.visible = true
		filled = true
		item_visual.visible = true

func hide_slot_visual():
	item_visual.visible = false
	amount_text.visible = false
	amount_text.text = ""
	Silhouette.visible = true
	
func show_slot_visual():
	item_visual.visible = true
	amount_text.visible = true
	Silhouette.visible = false

func _on_gui_input(event: InputEvent):
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
	if event is InputEventMouseButton and event.double_click:
		print("You selected:", self.name, " On GUI Double Click")
		
		if multi_handler:
			
			var data : Dictionary
			data["SlotData"] = slotData
			data["Slot"] = self
			data["inv"] = inv
			
			multi_handler.moveDoubleClick(data)
			tooltiphandler.hide_tooltip()

func _can_drop_data(at_position, data):
	var IncomingSlotData: InvSlot = data["SlotData"]
	if data is Dictionary:
		if IncomingSlotData == null:
			return false
		if data["Slot"] == null:
			return false
		if dragging:
			return false
		if data["Slot"] == self:
			return false
		if(IncomingSlotData.Item.categories in categories):
			if(inv.Check_Addable_at_Index(IncomingSlotData,index)):
				return true
			else:
				return false
		return false

func _on_mouse_entered():
	if filled and !dragging:
		tooltiphandler.setToolTipName(slotData.Item.name,"")
		tooltiphandler.setToolTipLore(slotData.Item.properties["Lore"])
		tooltiphandler.setToolTipRank(slotData.Item.properties["Rank"])
		tooltiphandler.show_tooltip()
	
func _on_mouse_exited():
	if filled:
		tooltiphandler.hide_tooltip()

func _on_hidden():
	if tooltiphandler:
		tooltiphandler.hide_tooltip()
