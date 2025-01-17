extends CharacterBody3D

@onready var player_inv: Inv = preload("res://Scenes/Inventory/Player_Inventory.tres")
@onready var player_multi_inv: Inv = preload("res://Scenes/Inventory/MultiStorage.tres")
@onready var localContent_inv: Inv

@onready var player_AnimatedSprite3D:AnimatedSprite3D = $AnimatedSprite3D
@onready var player_InvUI = $Inv_UI

var can_open_multi:bool = false

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#@export_node_path("InventoryHandler") var inventory_handler_path = NodePath("InventoryHandler")
#@export_node_path("Hotbar") var hotbar_path = NodePath("InventoryHandler/Hotbar")
#@export_node_path("Crafter") var crafter_path = NodePath("Crafter")
#@onready var inventory_handler : InventoryHandler = get_node(inventory_handler_path)
#@onready var hotbar : Hotbar = get_node(hotbar_path)
#@onready var crafter : Crafter = get_node(crafter_path)
#@onready var raycast : RayCast3D = $RayCast3D
#@onready var camera_3d : Camera3D = $Camera3D

@export var inv: Inv

enum INPUT_STATE {
	IDLE,
	WALKING,
	UI,
	MULTI_UI,
	STOPPED_INPUT
}
var _INTERFACE_INPUT_STATE:INPUT_STATE = INPUT_STATE.IDLE

func _ready():
	inv._ready()

func _input(event: InputEvent) -> void:
	match _INTERFACE_INPUT_STATE:
		INPUT_STATE.UI:
			if Input.is_action_just_pressed("Negative"):
				pass
			elif event.is_action_released("Negative"):
				pass
			pass

func _physics_process(delta):
	
	UI_Handling(delta)
	
	Walking_Handling(delta)

func play_anim(dir):
	match _INTERFACE_INPUT_STATE:
		INPUT_STATE.MULTI_UI:
			player_AnimatedSprite3D.play("idle")
		INPUT_STATE.UI:
			player_AnimatedSprite3D.play("idle")
		INPUT_STATE.IDLE:
			player_AnimatedSprite3D.play("idle")
		INPUT_STATE.WALKING:
			if dir.y == -1:
				player_AnimatedSprite3D.play("n-walk")
			if dir.x == 1:
				player_AnimatedSprite3D.play("e-walk")
			if dir.y == 1:
				player_AnimatedSprite3D.play("s-walk")
			if dir.x == -1:
				player_AnimatedSprite3D.play("w-walk")

			if dir.x > 0.5 and dir.y < -0.5:
				player_AnimatedSprite3D.play("ne-walk")
			if dir.x > 0.5 and dir.y > 0.5:
				player_AnimatedSprite3D.play("se-walk")
			if dir.x < -0.5 and dir.y > 0.5:
				player_AnimatedSprite3D.play("sw-walk")
			if dir.x < -0.5 and dir.y < -0.5:
				player_AnimatedSprite3D.play("nw-walk")

func player():
	pass

func UI_Handling(delta):
	if Input.is_action_just_pressed("Inventory"):
		if can_open_multi and _INTERFACE_INPUT_STATE == INPUT_STATE.MULTI_UI:
			player_InvUI.close()
			_INTERFACE_INPUT_STATE = INPUT_STATE.IDLE
		else:
			if _INTERFACE_INPUT_STATE == INPUT_STATE.UI:
				player_InvUI.close()
				_INTERFACE_INPUT_STATE= INPUT_STATE.IDLE
			else:
				player_InvUI.open()
				_INTERFACE_INPUT_STATE= INPUT_STATE.UI
	elif Input.is_action_just_pressed("Interact"):
		if can_open_multi:
			if _INTERFACE_INPUT_STATE == INPUT_STATE.MULTI_UI:
				player_InvUI.close()
				_INTERFACE_INPUT_STATE = INPUT_STATE.IDLE
			else:
				player_InvUI.close()
				player_InvUI.openMulti()
				_INTERFACE_INPUT_STATE= INPUT_STATE.MULTI_UI
				velocity.x = move_toward(0, 0, 0)
				velocity.z = move_toward(0, 0, 0)

func Walking_Handling(delta):
	var input_dir = Input.get_vector("Left","Right","Up","Down")
	if _INTERFACE_INPUT_STATE == INPUT_STATE.IDLE or _INTERFACE_INPUT_STATE == INPUT_STATE.WALKING:
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle Jump.
		if Input.is_action_just_pressed("Jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			_INTERFACE_INPUT_STATE = INPUT_STATE.WALKING
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
			_INTERFACE_INPUT_STATE = INPUT_STATE.IDLE

		move_and_slide()
	
	if _INTERFACE_INPUT_STATE == INPUT_STATE.STOPPED_INPUT:
		velocity = Vector3(0,0,0)
		move_and_slide()
	play_anim(input_dir)

func collect(item):
	if !_INTERFACE_INPUT_STATE == INPUT_STATE.STOPPED_INPUT:
		inv.Insert(item)

func collectWithAmount(item,amount:int):
	if !_INTERFACE_INPUT_STATE == INPUT_STATE.STOPPED_INPUT:
		inv.InsertWithAmount(item,amount)

func inventoryInteraction(localcontent_Inv_param = player_multi_inv):
	if !_INTERFACE_INPUT_STATE == INPUT_STATE.STOPPED_INPUT:
		localContent_inv = localcontent_Inv_param
		player_InvUI.SetMultiSlot(localContent_inv)
		can_open_multi = true

func inventoryInteractionEnd():
	localContent_inv = null
	can_open_multi = false

func stop_inputs():
	_INTERFACE_INPUT_STATE = INPUT_STATE.STOPPED_INPUT
	
func start_inputs():
	_INTERFACE_INPUT_STATE = INPUT_STATE.IDLE
	
func set_location(location:Vector3):
	global_position = location
