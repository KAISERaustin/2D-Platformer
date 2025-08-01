# res://scripts/managers/pool_manager.gd
extends Node

var _pools: Dictionary = {}

func register_pool(pool_name: String, scene: PackedScene, initial_size: int = 0) -> void:
	if _pools.has(pool_name):
		push_warning("PoolManager: pool '%s' already exists." % pool_name)
		return
	_pools[pool_name] = {
		"scene": scene,
		"free": []
	}
	for i in range(initial_size):
		var inst = scene.instantiate()
		_pools[pool_name].free.append(inst)

func has_pool(pool_name: String) -> bool:
	return _pools.has(pool_name)

func get_instance(pool_name: String) -> Node:
	if not _pools.has(pool_name):
		push_error("PoolManager: no pool '%s' registered." % pool_name)
		return null
	var data: Dictionary = _pools[pool_name]
	if data.free.size() > 0:
		return data.free.pop_back()
	return data.scene.instantiate()

func get_instance_and_add(pool_name: String, parent: Node) -> Node:
	var inst: Node = get_instance(pool_name)
	if inst:
		parent.add_child(inst)
	return inst

func free_instance(pool_name: String, inst: Node) -> void:
	var parent = inst.get_parent()
	if parent:
		parent.remove_child(inst)
	if not _pools.has(pool_name):
		inst.queue_free()
		return
	var pool = _pools[pool_name]
	if pool.free.find(inst) == -1:
		pool.free.append(inst)

func reset_all_pools() -> void:
	for pool_name in _pools.keys():
		_pools[pool_name].free.clear()
