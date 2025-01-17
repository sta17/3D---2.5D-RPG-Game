extends Control

@onready var Name_Label:Label = $Name_Label
@onready var HP_Label:Label = $HP_Label
@onready var Level_Label:Label = $Level_Label
@onready var Icon:TextureRect = $Frame/Icon
@onready var Highlight:NinePatchRect = $Highlight

@export var index: int

@onready var PlayerParty: Party

var dragging: bool = false
var is_highlight: bool = false

var currentCreature: CurrentCreature

func update(creature: CurrentCreature):
	if !creature:
		hide_slot_visual()
	else:
		show_slot_visual()
		currentCreature = creature
		Icon.texture = creature.baseCreature.PartyTexture
		Name_Label.text=creature.DisplayName
		HP_Label.text=str("HP: ",creature.Current_HP)
		Level_Label.text=str("Lvl: ",creature.Current_Level)

func RemoveSlot():
	Name_Label.text="---"
	HP_Label.text="HP: "
	Level_Label.text="Lvl: "
	Icon.texture=null

func hide_slot_visual():
	Name_Label.visible = false
	HP_Label.visible = false
	Level_Label.visible = false
	Icon.visible = false
	
func show_slot_visual():
	Name_Label.visible = true
	HP_Label.visible = true
	Level_Label.visible = true
	Icon.visible = true

func hide_highlight():
	Highlight.visible = false
	
func show_highlight():
	Highlight.visible = true

func _get_drag_data(at_position):
	
	var preview_texture = TextureRect.new()
	
	preview_texture.texture = currentCreature.baseCreature.PartyTexture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(32,32)
	
	var data : Dictionary
	data["SlotData"] = currentCreature
	data["Slot"] = self
	data["inv"] = PlayerParty
	
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
		if(PlayerParty.Check_Addable_at_Index(data["SlotData"],index)):
			return true
		return true

func _notification(notification_type):
	match notification_type:
		NOTIFICATION_DRAG_END:
			if dragging:
				if !is_drag_successful():
					show_slot_visual()
				dragging = false

func _drop_data(at_position, data):
	
	PlayerParty.Add_at_Index(data["SlotData"],index)
	data["inv"].Remove_at_Index(data["Slot"].index)
	data["Slot"].RemoveSlot()
	
	data["Slot"].dragging = false
	dragging = false

func _on_button_pressed():
	if(is_highlight):
		hide_highlight()
		is_highlight = false
	else:
		show_highlight()
		is_highlight = true
