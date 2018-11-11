#include <iostream>
#include <cstring>

#include "board.h"
#include "search.h"

constexpr uint8_t WRONG_PLACED = 1;
constexpr uint8_t MANHATTAN_DISTANCE = 2;

int main(int argc, char* argv[]) {
	// obtaion heuristic function
	uint8_t function_type{0};
	if (strcmp(argv[1], "1") == 0) {
		board::heuristic_function = wrong_placed;
	} else if (std::strcmp(argv[1], "2") == 0) {
		board::heuristic_function = manhattan_distance;
	} else {
		return 0;
	}

	uint8_t goal_state[3][3] =
		{{1, 2, 3},
		{4, 5, 6},
		{7, 8, 0}};
	for (uint8_t i{0}; i < 3; i++) {
		memcpy(board::goal.cells[i], goal_state[i], 3);
	}

	uint8_t begin_state[3][3] =
		{{5, 8, 3},
		{4, 0, 2},
		{7, 6, 1}};
	board begin_board(begin_state, 0);

	a_star_search(begin_board);
	return 0;
}
