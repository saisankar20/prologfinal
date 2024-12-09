investment(savings) :- savings_Account(inadequate).
investment(stocks) :- savings_Account(adequate), income(adequate).
investment(combination) :- savings_Account(adequate),
income(inadequate).
savings_Account(adequate) :- amount_Saved(X), dependents_Value(Y),
mini_Savings(Y, B), X > B.
savings_Account(inadequate) :- amount_Saved(X), dependents_Value(Y),
mini_Savings(Y, B), not(X > B).
income(adequate) :- earnings(X, steady), dependents_Value(Y),
mini_Income(Y, B), X > B.
income(inadequate) :- earnings(X, steady), dependents_Value(Y),
mini_Income(Y, B), not(X > B).
income(inadequate) :- earnings(_, unsteady).
mini_Savings(A, B) :- B = 5000 * A.
mini_Income(A, B) :- B = 15000 + (4000 * A).
amount_Saved(20000).
earnings(30000, steady).
dependents_Value(2).
