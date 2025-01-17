extends CharacterBody3D

@onready var player_inv: Inv = preload("res://Scenes/Inventory/Player_Inventory.tres")
@onready var player_multi_inv: Inv = preload("res://Scenes/Inventory/MultiStorage.tres")
@onready var localContent_inv: Inv

@onready var player_AnimatedSprite3D:AnimatedSprite3D = $AnimatedSprite3D
#@onready var player_InvUI = $Inv_UI
@onready var player_UI = $Player_UI

var can_open_multi:bool = false

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var inv: Inv

enum INPUT_STATE {
	IDLE,
	WALKING,
	MULTI_PANEL_UI_INV,
	STOPPED_INPUT,
	UI_OPEN
}
var _INTERFACE_INPUT_STATE:INPUT_STATE = INPUT_STATE.IDLE

func _ready():
	inv._ready()

func _physics_process(delta):
	
	UI_Handling(delta)
	
	Walking_Handling(delta)

func play_anim(dir):
	match _INTERFACE_INPUT_STATE:
		INPUT_STATE.UI_OPEN:
			player_AnimatedSprite3D.play("idle")
		INPUT_STATE.MULTI_PANEL_UI_INV:
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
		if _INTERFACE_INPUT_STATE == INPUT_STATE.MULTI_PANEL_UI_INV:
			player_UI.closeMulti()
			_INTERFACE_INPUT_STATE = INPUT_STATE.IDLE
		else:
			if _INTERFACE_INPUT_STATE == INPUT_STATE.UI_OPEN:
				player_UI.closeSingle()
				_INTERFACE_INPUT_STATE= INPUT_STATE.IDLE
			else:
				player_UI.closeUI()
				player_UI.openSingle()
				_INTERFACE_INPUT_STATE= INPUT_STATE.UI_OPEN
	elif Input.is_action_just_pressed("Interact"):
		if can_open_multi:
			if _INTERFACE_INPUT_STATE == INPUT_STATE.MULTI_PANEL_UI_INV:
				player_UI.closeMulti()
				_INTERFACE_INPUT_STATE = INPUT_STATE.IDLE
			else:
				player_UI.closeUI()
				player_UI.openMulti()
				_INTERFACE_INPUT_STATE= INPUT_STATE.MULTI_PANEL_UI_INV
				velocity.x = move_toward(0, 0, 0)
				velocity.z = move_toward(0, 0, 0)
	elif Input.is_action_just_pressed("Menu"):
		if _INTERFACE_INPUT_STATE == INPUT_STATE.UI_OPEN:
			# Do unpause
			player_UI.closeMainMenu()
			_INTERFACE_INPUT_STATE= INPUT_STATE.IDLE
		else:
			# Do pause also
			player_UI.closeUI()
			player_UI.openMainMenu()
			_INTERFACE_INPUT_STATE = INPUT_STATE.UI_OPEN
	elif Input.is_action_just_pressed("Positive"):
		player_UI.PositiveInput()
	elif Input.is_action_just_pressed("Negative"):
		player_UI.NegativeInput()

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
		inv.Add(item)

func collectWithAmount(item,amount:int):
	if !_INTERFACE_INPUT_STATE == INPUT_STATE.STOPPED_INPUT:
		inv.AddWithAmount(item,amount)

func inventoryInteraction(localcontent_Inv_param = player_multi_inv):
	if !_INTERFACE_INPUT_STATE == INPUT_STATE.STOPPED_INPUT:
		localContent_inv = localcontent_Inv_param
		player_UI.SetMultiSlot(localContent_inv)
		can_open_multi = true

func inventoryInteractionEnd():
	localContent_inv = null
	can_open_multi = false

func stop_inputs():
	_INTERFACE_INPUT_STATE = INPUT_STATE.STOPPED_INPUT
	
func start_inputs():
	_INTERFACE_INPUT_STATE = INPUT_STATE.IDLE
	
func set_location(location:Vector3):
	global_transform.origin = location
