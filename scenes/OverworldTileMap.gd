extends TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("hello")
	print_debug(get_layers_count())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
