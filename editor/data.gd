class_name Data
extends Node2D

signal cell_changed(layer: Layer, coords: Vector2i)
signal reloaded

enum Layer {
	FLOOR,
	WALLS,
	PROPS,
}

const SAVE_PATH: String = "user://levels/level_%d.dat"

var _layers: Dictionary[Layer, Dictionary] = {}

func set_cell(layer: Layer, coords: Vector2i, value: int) -> void:
	var cells: Dictionary = _layers.get_or_add(layer, {})

	if cells.get(coords) == value:
		return

	cells[coords] = value
	cell_changed.emit(layer, coords)

func erase_cell(layer: Layer, coords: Vector2i) -> void:
	if _layers.get(layer, {}).erase(coords):
		cell_changed.emit(layer, coords)

func get_cell(layer: Layer, coords: Vector2i) -> Variant:
	return _layers.get(layer, {}).get(coords)

func get_cells(layer: Layer) -> Dictionary:
	return _layers.get(layer, {})

func clear() -> void:
	_layers.clear()
	reloaded.emit()

func save_to(level: int) -> Error:
	var path: String = SAVE_PATH % level
	DirAccess.make_dir_recursive_absolute(path.get_base_dir())

	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)

	if file == null:
		return FileAccess.get_open_error()

	file.store_var(_layers)
	return OK

func load_from(level: int) -> Error:
	var file: FileAccess = FileAccess.open(SAVE_PATH % level, FileAccess.READ)

	if file == null:
		return FileAccess.get_open_error()

	var loaded: Variant = file.get_var()

	if loaded is not Dictionary:
		return ERR_FILE_CORRUPT

	_layers.clear()

	for key: Variant in loaded:
		_layers[int(key) as Layer] = loaded[key]

	reloaded.emit()
	return OK
