class_name Item
extends Resource

@export var id:String
@export var name:String
@export_range(0,100) var quantity:int
@export var description:String
@export var texture:Texture2D
@export var scene:PackedScene
