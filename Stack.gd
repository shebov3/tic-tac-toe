extends Node
class_name Stack

var items = []

func push(item):
	items.append(item)

func pop() -> Variant:
	if is_empty():
		return null 
	return items.pop_back()

func peek() -> Variant:
	if is_empty():
		return null  
	return items[items.size() - 1]

func is_empty() -> bool:
	return items.size() == 0
	
func size() -> int:
	return items.size()
