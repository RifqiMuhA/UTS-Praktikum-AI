% Start Rules (Knowledge Base)
/* Knowledge Base */
vertebrata(aves):-
    cold_blood(no),
    have_mamae(no).
vertebrata(mamalia):-
    cold_blood(no),
    have_mamae(yes).
vertebrata(amphibi):-
    cold_blood(yes),
    have_scale(no).
vertebrata(pisces):-
    cold_blood(yes),
    have_scale(yes),
    have_gill(yes).
vertebrata(reptilia):-
    cold_blood(yes),
    have_scale(yes),
    have_gill(no).

% End Rules (Knowledge Base)

% Start User Interface
/* Asking the user */
cold_blood(X):- 
    menuask('berdarah dingin', X, [yes, no]).
have_mamae(X):- 
    menuask('memiliki mammae', X, [yes, no]).
have_scale(X):- 
    menuask('bersisik', X, [yes, no]).
have_gill(X):- 
    menuask('bernafas dengan insang', X, [yes, no]).

/* 
   Menus for user & Remembering the answer
   Parameter : A => pertanyaan
               V => jawaban user
               Menulist => List jawaban yang diperbolehkan 
*/
menuask(A, V, _MenuList):-
    known(A, yes, V), % succeed if true
    !. % stop looking
menuask(A, _V, _MenuList):-
    known(A, _, __), % fail if false
    !,
    fail.
menuask(A, V, MenuList) :-
    write('Apakah hewan ini '), write(A), write('?'), nl,
    write(MenuList), nl,
    read(X),
    check_val(X, A, V, MenuList),
    asserta( known(A, yes, X) ),
    X == V.

/* Check input */
check_val(X, _A, _V, MenuList) :-
    member(X, MenuList),
    !.
check_val(X, A, V, MenuList) :-
    write(X), write(' merupakan jawaban ilegal.'), nl,
    menuask(A, V, MenuList). 

/* Member rules */
member(X,[X|_]).
member(X,[_|T]):-member(X,T).
% End User Interface

% Start Simple Shell
/* Simple shell */
top_goal(X) :- vertebrata(X). 

solve :-
    abolish(known, 3),
    top_goal(X),
    write('Hewan vertebrata tersebut termasuk ke klasifikasi '), write(X), write('.'), nl, nl.
solve :-
    write('Jawaban tidak ditemukan.'), nl. 

/* Command loop */
go :-
    greeting,
    repeat,
    start_quit,
    write('> '),
    read(X),
    do(X),
    X == quit.

greeting :-
    write('Selamat Datang di Program Klasifikasi Vertebrata.'), nl.

start_quit :-
    write('Pilih start atau quit'), nl.

/* Running Program */
do(start) :-
    solve,
    !.

/* Quit Program */
do(quit).
do(X) :-
    write(X),
    write(' is not a legal command.'), nl,
    fail. 
% End Simple Shell

/* handle undefined procedure */
:- unknown(trace, fail).