extends CharacterBody3D
class_name Player

const MOVE_FORWARD_SPEED := 120.0
const MOVE_BACKWARD_SPEED := 20.0

const MOVE_FORWARD_ACCEL := 40.0
const MOVE_SIDE_ACCEL := 90.0

const TURN_SPEED_MIN := 1.0
const TURN_SPEED_MAX := 4.0
const TURN_ACCEL := 15.0

var turn_velocity := 0.0

@export var mesh: Node3D

func move_player(delta: float) -> void:
	var move_direction := Input.get_axis("move_backward", "move_forward")
	var move_speed := move_direction * MOVE_FORWARD_SPEED if move_direction >= 0.0 else move_direction * MOVE_BACKWARD_SPEED
	
	var forward := Vector3.FORWARD.rotated(Vector3.UP, mesh.rotation.y)
	var side := Vector3(-forward.z, forward.y, forward.x)
	
	var forward_speed := Direction.target_axis(
		velocity.dot(forward),
		move_speed, 
		MOVE_FORWARD_ACCEL * delta)
	
	var side_speed := Direction.target_axis(
		velocity.dot(side),
		0.0, 
		MOVE_SIDE_ACCEL * delta)
	
	velocity = forward * forward_speed + side * side_speed
	move_and_slide()
	
	var turn_direction := Input.get_axis("turn_right", "turn_left")
	
	var speed_progress: float = max(0.0, forward_speed / MOVE_FORWARD_SPEED)
	var turn_speed = lerp(TURN_SPEED_MAX, TURN_SPEED_MIN, speed_progress)
	
	turn_velocity = Direction.target_axis(
		turn_velocity,
		turn_direction * turn_speed,
		TURN_ACCEL * delta)
	
	mesh.rotation.y += turn_velocity * delta
	mesh.rotation.x = turn_velocity * 0.1

func _physics_process(delta: float) -> void:
	move_player(delta)
