#pragma once
#include "board.h"

void breadth_first_search(const board& begin, const board& goal);
void depth_first_search(const board& begin, const board& goal, size_t max_depth);
