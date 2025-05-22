extends Node

var customerArray : Array
var seatArray : Array
var availableSeatsArray : Array
var customersInQueue : int


func _ready() -> void:
	customersInQueue = 0



func add_table(table : Node2D):
	seatArray.append(table)
	availableSeatsArray.append(true)

func _process(_delta: float) -> void:
	if customersInQueue > 0 and availableSeatsArray.has(true) == true:
		customersInQueue = customersInQueue - 1
		get_parent().get_node("PlayerBody/Camera2D/UI").update_queue_counter(customersInQueue)
		spawn_customer(find_seat_for_customer())


func queue_customer() -> void:
	if availableSeatsArray.has(true) == true:
		spawn_customer(find_seat_for_customer())
	else:
		print("Queue Increased")
		customersInQueue = customersInQueue + 1
		get_parent().get_node("PlayerBody/Camera2D/UI").update_queue_counter(customersInQueue)
		$AudioStreamPlayer.stream = load("res://Sounds/Effects/queueIncreased.wav")
		$AudioStreamPlayer.play()

func find_seat_for_customer() -> int:
	var counter = 0
	#print("Begin Seat Check")
	for seat in availableSeatsArray:
		#print("Checking Seat " + str(counter) + ": " + str(seat))
		if seat == true:
			#print("Seat Is Open")
			availableSeatsArray[counter] = false
			return counter
		counter = counter + 1
	
	return -1

func spawn_customer(seatID : int) -> void:
	
	print("Spawning Customer")
	
	$Spawn/AudioStreamPlayer2D.play()
	
	customerArray.append(preload("res://ChildScenes/customer.tscn").instantiate())
	var pos = customerArray.size() - 1
	customerArray[pos].global_position = $Spawn.global_position
	
	customerArray[pos].Seat = seatArray[seatID]
	customerArray[pos].Spawn = $Spawn
	
	customerArray[pos].takenSeat = seatID
	
	add_child(customerArray[pos])
	pass
	
func pop_customer(customer : Node2D):
	var pos = customerArray.bsearch(customer)
	customerArray.pop_at(pos)
	availableSeatsArray[customer.takenSeat] = true
	
	if customer.walkout == true:
		get_parent().get_node("gameHandler").register_walkout()
	else:
		get_parent().get_node("gameHandler").register_served()
	
	remove_child(customer)
	
