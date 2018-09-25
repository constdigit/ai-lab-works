#include <queue>
#include <stack>
#include <iostream>
#include <algorithm>

#include "search.h"

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_RESET   "\x1b[0m"

// provides step-by-step running
void step(const board& current, const std::vector<board>& nodes, size_t fringe_size,
	const std::vector<board>& successors, const std::vector<size_t>& duplicates,
	bool force = false) {
	static bool runall{false};
	static size_t step_counter{0};
	static size_t skip_step{0};

	// don't print anything else
	if (runall && !force) {
		return;
	}
	// skip steps
	if (skip_step > 0 && !force) {
		skip_step--;
		step_counter++;
		return;
	}

	std::cout << "\n <<< step #" << step_counter << " >>> \n";
	step_counter++;

	std::cout << "Current vertex:\n";
	current.print_board();

	std::cout << "Fringe:\n";
	auto end = nodes.cbegin() + fringe_size;
	std::for_each(nodes.cbegin(), end, [](const board& node) {
		node.print_board();
		std::cout << '\n';
	});

	// print all successors and mark duplicates red
	size_t duplicate_index{0};
	size_t it{0};
	std::cout << "Successors:\n";
	std::for_each(successors.cbegin(), successors.cend(), [&](const board& node) {
		if (!duplicates.empty() && it == duplicates[duplicate_index]) {
			duplicate_index++;
			std::cout << ANSI_COLOR_RED;
			node.print_board();
			std::cout << ANSI_COLOR_RESET << '\n';
		} else {
			node.print_board();
			std::cout << '\n';
		}
		it++;
	});
	std::cout.flush();

	// any key + enter for next step
	char key;
	std::cin >> key;
	std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
	// two options for 'r' key
	if (key == 'r') {
		std::string arg;
		std::cin >> arg;
		if (arg == "all") {
			runall = true;
		} else {
			skip_step = std::stoul(arg);
		}
	}
}

void breadth_first_search(const board& begin, const board& goal) {
	// storage for new nodes
	std::vector<board> nodes;
	nodes.push_back(begin);

	bool achieved{false};
	// while goal not found
	while (!achieved) {
		if (nodes.empty()) {
			break;
		}
		board current = nodes.front();
		std::vector<board> successors = current.get_successors();
		//equal to pop_front
		nodes.erase(nodes.begin());

		auto fringe_size = nodes.size();
		// keep indexes of successors duplicates
		size_t duplicate_index{0};
		std::vector<size_t> duplicates;
		// check each successor for uniqueness and for reaching final state
		std::for_each(successors.begin(), successors.end(), [&](const board& node) {
				if (node == goal) {
					achieved = true;
				}
				if (node.is_unique()) {
					nodes.push_back(node);
				} else {
					duplicates.push_back(duplicate_index);
				}
				duplicate_index++;
		});
		step(current, nodes, fringe_size, successors, duplicates, achieved);
	}

	std::cout << "\n Goal found:" << '\n';
	goal.print_board();
}

void depth_first_search(const board& begin, const board& goal, size_t max_depth) {
	// storage for new nodes
	std::vector<board> nodes;
	nodes.push_back(begin);

	bool achieved{false};
	// while goal not found
	while (!achieved) {
		if (nodes.empty()) {
			break;
		}
		board current = nodes.back();
		nodes.pop_back();

		if (current.depth == max_depth) {
			if (current == goal) {
				achieved = true;
				break;
			}
			continue;
		}
		std::vector<board> successors = current.get_successors();

		auto fringe_size = nodes.size();
		// keep indexes of successors duplicates
		size_t duplicate_index{0};
		std::vector<size_t> duplicates;
		// check each successor for uniqueness and for reaching final state
		std::for_each(successors.begin(), successors.end(), [&](const board& node) {
				if (node == goal) {
					achieved = true;
				}
				if (node.is_unique()) {
					nodes.push_back(node);
				} else {
					duplicates.push_back(duplicate_index);
				}
				duplicate_index++;
		});
		step(current, nodes, fringe_size, successors, duplicates, achieved);
	}
	if (achieved) {
		std::cout << "\n Goal found:" << '\n';
		goal.print_board();
	} else {
		std::cout << ANSI_COLOR_RED << "\n Goal not found:"
							<< ANSI_COLOR_RESET << std::endl;
	}
}
