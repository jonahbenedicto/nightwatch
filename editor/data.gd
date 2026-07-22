class_name Data
extends Node2D

signal cell_changed(layer: Layer, coords: Vector2i)
signal reloaded

enum Layer {
	FLOOR,
	WALLS,
	PROPS,
}

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

func to_dict() -> Dictionary:
	return _layers

func from_dict(layers: Dictionary) -> void:
	_layers.clear()

	for key: Variant in layers:
		_layers[int(key) as Layer] = layers[key]

	reloaded.emit()
