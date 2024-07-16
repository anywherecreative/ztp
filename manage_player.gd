extends CharacterBody3D

enum {IDLE, WALK, WALK_REVERSE, RUN};
var speed = 1;
var rotation_increment = 0.2;
var running = false;

var current_state = IDLE;
@onready var pc_node = get_node("PC/AnimationPlayer");

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pc_node.get_animation("idle").loop = true;
	pc_node.get_animation("walking").loop = true;
	pc_node.get_animation("running").loop = true;

func _physics_process(delta):
	var forward = global_transform.basis.z;
	match current_state:
		IDLE:
			speed = 0;
			pc_node.play("idle");
		WALK:
			speed = 1;
			velocity = forward * speed;
		WALK_REVERSE:
			speed = -1;
			velocity = forward * speed;
		
	if(running && current_state != IDLE):
		speed *= 4;
		pc_node.play("running");
	else:
		pc_node.play("walking");
	
	velocity = forward * speed;
	move_and_slide();

func _input(event):
	if (Input.is_action_pressed("move_fwd")):
		current_state = WALK;
	elif(Input.is_action_pressed("move_back")):
		current_state = WALK_REVERSE;
	else:
		current_state = IDLE;
		
	if (Input.is_action_pressed("turn_left")):
		rotate_y(rotation_increment);
	if (Input.is_action_pressed("turn_right")):
		rotate_y(-rotation_increment)
		
	if (Input.is_action_pressed("run")):
		running = true;
	else:
		running = false;
	
