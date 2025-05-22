extends RigidBody2D


@export var moveForce : int = 1000
@export var maxVel : int = 100

var holdingItem : String = ""

func _ready() -> void:
	$itemSprite.visible = false


func _physics_process(_delta: float) -> void:
	#movment
	
	#print("tick")
	
	var forceVector : Vector2 = Vector2(0,0)
	
	if Input.is_action_pressed("Move Up"):
		forceVector += Vector2(0,-moveForce)
		
		if get_linear_velocity().y < -maxVel:
			forceVector.y = 0
			linear_velocity.y = -maxVel
		
	if Input.is_action_pressed("Move Down"):
		forceVector += Vector2(0,moveForce)
		
		if get_linear_velocity().y > maxVel:
			forceVector.y = 0
			linear_velocity.y = maxVel
			
	if Input.is_action_pressed("Move Left"):
		forceVector += Vector2(-moveForce, 0)
		
		if get_linear_velocity().x < -maxVel:
			forceVector.x = 0
			linear_velocity.x = -maxVel
		
	if Input.is_action_pressed("Move Right"):
		forceVector += Vector2(moveForce, 0)
		
		if get_linear_velocity().x > maxVel:
			forceVector.x = 0
			linear_velocity.x = maxVel
	
	#print(forceVector)
	apply_force(forceVector)
	
	#Interactions
	if $PlayerArea.has_overlapping_areas():
		#get the 'latest' area that the player has entered
		var area : Area2D = $PlayerArea.get_overlapping_areas()[$PlayerArea.get_overlapping_areas().size() - 1]
		if Input.is_action_just_pressed("Interact"):
			area.player_interact($".")
			$AudioStreamPlayer2D.stream = load("res://Sounds/Effects/pickUp.wav")
			$AudioStreamPlayer2D.play()
		#Check for Item to put down
		if holdingItem != "":
			if Input.is_action_just_released("Interact"):
				area.player_interact($".")
				$AudioStreamPlayer2D.stream = load("res://Sounds/Effects/putDown.wav")
				$AudioStreamPlayer2D.play()
	
	#Item system
	
	#Drops Items
	if Input.is_action_just_released("Interact"):
		if holdingItem != "":
			update_item("")
			$AudioStreamPlayer2D.stream = load("res://Sounds/Effects/drop.wav")
			$AudioStreamPlayer2D.play()

func update_item(item : String) -> void:
	holdingItem = item
	if item == "":
		$itemSprite.visible = false
	else:
		$itemSprite.visible = true
		$itemSprite.set_item(item)
