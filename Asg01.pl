% Name: Michael Cote (mmcote)
% Course: CMPUT 325

% Question 1
% =============================================================================
% Reverses a given list
% N : New flipped list
% R : Original second list given
xreverse(L, R) :- fliplistcmp([], L, R).
fliplistcmp(E, [], E).
fliplistcmp(N, [H|T], R) :- fliplistcmp([H|N], T, R).

% Question 2
% =============================================================================
% return a list of only unique elements
% If found in the second list then move on to next element
% the first time it is found, every instance will be deleted
xunique([],[]).
xunique([H|T], [H|N]) :- delete(T, H, RT), xunique(RT, N).

% Question 3 
% =============================================================================
% Return the elements that are differing from the second list, whats unique in the 
% first
% L1 is the resulting list
xdiff(R, [], R).
xdiff(L1, [H|T], L) :- (member(H, L1) -> 
    % Remove the element from the second list
    delete(L1, H, RT1), delete(T, H, RT2), xdiff(RT1, RT2, L);
    % Call it again
    delete(T, H, RT2), xdiff(L1, RT2, L)).

% Question 4 
% =============================================================================
% remove last will return the last element of the list and the rest seperately
removeLast(L, L1, Last) :- reverse(L, RT), setLast(RT, L1, Last).
setLast([H|T], T, H).

% Question 5.1
% =============================================================================
% xsubset was a given function from the question
xsubset([], _).
xsubset([X|Xs], Set) :- xappend(_, [X|Set1], Set), xsubset(Xs, Set1).
xappend([], L, L).
xappend([H|T], L, [H|R]) :- xappend(T, L, R).

% all connected checks wheter all elements in the list are connected to each other
allConnected([]).
allConnected([H|T]) :- connect(H, T), allConnected(T).
% connect cycles through the rest of the elements checking if they are connected to E
connect(_, []).
connect(E, [E|T]) :- connect(E, T).
connect(E, [H|T]) :- edge(E, H), connect(E, T).
connect(E, [H|T]) :- edge(H, E), connect(E, T).

% Finds if a list is a clique
clique(L) :- findall(X,node(X),Nodes), xsubset(L,Nodes), allConnected(L).

% Question 5.2
% =============================================================================
% maxclique will find all the cliques of N-size as long as they do not have a larger clique
maxclique(N, L) :-
    % 1. Get all the cliques
    getCliques(AllCliques),
    % 2. Seperate into a list of N-size list, and larger than N
    removeExcessSizes(N, AllCliques, [], NSizedCliques),
    removeSmallerThan(N, AllCliques, [], LargerSizedCliques),
    % 3. Return only the valid nodes
    removeInvalidNodes(NSizedCliques, LargerSizedCliques, [], L).

% Helper function to return all original cliques
getCliques(AllCliques) :- findall(X,clique(X), AllCliques).

% Helper function to only return N-size lists
removeExcessSizes(_, [], Ret, Ret).
removeExcessSizes(N, [H|T], L, Ret) :- 
    length(H, SubListLength), (SubListLength =:= N -> 
    append(L, [H], ConfirmedCliques), removeExcessSizes(N, T, ConfirmedCliques, Ret);
    removeExcessSizes(N, T, L, Ret)).

% Similar helper function as above used to return only greater than N-size lists
removeSmallerThan(_, [], Ret, Ret).
removeSmallerThan(N, [H|T], L, Ret) :- 
    length(H, SubListLength), (SubListLength > N -> 
    append(L, [H], ConfirmedCliques), removeSmallerThan(N, T, ConfirmedCliques, Ret);
    removeSmallerThan(N, T, L, Ret)).

% Helper function to only return valid nodes
removeInvalidNodes([], _, Ret, Ret).
removeInvalidNodes([H|T], LargerCliques, ValidCliques, Ret) :- 
    checkValidity(H, LargerCliques, 0, IsValid), ((IsValid > 0) ->
        removeInvalidNodes(T, LargerCliques, ValidCliques, Ret);
        append(ValidCliques, [H], ReturnValidCliques), removeInvalidNodes(T, LargerCliques, ReturnValidCliques, Ret)
    ).

% Checks if a N-size list is valid or if they have a larger clique (invalid)
checkValidity(_, [], Ret, Ret).
checkValidity(NSizedClique, [H|T], Count, Ret) :- 
    (xsubset(NSizedClique, H) ->
        (NewCount is Count + 1), checkValidity(NSizedClique, [], NewCount, Ret);
        checkValidity(NSizedClique, T, Count, Ret)).
