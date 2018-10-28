#include <algorithm>
#include <iostream>
#include <queue>
#include <stack>
#include <utility>

#include "search.h"

#define ANSI_COLOR_RED     "\x1b[31m"
#define ANSI_COLOR_RESET   "\x1b[0m"

// provides step-by-step running
void step(const board& current, const std::deque<board>& nodes, size_t fringe_size,
	const std::vector<board>& successors, const std::vector<size_t>& duplicates,
	bool force = false) {
	static bool runall{false};
	static size_t step_counter{0};
	static size_t skip_step{0};

	// don't print anything else
	if (runall && !force) {
		step_counter++;
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
			try {
				skip_step = std::stoul(arg);
			} catch(std::invalid_argument ex) {
				std::cerr << ex.what() << '\n';
			}
		}
	}
}

uint16_t wrong_placed(const board& node) {
	uint8_t value{0};
	for (uint8_t x{0}; x < 3; x++) {
		for (uint8_t y{0}; y < 3; y++) {
			if (node.cells[x][y] != board::goal.cells[x][y]) {
				value++;
			}
		}
	}
	return value;
}

uint16_t manhattan_distance(const board& node) {
	uint8_t value{0};
	for (uint8_t x{0}; x < 3; x++) {
		for (uint8_t y{0}; y < 3; y++) {
			auto dst = board::goal.find(node.cells[x][y]);
			value += std::abs(x - dst.x) + std::abs(y - dst.y);
		}
	}
	return value;
}

void a_star_search(const board& begin) {
	// storage for new nodes
	std::deque<board> nodes;
	nodes.push_back(begin);

	bool achieved{false};
	size_t depth{0};
	// while goal not found
	while (!achieved) {
		if (nodes.empty()) {
			break;
		}
		board current = nodes.front();
		auto successors = current.get_successors();
		nodes.pop_front();

		auto fringe_size = nodes.size();
		// keep indexes of successors duplicates
		size_t duplicate_index{0};
		std::vector<size_t> duplicates;
		// check each successor for uniqueness and for reaching final state
		std::for_each(successors.begin(), successors.end(),
			[&](const board node) {
				if (node.is_goal()) {
					achieved = true;
					depth = node.depth;
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
		std::cout << "\n Goal found on depth " << depth << ":\n";
		board::goal.print_board();
	} else {
		std::cout << ANSI_COLOR_RED << "\n Goal not found:"
							<< ANSI_COLOR_RESET << std::endl;
	}
}
