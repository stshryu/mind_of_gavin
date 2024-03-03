extends Node

var keyitempath:String = "res://models/items/keyitems/"
var pokeballpath:String = "res://models/items/pokeballs/"
var potionpath:String = "res://models/items/potions/"

var directories := {
	"KeyItems": keyitempath,
	"PokeBalls": pokeballpath,
	"Potions": potionpath
}

var loaded_items:Dictionary

func _ready() -> void:
	load_all_items()
	
func load_all_items() -> void:
	for key in directories:
		var nested_dict := {}
		for file in DirAccess.get_files_at(directories[key]):
			var filepath = directories[key] + file
			var item = load(filepath)
			nested_dict[item.id] = item
		loaded_items[key] = nested_dict
