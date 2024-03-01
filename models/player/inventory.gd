class_name PlayerInventory
extends Resource

@export var inventory := {
	"KeyItems": BagKeyItemsInventory,
	"Items": BagItemsInventory,
	"Berries": BagBerryInventory,
	"TMHM": BagTMHMInventory,
	"Balls": BagBallInventory
}
