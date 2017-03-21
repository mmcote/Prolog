xreverse(L, R) :- fliplistcmp([], L, R).

% N : New flipped list
% R : Original second list given
fliplistcmp(N, [H|T], R) :- fliplistcmp([H|N], T, R).

% E : Both lists should be equal
fliplistcmp(E, [], E).

% Or from the notes
reverse([], []).
reverse([A|L1], L2) :- reverse(L1, N), append(N, [A], L2).

% xunique([a,c,a,d], O) should return O = [a,c,d], 
% xunique([a,c,a,d], [a,c,d]) should return true, 
% xunique([a,c,a,d], [c,a,d]) should return false (because of wrong order), 
% xunique([a,a,a,a,a,b,b,b,b,b,c,c,c,c,b,a], O) should return O = [a,b,c], 
% xunique([], O) should return O = [].

% Simple xmember function.
% There is already a member function in prolog, although
% this was just for practice.
xmember(E, [H|T]) :- compareelements(E, H, T).
compareelements(E, E, _).
compareelements(E, _, [H|T]) :- compareelements(E, H, T).

% append(L1,L2,L3): append L1 and L2 to get L3.
% Finally after make sure the second list is equivalent
append([],L,L).
% First make sure the first list is equivalent
append([A|L],L1,[A|L2]) :- append(L,L1,L2).

plus(0, X, X).
plus(s(X), Y, s(Z)) :- plus(X,Y,Z).

mult(0, X, 0).
mult(s(0), X, X).
mult(s(X), Y, N) :- mult(X, Y, N1), plus(Y, N1, N).

fact(0, s(0)).
fact(s(0), s(0)).
fact(s(X), N) :- fact(X, N1), mult(N1, s(X), N).


% Simple delete function.
% Delete E from the second arg list
% Third arg is the output

% Remove the matching element
% remove(E, [], []) :- write(N).
% remove(E, [E|T], N) :- remove(E, T, N). 
% remove(E, [H|T], N) :- remove(E, T, [N|H]).

% remove([E|T], E,L1) :- !, remove(T,X,L1).
% remove([H|T],X,[H|L1]) :- remove(T,X,L1). 

% UH : Unique Head
% UT : Unique Tail

% If found in the second list then move on to next element
% the first time it is found, every instance will be deleted
xunique([H|T], [H|N]) :- delete(T, H, RT), xunique(RT, N).
xunique([],[]).
% checkUnique([H|T], O) :- xmember(H, )

sum([],0).
sum(N,N) :- number(N).
sum([A|L],S) :- sum(A,S1), sum(L,S2), S is S1 + S2.



% xmembertwo(A,L): A is in list L
xmembertwo(A,[A|L]).
xmembertwo(A,[B|L]) :- A \== B, xmembertwo(A,L).

% This function solves finding the unique elements of both lists
% and outputting them into a single list
% Base case set remainder of the second list to L
% xdiff([], R, R).
% xdiff([H1|T], L1, L) :- (member(H1, L1) -> 
%    % Remove the element from the second list
%    delete(L1, H1, RT2), delete(T, H1, RT1), xdiff(RT1, RT2, L);
%    % Call it again
%    delete(T, H1, RT1), xdiff(RT1, [H1|L1], L)).


% L1 is the resulting list
xdiff(R, [], R).
xdiff(L1, [H|T], L) :- (member(H, L1) -> 
    % Remove the element from the second list
    delete(L1, H, RT1), delete(T, H, RT2), xdiff(RT1, RT2, L);
    % Call it again
    delete(T, H, RT2), xdiff(L1, RT2, L)).

removeLast(L, L1, Last) :- reverse(L, RT), setLast(RT, L1, Last).
setLast([H|T], T, H).



node(a).
node(b).
node(c).
node(d).
node(e).

edge(a,b).
edge(b,c).
edge(c,a).
edge(d,a).
edge(a,e).

xsubset([], _).
xsubset([X|Xs], Set) :- xappend(_, [X|Set1], Set), xsubset(Xs, Set1).
xappend([], L, L).
xappend([H|T], L, [H|R]) :- xappend(T, L, R).

allConnected([]).
allConnected([H|T]) :- connect(H, T), allConnected(T).
connect(_, []).
connect(E, [E|T]) :- connect(E, T).
connect(E, [H|T]) :- edge(E, H), connect(E, T).
connect(E, [H|T]) :- edge(H, E), connect(E, T).

clique(L) :- findall(X,node(X),Nodes), xsubset(L,Nodes), allConnected(L).
