extends Camera3D

@onready var player = get_node("../../../../Player");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transform.origin.x = player.position.x
	transform.origin.z = player.position.z;
