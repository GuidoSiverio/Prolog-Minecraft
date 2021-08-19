jugador(stuart, [piedra, piedra, piedra, piedra, piedra, piedra, piedra, piedra], 3).
jugador(tim, [madera, madera, madera, madera, madera, pan, carbon, carbon, carbon, pollo, pollo], 8).
jugador(steve, [madera, carbon, carbon, diamante, panceta, panceta, panceta], 2).

lugar(playa, [stuart, tim], 2).
lugar(mina, [steve], 8).
lugar(bosque, [], 6).

comestible(pan).
comestible(panceta).
comestible(pollo).
comestible(pescado).


% PUNTO 1

% A)
tieneItem(Nombre, Item):-
    jugador(Nombre, ListaItems, _),
    member(Item, ListaItems).
    
% B)
sePreocupaPorSuSalud(Nombre):-
    jugador(Nombre, ListaItems, _),
    member(Comida, ListaItems),
    comestible(Comida),
    member(OtraComida, ListaItems),
    comestible(OtraComida),
    Comida \= OtraComida.

% C)
cantidadDeItem(Nombre, Item, Cantidad):-
    jugador(Nombre, ListaItems, _),
    poseeElItem(ListaItems, Item, Cantidad).

poseeElItem(ListaItems, Item, Cantidad):-
    findall(Item, member(Item, ListaItems), Lista),
    length(Lista, Cantidad).

poseeElItem(ListaItems, Item, 0):-
    not(member(Item, ListaItems)).
    
% D)
tieneMasDe(Nombre, Item):-
    cantidadDeItem(Nombre, Item, Cantidad),
    forall(cantidadDeItem(_, Item, OtraCant), Cantidad >= OtraCant).


% PUNTO 2

% A)
hayMonstruos(Lugar):-
    lugar(Lugar, _, Oscuridad),
    Oscuridad > 6.

% B)
correPeligro(Nombre):-
    jugador(Nombre, _, _),
    lugar(Lugar, Nombres, _),
    member(Nombre, Nombres),
    hayMonstruos(Lugar).

correPeligro(Nombre):-
    jugador(Nombre, ListaItems, Hambre),
    estaHambriento(Hambre),
    forall(member(Item, ListaItems), not(comestible(Item))).

estaHambriento(Hambre):-
    Hambre < 4.

% C)
nivelPeligrosidad(Lugar, Peligrosidad):-
    lugar(Lugar, [], Oscuridad),
    Peligrosidad is Oscuridad * 10.

nivelPeligrosidad(Lugar, 100):-
    hayMonstruos(Lugar).

nivelPeligrosidad(Lugar, Peligrosidad):-
    lugar(Lugar, Personas, _),
    not(hayMonstruos(Lugar)),
    poblacionTotal(Personas, Poblacion),
    hambrientos(Personas, Hambrientos),
    Peligrosidad is (Hambrientos / Poblacion) * 100.

poblacionTotal(Personas, Poblacion):-
    length(Personas, Poblacion).

hambrientos(Personas, Hambrientos):-
    findall(Hambriento, (member(Hambriento, Personas), personaConHambre(Hambriento)), ListaHambrientos),
    length(ListaHambrientos, Hambrientos).

personaConHambre(Persona):-
    jugador(Persona, _, Hambre),
    estaHambriento(Hambre).


% PUNTO 3

item(horno, [ itemSimple(piedra, 8) ]).
item(placaDeMadera, [ itemSimple(madera, 1) ]).
item(palo, [ itemCompuesto(placaDeMadera) ]).
item(antorcha, [ itemCompuesto(palo), itemSimple(carbon, 1) ]).

puedeConstruir(Nombre, Item):-
    jugador(Nombre, _, _),
    item(Item, ItemsNecesarios),
    forall(member(Necesario, ItemsNecesarios), tieneElItemNecesario(Nombre, Necesario)).

tieneElItemNecesario(Nombre, itemSimple(Necesario, CantidadNecesaria)):-
    cantidadDeItem(Nombre, Necesario, Cantidad),
    Cantidad >= CantidadNecesaria.

tieneElItemNecesario(Nombre, itemCompuesto(Necesario)):-
    puedeConstruir(Nombre, Necesario).


% PUNTO 4

% A) Nos devuelve falso, ya que desierto no pertenece a nuesto universo cerrado en "lugar".

% B) La ventaja que se visualiza a la hora de las consultas del paradigma logico frente al paradigma funcional es que 
%    en este paradigma podemos quien cumple el predicado utilizando variables, caso que en funcional no sucede.