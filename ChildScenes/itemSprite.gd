extends AnimatedSprite2D

func set_item(item : String):
	if item != "" and Global.itemDic[item] != null:
		frame = Global.itemDic[item]
