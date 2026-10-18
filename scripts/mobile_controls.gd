extends Control

const JOYSTICK_RADIUS := 75.0
const BUTTON_RADIUS := 42.0

var joystick_touch := -1
var jump_touch := -1
var interact_touch := -1

var joystick_center := Vector2.ZERO
var joystick_direction := Vector2.ZERO

var jump_pressed := false
var interact_pressed := false


func _ready() -> void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter = Control.MOUSE_FILTER_STOP
    queue_redraw()


func _process(_delta: float) -> void:
    var size := get_viewport_rect().size

    joystick_center = Vector2(115.0, size.y - 125.0)

    update_movement_actions()
    queue_redraw()


func _input(event: InputEvent) -> void:
    var size := get_viewport_rect().size

    var jump_center := Vector2(size.x - 85.0, size.y - 155.0)
    var interact_center := Vector2(size.x - 180.0, size.y - 95.0)

    if event is InputEventScreenTouch:
        if event.pressed:
            var pos: Vector2 = event.position

            if pos.x < size.x * 0.45 and joystick_touch == -1:
                joystick_touch = event.index
                update_joystick(pos)

            elif pos.distance_to(jump_center) < BUTTON_RADIUS + 15.0:
                jump_touch = event.index
                jump_pressed = true
                Input.action_press("ui_accept")

            elif pos.distance_to(interact_center) < BUTTON_RADIUS + 15.0:
                interact_touch = event.index
                interact_pressed = true
                Input.action_press("interact")

            queue_redraw()

        else:
            if event.index == joystick_touch:
                joystick_touch = -1
                joystick_direction = Vector2.ZERO

            if event.index == jump_touch:
                jump_touch = -1
                jump_pressed = false
                Input.action_release("ui_accept")

            if event.index == interact_touch:
                interact_touch = -1
                interact_pressed = false
                Input.action_release("interact")

            queue_redraw()

    elif event is InputEventScreenDrag:
        if event.index == joystick_touch:
            update_joystick(event.position)


func update_joystick(pos: Vector2) -> void:
    var offset: Vector2 = pos - joystick_center

    if offset.length() > JOYSTICK_RADIUS:
        offset = offset.normalized() * JOYSTICK_RADIUS

    joystick_direction = offset / JOYSTICK_RADIUS


func update_movement_actions() -> void:
    set_action("ui_left", joystick_direction.x < -0.25)
    set_action("ui_right", joystick_direction.x > 0.25)
    set_action("ui_up", joystick_direction.y < -0.25)
    set_action("ui_down", joystick_direction.y > 0.25)


func set_action(action_name: String, pressed: bool) -> void:
    if pressed:
        Input.action_press(action_name)
    else:
        Input.action_release(action_name)


func _draw() -> void:
    var size := get_viewport_rect().size

    var center := Vector2(115.0, size.y - 125.0)
    var jump_center := Vector2(size.x - 85.0, size.y - 155.0)
    var interact_center := Vector2(size.x - 180.0, size.y - 95.0)

    draw_circle(
        center,
        JOYSTICK_RADIUS,
        Color(0.1, 0.12, 0.17, 0.55)
    )

    draw_arc(
        center,
        JOYSTICK_RADIUS,
        0.0,
        TAU,
        48,
        Color(0.3, 0.65, 1.0, 0.9),
        3.0
    )

    draw_circle(
        center + joystick_direction * JOYSTICK_RADIUS,
        28.0,
        Color(0.25, 0.55, 1.0, 0.85)
    )

    draw_button(
        jump_center,
        "قفز",
        jump_pressed
    )

    draw_button(
        interact_center,
        "تفاعل",
        interact_pressed
    )


func draw_button(
    center: Vector2,
    label: String,
    pressed: bool
) -> void:
    var button_color := Color(0.25, 0.55, 1.0, 0.85)

    if pressed:
        button_color = Color(0.55, 0.3, 1.0, 0.95)

    draw_circle(center, BUTTON_RADIUS, button_color)

    draw_arc(
        center,
        BUTTON_RADIUS,
        0.0,
        TAU,
        36,
        Color.WHITE,
        2.0
    )

    var font := ThemeDB.fallback_font
    var font_size := 18

    draw_string(
        font,
        center + Vector2(-font.get_string_size(
            label,
            HORIZONTAL_ALIGNMENT_LEFT,
            -1,
            font_size
        ).x / 2.0, 6.0),
        label,
        HORIZONTAL_ALIGNMENT_LEFT,
        -1,
        font_size,
        Color.WHITE
    )
