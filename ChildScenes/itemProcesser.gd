extends Node2D

@export var globalCook : bool = false
@export var inputItem : String
@export var outputItem : String
@export var time : float = 5

@export var noProccesserSprite : bool = false
@export var spriteOff : Texture
@export var spriteOn : Texture

var item = ""
var showBar: bool


func _ready() -> void:
	
	if spriteOff == null:
		spriteOff = load("res://Sprites/empty.png")
	if spriteOn == null:
		spriteOn = load("res://Sprites/empty.png")
	
	$sprite.texture = spriteOff
	$itemSprite.visible = false
	$Timer.wait_time = time
	
	if noProccesserSprite == true:
		$sprite.visible = false
	
	showBar = false
	$ProgressBar.max_value = time
	pass

func _process(_delta: float) -> void:
	if showBar:
		$ProgressBar.visible = true
		$ProgressBar.value = $Timer.wait_time - $Timer.time_left
	else:
		$ProgressBar.visible = false

func player_interact(player : Object) -> void:
	
	#print("Player interact with: " + player.holdingItem)
	
	if item == "" and player.holdingItem != "":
		if globalCook == true:
			if Global.cookDic.get(player.holdingItem) != null:
				item = player.holdingItem
				player.update_item("")
				$itemSprite.set_item(item)
				$itemSprite.visible = true
				$Timer.start()
				$sprite.texture = spriteOn
				showBar = true
		else:
			if player.holdingItem == inputItem:
				item = player.holdingItem
				player.update_item("")
				$itemSprite.set_item(item)
				$itemSprite.visible = true
				$Timer.start()
				$sprite.texture = spriteOn
				showBar = true
	else:
		if player.holdingItem == "":
			player.update_item(item)
			$itemSprite.visible = false
			item = ""
			$Timer.stop()
			$sprite.texture = spriteOff
			showBar = false

func _on_timer_timeout() -> void:
	if globalCook == true:
		item = Global.cookDic[item]
	else:
		item = outputItem
		
	$itemSprite.set_item(item)
	$Timer.stop()
	$sprite.texture = spriteOff
