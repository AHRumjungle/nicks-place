extends Node

var customersServed
var walkOuts
var totalCustomers

const maxWalkOuts = 5
const startTime = 20 #Default: 20

var chance = 3 #present chance multiplied by 10


var customerHandler : Node


func _ready() -> void:
	customersServed = 0
	walkOuts = 0
	totalCustomers = 0
	
	customerHandler = get_parent().get_node("customerHandler")
	
	$Timer.wait_time = startTime
	
	await  get_tree().create_timer(2).timeout #Spawn first customer off the bat
	customerHandler.queue_customer()
	
	$Timer.start()

#Gameplay loop based off of timer
func _on_timer_timeout() -> void:
	customerHandler.queue_customer()
	
	#random chance to reduce timer
	if randi() % 10 < chance:
		if $Timer.wait_time > 1:
			var oldWait = $Timer.wait_time
			$Timer.wait_time = oldWait - 1


func register_walkout():
	walkOuts = walkOuts + 1
	totalCustomers = totalCustomers + 1
	print("Walkouts: " + str(walkOuts))
	if walkOuts >= maxWalkOuts: 
		##GAME END##
		Global.previousScore = customersServed
		get_tree().change_scene_to_file("res://menuScenes/gameEnd.tscn")

func register_served():
	customersServed = customersServed + 1
	totalCustomers = totalCustomers + 1
	
	get_parent().get_node("PlayerBody/Camera2D/UI").update_customers_served(customersServed)
	
	print("Customers Served: " + str(customersServed))
