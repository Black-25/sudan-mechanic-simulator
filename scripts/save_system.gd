extends Node

const SAVE_PATH: String = "user://sudan_mechanic_save.json"

static func save_game(data: Dictionary) -> bool:
    var file := FileAccess.open(
        SAVE_PATH,
        FileAccess.WRITE
    )

    if file == null:
        push_error("Failed to open save file.")
        return false

    file.store_string(JSON.stringify(data, "\t"))
    file.close()

    print("Game saved successfully.")
    return true


static func load_game() -> Dictionary:
    if not FileAccess.file_exists(SAVE_PATH):
        print("No save file found.")
        return {}

    var file := FileAccess.open(
        SAVE_PATH,
        FileAccess.READ
    )

    if file == null:
        push_error("Failed to read save file.")
        return {}

    var content: String = file.get_as_text()
    file.close()

    var result: Variant = JSON.parse_string(content)

    if result is Dictionary:
        print("Game loaded successfully.")
        return result

    push_error("Save file is invalid.")
    return {}


static func delete_save() -> bool:
    if not FileAccess.file_exists(SAVE_PATH):
        return true

    var error: Error = DirAccess.remove_absolute(
        ProjectSettings.globalize_path(SAVE_PATH)
    )

    return error == OK
