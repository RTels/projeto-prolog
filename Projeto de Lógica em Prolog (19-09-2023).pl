% Student exercise profile
:- set_prolog_flag(occurs_check, error).        % disallow cyclic terms
:- set_prolog_stack(global, limit(8 000 000)).  % limit term space (8Mb)
:- set_prolog_stack(local,  limit(4 000 000)).  % limit environment space

% Alunos: Rafael Teles, Danilo Fortes, Júlio Bem

%				 -----------------Nomes------------------

% eu (...)
% john = Meu Filho com a Viúva (Mary)
% mac = Meu Pai
% mary = Viúva (Minha Esposa)
% wendy = Ruiva (Filha da Viúva)
% ben = Filho do Meu Pai com a Ruiva (Wendy)

%			     ---------------Statements---------------

genitor(mac, eu).
genitor(mac, ben).
genitor(eu, john).
genitora(mary, wendy).
genitora(mary, john).
genitora(wendy, ben).
casal(eu, mary).
casal(mac, wendy).
menino(john).
menino(ben).

%				 -----------------Rules------------------

homem(X) :- genitor(X,_); menino(X).
mulher(X) :- genitora(X,_).
padrasto(X,Y) :- (genitora(Z,Y), casal(X,Z)), \+ (genitor(X,Y)).
madrasta(X,Y) :- (genitor(Z,Y), casal(Z,X)), \+ (genitora(X,Y)).
pai(X,Y) :- genitor(X,Y); padrasto(X,Y).
mãe(X,Y) :- genitora(X,Y); madrasta(X,Y).
pai_ou_mãe(X,Y) :- pai(X,Y); mãe(X,Y).
marido(X,Y) :- casal(X,Y).
esposa(X,Y) :- casal(Y,X).
filho(X,Y) :- pai_ou_mãe(Y,X), homem(X).
filha(X,Y) :- pai_ou_mãe(Y,X), mulher(X).
irmão(X,Y) :- pai_ou_mãe(Z,X), pai_ou_mãe(Z,Y), homem(X), X \= Y.
irmã(X,Y) :- pai_ou_mãe(Z,X), pai_ou_mãe(Z,Y), mulher(X), X \= Y.
cunhado(X,Y) :- (casal(Y,Z), irmão(X,Z)); (casal(Z,Y), irmão(X,Z)).
cunhada(X,Y) :- (casal(Y,Z), irmã(X,Z)); (casal(Z,Y), irmã(X,Z)).
genro(X,Y) :- casal(X,Z), filha(Z,Y).
nora(X,Y) :- casal(Z,X), filho(Z,Y).
sogro(X,Y) :- (genro(Y,X); nora(Y,X)), homem(X).
sogra(X,Y) :- (genro(Y,X); nora(Y,X)), mulher(X).
tio(X,Y) :- irmão(X,Z), pai_ou_mãe(Z,Y).
tia(X,Y) :- irmã(X,Z), pai_ou_mãe(Z,Y).
avô(X,Y) :- pai(X,Z), pai_ou_mãe(Z,Y).
avó(X,Y) :- mãe(X,Z), pai_ou_mãe(Z,Y).
neto(X,Y) :- (avô(Y,X); avó(Y,X)), homem(X).
neta(X,Y) :- (avô(Y,X); avó(Y,X)), mulher(X).
bisavô(X,Y) :- pai(X,Z), (avô(Z,Y); avó(Z,Y)).
bisavó(X,Y) :- mãe(X,Z), (avô(Z,Y); avó(Z,Y)).
bisneto(X,Y) :- (bisavô(Y,X); bisavó(Y,X)), homem(X).
bisneta(X,Y) :- (bisavô(Y,X); bisavó(Y,X)), mulher(X).

/*
				----------------Queries------------------
                
1. avô(eu,eu).             "Oh eu sou meu próprio avô."
2. genro(mac,eu).          "Isso fez meu papai, meu genro, e mudou minha vida."
3. mãe(wendy,eu).          "Minha filha tornou-se minha mãe, porque era mulher do meu pai."
4. cunhado(john,mac).      "Meu bebezinho ficou sendo cunhado do meu pai."
5. tio(john,eu).           "Meu bebezinho ... tornou-se meu tio."
6. madrasta(wendy,eu).     "A filha da viuva se tornou também minha madrasta."
7. neto(ben,eu).           "A mulher do meu pai então teve um filho e se tornou meu neto."
8. avó(mary,eu).           "Porque embora ela sendo minha mulher, ela é também minha avó."
9. neto(eu,mary).          "Agora, se minha mulher é minha avó, então eu sou seu neto."

				------------------End--------------------
*/
