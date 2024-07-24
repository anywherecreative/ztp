extends CharacterBody3D

enum {IDLE, WALK, WALK_REVERSE, RUN};
@export var speed = 5.0
@export var acceleration = 4.0
@export var jump_speed = 8.0
var rotation_increment = 0.2;
var running = false;

var current_state = IDLE;
@onready var pc_node = get_node("PC/AnimationPlayer");

@export var mouse_sensitivity = 0.0015
@onready var spring_arm = $SpringArm3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pc_node.get_animation("idle").loop = true;
	pc_node.get_animation("walking").loop = true;
	pc_node.get_animation("running").loop = true;

func _physics_process(delta):
	velocity.y += -gravity * delta
	get_move_input(delta)
	
	if(current_state == IDLE):
		pc_node.play("idle");
	elif(running):
		speed *= 4;
		pc_node.play("running");
	else:
		pc_node.play("walking");
	
	move_and_slide();
	
func get_move_input(delta):
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("left", "right", "forward", "back")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)
	velocity.y = vy


func _input(event):
	if (Input.is_action_pressed("move_fwd")):
		current_state = WALK;
	elif(Input.is_action_pressed("move_back")):
		current_state = WALK_REVERSE;
	else:
		current_state = IDLE;

		
	if (Input.is_action_pressed("run")):
		running = true;
	else:
		running = false;
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * mouse_sensitivity
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90.0, 30.0)
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity
