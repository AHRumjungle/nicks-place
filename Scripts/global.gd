extends Node

var previousScore = 0

#Dics
var itemDic = {
	"emptyCoffee": 0,
	"coffee": 1,
	"plate": 2,
	"eggsAndBacon": 3,
	"pancakes": 4,
	"omlette": 5
}

var itemUse = {
	"coffee": "emptyCoffee",
	"eggsAndBacon": "plate",
	"pancakes": "plate",
	"omlette": "plate"
}

var cookDic = {
	
}

#Items that customers can request
var menu : Array = ["coffee"]
