:- [adts].
move([e,J1,J2,J3,J4], [J1,e,J2,J3,J4]).
move([e,J1,J2,J3,J4], [J2,J1,e,J3,J4]).
move([J1,e,J2,J3,J4], [e,J1,J2,J3,J4]).
move([J1,e,J2,J3,J4], [J1,J2,e,J3,J4]).
move([J1,e,J2,J3,J4], [J1,J3,J2,e,J4]).
move([J1,J2,e,J3,J4], [e,J2,J1,J3,J4]).
move([J1,J2,e,J3,J4], [J1,e,J2,J3,J4]).
move([J1,J2,e,J3,J4], [J1,J2,J3,e,J4]).
move([J1,J2,e,J3,J4], [J1,J2,J4,J3,e]).
move([J1,J2,J3,e,J4], [J1,e,J3,J2,J4]).
move([J1,J2,J3,e,J4], [J1,J2,e,J3,J4]).
move([J1,J2,J3,e,J4], [J1,J2,J3,J4,e]).
move([J1,J2,J3,J4,e], [J1,J2,J3,e,J4]).
move([J1,J2,J3,J4,e], [J1,J2,e,J4,J3]).
%unsafe(0).
% In predicate heuristic(State,Goal,Value), Value is to be calculated as the
% estimated distance from the State to the Goal, e.g., in the 8-puzzle this
% might be the number of tiles out of place in State compared with Goal.
heuristic([A1,B1,C1,D1,E1], [A2,B2,C2,D2,E2], R) :-
check(A1, A2, R1), check(B1, B2, R2), check(C1, C2, R3), check(D1, D2, R4), check(E1,
E2, R5),
R is R1+R2+R3+R4+R5.
check(X,Y,S) :- X \= Y, !, S is 1.
check(_,_,0).
% The precedes predicate is needed for the priorty-queue code in the atds
% file. The positions between the [ and ] represent State, Parent (of State),
% Depth (from of State from root), Heuristic (value for State),
% Depth+Heurstic (the value of the evaluation function f(n)=g(n)+h(n)).
precedes([_,_,_,_,F1],[_,_,_,_,F2]) :- F1 =< F2.
%%%%%%% Best first search algorithm %%%%%%%%%
% go initializes Open and Closed and calls path
go(Start, Goal) :-
empty_set(Closed_set),
empty_pq(Open),
heuristic(Start, Goal, H),
insert_pq([Start, nil, 0, H, H], Open, Open_pq),
path(Open_pq, Closed_set, Goal).
% Path performs a best first search,
% maintaining Open as a priority queue, and Closed as
% a set.
% Open is empty; no solution found
path(Open_pq, _, _) :-
empty_pq(Open_pq),
write('graph searched, no solution found').
% The next record is a goal
% Print out the list of visited states
path(Open_pq, Closed_set, Goal) :-
dequeue_pq([State, Parent, _, _, _], Open_pq, _),
State = Goal,
write('Solution path is: '), nl,
printsolution([State, Parent, _, _, _], Closed_set).
% The next record is not equal to the goal
% Generate its children, add to open and continue
path(Open_pq, Closed_set, Goal) :-
dequeue_pq([State, Parent, D, H, S], Open_pq, Rest_of_open_pq),
get_children([State, Parent, D, H, S], Rest_of_open_pq, Closed_set, Children, Goal),
insert_list_pq(Children, Rest_of_open_pq, New_open_pq),
union([[State, Parent, D, H, S]], Closed_set, New_closed_set),
path(New_open_pq, New_closed_set, Goal),!.
get_children([State, _, D, _, _], Rest_of_open_pq, Closed_set, Children, Goal) :-
bagof(Child, moves([State, _, D, _, _], Rest_of_open_pq, Closed_set, Child, Goal),
Children);
empty_set(Children).
% moves generates all children of a state that are not already on
% open or closed. For each child, it adds 1 to the current depth D % calculates theheuristic H for the child, as well as the sum S of
% these two values (i.e., calculation of f(n)=g(n)+h(n)).
% Also, unsafe is commented out as we don't need it here.
moves([State, _, Depth, _, _], Rest_of_open_pq, Closed_set, [Next, State, New_D, H,S], Goal) :-
move(State, Next),
% not(unsafe(Next)),
not(member_pq([Next, _, _, _, _], Rest_of_open_pq)),
not(member_set([Next, _, _, _, _], Closed_set)),
New_D is Depth + 1,
heuristic(Next, Goal, H),
S is New_D + H.
% Printsolution prints out the solution path by tracing
% back through the states on closed using parent links.
printsolution([State, nil, _, _, _], _):-
write(State), nl.
printsolution([State, Parent, _, _, _], Closed_set) :-
member_set([Parent, Grandparent, _, _, _], Closed_set),
printsolution([Parent, Grandparent, _, _, _], Closed_set),
write(State), nl.
size([],0).
size([H|T], N) :- size(T, N1), N is N1+1.
writelist([]).
writelist([H|T]):-write(H),nl,writelist(T).
