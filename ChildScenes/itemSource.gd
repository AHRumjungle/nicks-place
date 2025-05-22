extends Area2D

@export var item : String = ""
@export var sprite : Texture2D
@export var hideItemSprite : bool = false
@export var hideSourceSprite : bool = false

func _ready() -> void:
	
	$itemSprite.visible = false
	$Sprite.visible = false
	
	if hideSourceSprite == false and sprite != null:
		$Sprite.texture = sprite
	
	if hideItemSprite == false and item != "":
		$itemSprite.visible = true
		$itemSprite.set_item(item)

func player_interact(player : Object) -> void:
	player.update_item(item)
	
