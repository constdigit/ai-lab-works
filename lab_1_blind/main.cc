#include <iostream>

#include "board.h"
#include "search.h"

int main(int argc, char* argv[]) {
	uint8_t begin[3][3] =
		{{5, 8, 3},
		{4, 0, 2},
		{7, 6, 1}};
	board begin_board(begin);

	uint8_t goal[3][3] =
		{{1, 2, 3},
		{4, 5, 6},
		{7, 8, 0}};
	board goal_board(goal);

	breadth_first_search(begin, goal);
	return 0;
}
