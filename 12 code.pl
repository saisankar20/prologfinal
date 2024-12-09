% Initial state: two stacks of blocks
initial_state([
    on(a, b), on(b, table),
    on(c, d), on(d, table),
    clear(a), clear(c)
]).

% Goal state: inverted stacks
goal_state([
    on(b, a), on(a, table),
    on(d, c), on(c, table),
    clear(b), clear(d)
]).

% Move a block from one location to another
move([on(Block, From) | Rest], [on(Block, To), clear(From) | Rest], move(Block, From, To)) :-
    clear(Block, [on(Block, From) | Rest]),
    clear(To, [on(Block, From) | Rest]),
    To \= Block.

% Check if a block is clear (nothing on top of it)
clear(Block, State) :-
    \+ member(on(_, Block), State).

% Base case: plan succeeds if current state matches the goal state
plan(State, State, []).

% Recursive case: apply a move, update the state, and continue planning
plan(CurrentState, GoalState, [Move | RestMoves]) :-
    move(CurrentState, NewState, Move),
    plan(NewState, GoalState, RestMoves).

% Check if a block is clear (nothing on top of it)
clear(Block, State) :-
    \+ (member(on(_, Block), State)).

% Main predicate to find a plan
solve :-
    initial_state(InitialState),
    goal_state(GoalState),
    plan(InitialState, GoalState, Moves),
    write('Plan:'), nl,
    print_moves(Moves).

% Print the moves
print_moves([]).
print_moves([Move | Rest]) :-
    write(Move), nl,
    print_moves(Rest).
