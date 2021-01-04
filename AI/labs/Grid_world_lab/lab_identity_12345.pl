% actor(-Actor)	return each possible secret actor identity (e.g. 'Billy Bob Thornton')
% --> actor(A).

% wp(+Title,-WikiText)	connect to Wikipedia page with given Title and return its WikiText
% --> wp('Jeff Bridges', B).

% wp(+Title)	connect to Wikipedia page with given Title and print its WikiText
% --> wp('Jeff Bridges').

% wt_link(+WikiText, -Link)	return any Link contained in the given WikiText
% --> wt_link('[[Category:United States Coast Guard reservists]]', L).

% agent_ask_oracle(+A, +Orac,+Qu,-Ans)	This is used to question the oracle. If the Agent's
% Question is link then the Oracle's Answer will be a random link from the Wikipedia page
% whose title is the (name of the) secret random actor identity

% test	test if find_identity/1 successfully returns correct identity in all possible cases

% This is the main predicate, and should be true only when A is your identity

% ------------------------------------------------------------------------------
% find_identity(-A)

actor_has_link(L,A) :-
  actor(A),
  wp(A,WT),
  wt_link(WT,L).

eliminate([A],A) :- !.
eliminate(As,A)  :-
  % agent_ask_oracle(oscar,o(1),link,L) to gain a link L that belongs to the secret actor.
  % This link can be used to eliminate certain actors until eventually there is only one possible actor left.
  agent_ask_oracle(oscar,o(1),link,L),
  include(actor_has_link(L),As,ViableAs),
  eliminate(ViableAs,A).

find_identity(A) :-
  findall(A,actor(A),As),
  eliminate(As,A).

% ------------------------------------------------------------------------------
% This is a helper predicate and should find all the links for a particular actor
% Create a predicate that finds all the links on a given actors wikipedia page.
% find_links_by_actor(+A,-L)
find_links_by_actor(A,L) :-
  wp(A, WT),
  findall(Links, wt_link(WT,Links), L).
% 해석하면,
% 1. wp(A, WT) 를 하면 WT 에 모든 WikiText 가 담긴다.
% 2. 그 WT 를 이용해서 finds all the links on a given actors wikipedia page
% 3. findall built-in 함수를 이용하여 L 에 모든 링크들(Links) 를 넣어준다.
% ------------------------------------------------------------------------------
