extends Node
class_name PriorityQueue

var elements: Array = []
class Item:
	var sequence
	var cost
	func _init(new_sequence, new_cost):
		sequence = new_sequence
		cost = new_cost

func enqueue(item, cost):
	elements.append(Item.new(item, cost))
	sort() 
func dequeue():
	if not is_empty():
		var item = elements.pop_front() 
		return {"sequence": item.sequence, "cost": item.cost} 
	return null

func is_empty() -> bool:
	return elements.size() == 0

func sort():
	elements.sort_custom(Callable(PriorityQueue, "compare_items"))

static func compare_items(a, b):
	return a.cost - b.cost

func size() -> int:
	return elements.size()
