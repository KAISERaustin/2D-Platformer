# res://scripts/spawners/mushroom_spawner.gd
extends Spawner

@export var spawn_positions: Array[Vector2] = []

const SPAWN_DISTANCE = 500.0
const DESPAWN_BUFFER = 50.0

var _spawn_data: Array = []

func _ready() -> void:
	pool_name  = "Mushroom"
	perma_kill = true
	for pos in spawn_positions:
		_spawn_data.append({
			"position": pos,
			"spawned":  false,
			"instance": null,
			"callback": null,
			"killed":   false
		})
	set_process(true)

func _process(_delta: float) -> void:
	var ppos = get_node(player_path).global_position
	for i in _spawn_data.size():
		var data = _spawn_data[i]
		if data.killed:
			continue

		if data.spawned and data.instance:
			var dist = ppos.distance_to(data.position)
			if dist > SPAWN_DISTANCE + DESPAWN_BUFFER:
				data.position = data.instance.global_position
				PoolManager.free_instance(pool_name, data.instance)
				data.spawned  = false
				data.instance = null
				data.callback = null
			continue

		if not data.spawned and ppos.distance_to(data.position) <= SPAWN_DISTANCE:
			var mushroom = PoolManager.get_instance_and_add(pool_name, get_tree().current_scene)
			mushroom.visible              = true
			mushroom.set_physics_process(true)
			mushroom.set_process(true)
			mushroom.animated_sprite.flip_h = false
			mushroom.animated_sprite.play("default")
			mushroom.global_position      = data.position
			data.instance              = mushroom
			data.spawned               = true
			var cb = Callable(self, "_on_mushroom_killed").bind(i)
			# disconnect if that exact Callable is already hooked
			if mushroom.head_hit_check.is_connected("area_entered", cb):
				mushroom.head_hit_check.disconnect("area_entered", cb)
			# (re)connect it
			mushroom.head_hit_check.area_entered.connect(cb)
			data.callback = cb

func _on_mushroom_killed(_area: Area2D, index: int) -> void:
	var data = _spawn_data[index]
	data.killed = true
	if data.instance and data.callback:
		data.instance.head_hit_check.area_entered.disconnect(data.callback)
		data.callback = null
