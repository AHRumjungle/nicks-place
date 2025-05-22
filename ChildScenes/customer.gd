extends RigidBody2D

@export var speed = 30
@export var Seat : Node2D
@export var Spawn : Node2D

var currentTarget : Node2D

var takenSeat : int

const eatingTime : int = 5


var customerName : String = ""
var customerState: int = 0
#0 walking to seat
#1 At Seat
#2 Leaving

var customerFoodGoal : String
var customerPatiences : int
var customerPatiencesMultiplier : int = 3
var walkout = false

var customerSprite : Dictionary = {
	0: "alina",
	1: "andrius",
	2: "andy",
	3: "eric",
	4: "monte",
	5: "nida"
}



@onready var nav_agent : NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	var ranNum = randi() % customerSprite.size()
	customerName = customerSprite[ranNum]
	$customerSprite.frame = ranNum
	
	customerFoodGoal = Global.menu[randi() % Global.menu.size()]
	
	freeze = false
	$ProgressBar.visible = false
	$itemSprite.visible = false
	$itemSprite.set_item(customerFoodGoal)
	
	customerState = 0
	currentTarget = Seat
	make_path(Seat)
	
	customerPatiences = (10 + randi() % 10) * customerPatiencesMultiplier
	pass

func _physics_process(_delta: float) -> void:
	match customerState:
		0:#Going to seat
			walking()
			
			#Arrive at Seat
			if $Area2D.has_overlapping_areas() == true and $Area2D.get_overlapping_areas()[0] == Seat:
				customerState = 1
				freeze = true
				global_position = Seat.get_customer_chair_pos()
				$Timer.start(customerPatiences)
				$ProgressBar.max_value = customerPatiences
				$ProgressBar.visible = true
				$itemSprite.visible = true
				
		1:#At Seat
			#update progress
			$ProgressBar.value = $Timer.wait_time - $Timer.time_left
			
			#did not get food
			if $Timer.is_stopped() == true: 
				customerState = 3
				walkout = true
				$ProgressBar.visible = false
				$itemSprite.visible = false
				
				currentTarget = Spawn
				make_path(Spawn)
				freeze = false
			
			#Customer gets food
			if Seat.item == customerFoodGoal:
				$Timer.stop()
				$Timer.wait_time = eatingTime
				$Timer.start()
				customerState = 2
				$ProgressBar.visible = false
				$itemSprite.visible = false
				Seat.itemOccupied = true
			
		2:#Enjoying food
			#Done enjoying food
			if $Timer.is_stopped() == true: 
				customerState = 3
				Seat.itemOccupied = false
				Seat.consume_item()
				currentTarget = Spawn
				make_path(Spawn)
				freeze = false
		3:#Leaving seat
			walking()
			if $Area2D.has_overlapping_areas() and $Area2D.overlaps_area(Spawn):
				get_parent().pop_customer($".")

func make_path(target : Node2D) -> void:
	nav_agent.target_position = target.global_position

func walking() -> void:
	
	if NavigationServer2D.map_get_iteration_id(nav_agent.get_navigation_map()) == 0:
		return
	
	if !nav_agent.is_target_reachable():
		print("target unreachable")
	
	var nextPos = nav_agent.get_next_path_position()
	#print(nextPos)
	var dir = global_position.direction_to(nextPos) * speed
	#print(global_position)
	apply_force(dir)
	
	


func _on_nav_timer_timeout() -> void:
	if currentTarget != null:
		make_path(currentTarget)
