extends Panel

@onready var item_visual: Sprite2D = $CenterContainer/Panel/item_display
@onready var amount_text:Label = $CenterContainer/Panel/Label
@onready var frame:Sprite2D = $Sprite2D
@onready var mainslot:Panel = $"."

@onready var tooltiphandler

@export var index: int

var inv: Inv

var multi_handler: Object

var dragging: bool = false
var filled: bool = false
var amount: int

var slotData: InvSlot

func update(slot: InvSlot):
	if !slot.Item:
		hide_slot_visual()
		filled = false
	else:
		show_slot_visual()
		slotData = slot
		item_visual.texture = slot.Item.icon
		if slot.amount > 1:
			amount_text.text = str(slot.amount)
			amount = slot.amount
		else:
			amount_text.visible = false
			amount = 1
		filled = true

func _on_gui_input(event: InputEvent):
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
	if event is InputEventMouseButton and event.double_click:
		print("You selected:", self.name, " On GUI Double Click")
		
		if multi_handler != null:
			
			var data : Dictionary
			data["SlotData"] = slotData
			data["Slot"] = self
			data["inv"] = inv
			
			multi_handler.moveDoubleClick(data)
		
func hide_slot_visual():
	item_visual.visible = false
	amount_text.visible = false
	amount_text.text = ""
	
func hide_main_slot_visual():
	mainslot.visible = false
	
func show_slot_visual():
	item_visual.visible = true
	amount_text.visible = true
	
func show_main_slot_visual():
	mainslot.visible = true
	
func RemoveSlotData():
	hide_slot_visual()
	item_visual.texture = null
	slotData = null
	filled = false

func _get_drag_data(at_position):
	
	#var preview_texture = instancedObject.instantiate()
	#preview_texture.update(slotData)
	#preview_texture.frame.visible = false
	
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = item_visual.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(32,32)
	
	var data : Dictionary
	data["SlotData"] = slotData
	data["Slot"] = self
	data["inv"] = inv
	
	var preview = Control.new()
	preview.add_child(preview_texture)
	preview.z_index = 1

	set_drag_preview(preview)
	
	hide_slot_visual()
	
	dragging = true
	
	return data

func _can_drop_data(at_position, data):
	if data is Dictionary:
		if data["SlotData"] == null:
			return false
		if data["Slot"] == null:
			return false
		if dragging:
			return false
		if data["Slot"] == self:
			return false
		if(inv.Check_Addable_at_Index(data["SlotData"],index)):
			return true
		return true

func _notification(notification_type):
	match notification_type:
		NOTIFICATION_DRAG_END:
			if dragging and filled:
				if !is_drag_successful():
					show_slot_visual()
					amount_text.text = str(amount)
				dragging = false

func _drop_data(at_position, data):
	
	inv.Add_Slot_at_Index(data["SlotData"],index)
	data["inv"].Remove_at_Index(data["Slot"].index)
	data["Slot"].RemoveSlotData()
	
	data["Slot"].dragging = false
	dragging = false
	filled = true

func _on_mouse_entered():
	if filled:
		tooltiphandler.setToolTipName(slotData.Item.name,"")
		tooltiphandler.setToolTipLore(slotData.Item.properties["Lore"])
		tooltiphandler.setToolTipRank(slotData.Item.properties["Rank"])
		tooltiphandler.show_tooltip()
	
func _on_mouse_exited():
	if filled:
		tooltiphandler.hide_tooltip()

func _on_hidden():
	tooltiphandler.hide_tooltip()
