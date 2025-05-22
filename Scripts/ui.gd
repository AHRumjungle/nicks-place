extends Control

var totuorialShow = true

func _ready() -> void:
	$queueCounter.visible = false
	$Tutorial.visible = true

func _physics_process(_delta: float) -> void:
	#print(get_parent().get_screen_center_position())
	global_position = get_parent().get_screen_center_position()
	if totuorialShow == true and Input.is_action_just_pressed("Interact"):
		totuorialShow = false
		$Tutorial.visible = false


func update_queue_counter(count : int) -> void:
	if count == 0:
		$queueCounter.visible = false
	else:
		$queueCounter.visible = true
		$queueCounter.text = "Queue: " + str(count)
		

func update_customers_served(count : int) -> void:
	$customersServed.text = "Customers Served: " + str(count)
