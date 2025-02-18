extends Node3D

const CAMERA_MIN := -PI * 0.5
const CAMERA_MAX := PI * 0.5

const MOUSE_SPEED := 0.003
const GAMEPAD_SPEED := 0.07

const GYRO_SCALE := Vector3(3.0, 6.0, 0.0)

@export var player: Player

var base_rotation := Vector3.ZERO

func move_camera(direction: Vector2) -> void:
	base_rotation.x = clamp(
		base_rotation.x - direction.y,
		CAMERA_MIN,
		CAMERA_MAX)
	
	base_rotation.y -= direction.x

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		move_camera(event.relative * MOUSE_SPEED)

func _physics_process(delta: float) -> void:
	move_camera(
		Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down") * GAMEPAD_SPEED)
	
	rotation = base_rotation
