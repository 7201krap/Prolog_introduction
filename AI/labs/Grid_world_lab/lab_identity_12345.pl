% How to run
% swipl ./ailp.pl lab identity

% actor(-Actor)	return each possible secret actor identity (e.g. 'Billy Bob Thornton')
% --> actor(A).

% wp(+Title,-WikiText)	connect to Wikipedia page with given Title and return its WikiText
% --> wp('Jeff Bridges', B).

% wp(+Title)	connect to Wikipedia page with given Title and print its WikiText
% --> wp('Jeff Bridges').

% wt_link(+WikiText, -Link)	return any Link contained in the given WikiText
% --> wt_link('[[Category:United States Coast Guard reservists]]', L).

% agent_ask_oracle(+A, +Orac, +Qu, -Ans)	This is used to question the oracle. If the Agent's
% Question is link then the Oracle's Answer will be a random link from the Wikipedia page
% whose title is the (name of the) secret random actor identity

% test	test if find_identity/1 successfully returns correct identity in all possible cases

% This is the main predicate, and should be true only when A is your identity

% ------------------------------------------------------------------------------
% find_identity(-A)

% actor_has_link(?L, ?A)
% Here, we are going to use this functor as: actor_has_link(+L, -A)
actor_has_link(L,A) :-
  actor(A),
  wp(A,WT), % return WT wp(+A,-WT)
  wt_link(WT,L).  % L contains any link contained in the given WikiText (WT)

% eliminate(+As, -A)
% This is a base case. 
eliminate([Last_viableAs], Final_answer) :-
  write("\n< Entering eliminate for final answer >\n"),

  % Final_answer is not yet selected

  Last_viableAs = Final_answer, % Final_answer is now unified with Last_viableAs
  % This indicates that we now know what is Final_answer

  write('\nFinal anwer: '),
  write(Final_answer),
  !. % base case

eliminate(As, A)  :-
  write("\n< Entering eliminate >\n"),

  % agent_ask_oracle(oscar,o(1),link,L) to gain a link L that belongs to the
  % secret actor. This link can be used to eliminate certain actors until
  % eventually there is only one possible actor left. This means that we need
  % to use agent_ask_oracle many times.
  agent_ask_oracle(oscar,o(1),link,L),

  write("\nWhat is link?: \n"),
  write(L),
  write("\n"),

  % 해석: actor_has_link(L) (사실 actor_has_link(L, As) 로 변환된다)
  % 여기에 만족되는 모든 후보를 ViableAs 에 넣는다.
  % 현재 actor_has_link(L, A) 이런 형태이다. 즉 한번에 하나의 후보를 받을 수 있다.
  % 그러나, include/3 를 쓰면 한번에 하나의 후보를 체크하여 가능한 모든 actor 을
  % ViableAs 에 넣는다.
  % 결국 제일 마지막에는 ViableAs 에 하나의 actor가 남을 것이다.
  include(actor_has_link(L), As, ViableAs), % viable : 실행가능한

  write("\nPossible Answer(Actor) after elimination: "),
  write(ViableAs),
  write("\n"),

  eliminate(ViableAs, A).
  % 여기에서 Answer(Actor) 를 찾는다. base case 를 이용하여 찾을 수 있다.


find_identity(A) :-
  findall(A,actor(A),As),

  write("Actor List: "),
  write(As),
  write("\n"),

  eliminate(As,A).

% ------------------------------------------------------------------------------
% This is a helper predicate and should find all the links for a particular actor
% Create a predicate that finds all the links on a given actors wikipedia page.
% find_links_by_actor(+A,-L)
find_links_by_actor(A,Links) :-
  wp(A, WT),
  findall(Link, wt_link(WT,Link), Links).
% 해석하면,
% 1. wp(A, WT) 를 하면 WT 에 모든 WikiText 가 담긴다.
% 2. 그 WT 를 이용해서 finds all the links on a given actors wikipedia page
% 3. findall built-in 함수를 이용하여 L 에 모든 링크들(Links) 를 넣어준다.
% ------------------------------------------------------------------------------
