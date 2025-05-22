extends Node2D

var item = ""

@export var customerHandler : Node

var itemOccupied = false




func _ready() -> void:
	$itemSprite.visible = false
	customerHandler.add_table($".")

func get_customer_chair_pos() -> Vector2:
	return $customerChair.global_position

func consume_item():
		if Global.itemUse[item] != null:
			item =  Global.itemUse[item]
			$itemSprite.set_item(item)

func player_interact(player : Node2D) -> void:
	
	if item == "" and player.holdingItem != "":
		item = player.holdingItem
		player.update_item("")
		$itemSprite.visible = true
		$itemSprite.set_item(item)
	elif itemOccupied == false and player.holdingItem == "" and item != "":
		player.update_item(item)
		item = ""
		$itemSprite.visible = false
		
