extends CharacterBody3D

enum {IDLE, WALK, WALK_REVERSE, RUN};
@export var speed = 5.0
@export var acceleration = 4.0
@export var jump_speed = 8.0

var running = false;

var current_state = IDLE;
@onready var pc_node = get_node("PC/AnimationPlayer");

@export var mouse_sensitivity = 0.0035
@onready var spring_arm = $SpringArm3D
@onready var camera = $SpringArm3D/Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	pc_node.get_animation("idle").loop = true;
	pc_node.get_animation("walking").loop = true;
	pc_node.get_animation("running").loop = true;

func _physics_process(delta):
	var move_speed = speed;
	velocity.y += -gravity * delta
	
	if(current_state == IDLE):
		pc_node.play("idle");
	elif(running):
		pc_node.play("running");
		move_speed *=2;
	else:
		pc_node.play("walking");
		
	var input_direction = Input.get_vector("move_left","move_right","move_forward","move_back");
	var direction = ($SpringArm3D.transform.basis * Vector3(input_direction.x,0,input_direction.y)).normalized();
	
	if input_direction != Vector2(0,0):
		get_tree().get_nodes_in_group("player")[0].rotation_degrees.y =$SpringArm3D.rotation_degrees.y- rad_to_deg(input_direction.angle()) + 90;
	
	if direction:
		velocity.x = direction.x * move_speed;
		velocity.z = direction.z * move_speed;
	else:
		velocity = Vector3(0,0,0);

	move_and_slide();


func _input(_event):
	if (Input.is_action_pressed("move_forward")):
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
		#spring_arm.rotation_degrees.x = spring_arm.rotation_degrees.x
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity
