@abstract
class_name EditorTileMapLayer
extends TileMapLayer

@export var data: Data
@export var layer: Data.Layer = Data.Layer.FLOOR

func _ready() -> void:
	data.cell_changed.connect(_on_cell_changed)
	data.reloaded.connect(rebuild)
	rebuild()

func rebuild() -> void:
	clear()

	for coords: Vector2i in data.get_cells(layer):
		_redraw_cell(coords)

func _on_cell_changed(changed_layer: Data.Layer, coords: Vector2i) -> void:
	if changed_layer == layer:
		_redraw_cell(coords)

@abstract func _redraw_cell(coords: Vector2i) -> void
