#include <queue>
#include <iostream>
#include <algorithm>

#include "search.h"

void breadth_first_search(const board& begin, const board& goal) {
	// storage for new nodes
	std::queue<board> nodes;
	nodes.push(begin);

	bool achieved{false};
	// while goal not found
	while (!achieved) {
		board current = nodes.front();
		// current.print_board();
		// getchar();
		std::vector<board> successors = current.get_successors();
		nodes.pop();
		// check each successor for uniqueness and for reaching final state
		std::for_each(successors.begin(), successors.end(),
			[&nodes, &goal, &achieved](const board& node) {
				if (node == goal) {
					achieved = true;
				} else if (node.is_unique()) {
					nodes.push(node);
				}
		});
	}
	std::cout << "found" << '\n';
	goal.print_board();
}
