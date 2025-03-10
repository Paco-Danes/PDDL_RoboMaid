%%% IndiGolog domain for a simple cleaning 

:- dynamic controller/1.
:- discontiguous proc/2, causes_true/3, causes_false/3, fun_fluent/1, rel_fluent/1.

cache(_) :- fail.

%%%% OBJECT DEFINITIONS %%%%

room(room1).
room(room2).
room(room3).
room(room4).
room(room5).
room(room6).

rel_fluent(at(R)) :- room(R).
rel_fluent(connected(R1, R2)) :- room(R1), room(R2).
rel_fluent(dirty(R)) :- room(R).
rel_fluent(trash_at(R)) :- room(R).
rel_fluent(trash_bin_at(R)) :- room(R).
rel_fluent(charging_base_at(R)) :- room(R).
rel_fluent(charged(robot)).
rel_fluent(has_trash(robot)).

%%%% INITIAL STATE %%%%

initially(at(room1), true).
initially(charged(robot), true).

initially(connected(room1, room2), true).
initially(connected(room2, room1), true).
initially(connected(room2, room5), true).
initially(connected(room5, room2), true).
initially(connected(room4, room5), true).
initially(connected(room5, room4), true).
initially(connected(room3, room6), true).
initially(connected(room6, room3), true).
initially(connected(room2, room3), true).
initially(connected(room3, room2), true).

initially(dirty(room5), true).
initially(dirty(room2), true).

initially(trash_at(room6), true).
initially(trash_bin_at(room4), true).
initially(has_trash(robot), false).

initially(charging_base_at(room2), true).

%%%% ACTION DEFINITIONS %%%%

% Moving between connected rooms
prim_action(move(R1, R2)) :- room(R1), room(R2).
poss(move(R1, R2), and(at(R1), connected(R1, R2))).
causes_true(move(R1, R2), at(R2), true).
causes_false(move(R1, R2), at(R1), true).

% Cleaning a dirty room (requires charge)
prim_action(clean(R)) :- room(R).
poss(clean(R), (charged(robot), at(R), dirty(R))).
causes_false(clean(R), dirty(R), true).
causes_false(clean(R), charged(robot), true).

% Picking up trash (requires charge and no current trash)
prim_action(pickup_trash(R)) :- room(R).
poss(pickup_trash(R), (charged(robot), at(R), trash_at(R), not(has_trash(robot)))).
causes_true(pickup_trash(R), has_trash(robot), true).
causes_false(pickup_trash(R), trash_at(R), true).
causes_false(pickup_trash(R), charged(robot), true).

% Dropping trash in a trash-bin
prim_action(drop_trash(R)) :- room(R).
poss(drop_trash(R), (at(R), trash_bin_at(R), has_trash(robot))).
causes_false(drop_trash(R), has_trash(robot), true).

% Recharging at a charging base
prim_action(recharge).
poss(recharge, (at(R), charging_base_at(R), not(charged(robot)))).
causes_true(recharge, charged(robot), true).


%%%% HIGH-LEVEL CONTROL PROGRAM %%%%
proc(illegal, [move(room1, room2), move(room2, room5), move(room5, room4), drop_trash(room4) ]).
proc(legal, [move(room1, room2), move(room2, room5), clean(room5), move(room5, room2), recharge ]).
proc(proj_seq, [move(room1, room2), move(room2, room3), move(room3, room6), pickup_trash(room6), move(room6, room3)]).


% all actions with non-deterministically chosen parameters
proc(pi_move,
  pi([r1, r2], move(r1, r2))
).

proc(pi_clean,
  pi(r, clean(r))
).

proc(pi_pickup_trash,
  pi(r, pickup_trash(r))
).

proc(pi_drop_trash,
  pi(r, drop_trash(r))
).

proc(pi_recharge,
    recharge
).

/* full_search controller: choose non-deterministically random actions 
   until it finds a solution */
proc(control(full_search), search( [ star(ndet(pi_move, pi_clean)), ?(neg(dirty(room2)) ) ] )).

exog_occurs(_Action) :- false.
