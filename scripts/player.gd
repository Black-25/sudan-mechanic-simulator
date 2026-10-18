extends CharacterBody3D

const MOVE_SPEED: float = 4.5
const JUMP_VELOCITY: float = 4.5

var gravity: float = float(
    ProjectSettings.get_setting("physics/3d/default_gravity")
)

func _physics_process(delta: float) -> void:
    # تطبيق الجاذبية
    if not is_on_floor():
        velocity.y -= gravity * delta

    # القفز
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # قراءة اتجاه الحركة
    var input_direction := Input.get_vector(
        "ui_left",
        "ui_right",
        "ui_up",
        "ui_down"
    )

    # تحويل الاتجاه إلى اتجاه عالمي
    var direction := Vector3(
        input_direction.x,
        0.0,
        input_direction.y
    )

    # الحركة
    if direction.length() > 0.0:
        direction = direction.normalized()
        velocity.x = direction.x * MOVE_SPEED
        velocity.z = direction.z * MOVE_SPEED
    else:
        velocity.x = move_toward(velocity.x, 0.0, MOVE_SPEED)
        velocity.z = move_toward(velocity.z, 0.0, MOVE_SPEED)

    move_and_slide()
