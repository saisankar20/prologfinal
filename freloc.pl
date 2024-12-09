% Facts
collie(fred).
master(fred, sam).
day(saturday).
not(warm(saturday)).
trained(fred).

% Rules
gooddog(X) :-
    spaniel(X);
    (collie(X),trained(X)).

location(X,Z) :-
    gooddog(X),
    master(X,Y),
    location(Y,Z).

location(sam, park) :-
    day(saturday),
    warm(saturday).

location(sam, museum) :-
    day(saturday),
    not(warm(saturday)).

% Initialize predicates
spaniel(spot).
warm(today).

% Query
:- location(fred,X).
