extends SpringArm3D

@export var mouse_sensitivity: float = 0.003
@export var min_pitch: float = -45.0
@export var max_pitch: float = 25.0

var yaw: float = 0.0
var pitch: float = -15.0

func _ready() -> void:
    spring_length = 4.0
    rotation_degrees = Vector3(pitch, yaw, 0.0)

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseMotion:
        yaw -= event.relative.x * mouse_sensitivity
        pitch -= event.relative.y * mouse_sensitivity

        pitch = clampf(pitch, min_pitch, max_pitch)

        rotation_degrees = Vector3(
            pitch,
            yaw,
            0.0
        )
