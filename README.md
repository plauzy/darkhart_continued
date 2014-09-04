darkhart
========

### Web-based, mobile-first Cards Against Humanity game. 

#### Team Members
- Cassidy Clawson (lead)
- Chandler Smith
- Ian Bui
- Patrick Lauer
- Brooks Roley

#### MVP For Monday Scope
Classic rails on postgres app with standard CRUD routes/views/erb templates.  
- One persistant game with unlimited play round.
- 4 hardcoded users with name and score attributes.
- Real card data.

#### User Stories
- As a user, I want to recieve a "hand" of white cards (10) on game initiation because I need funny white cards to consider.
- As a user, I want one user to serve as a "round leader" in each round.
- As a user, if I am not round leader, I want to be a "player" in the round.
- As a round leader, I want to be served a "black card" in a round.
- As a round player, I want to compare my hand against the leader's black card and select one card for consideration by the round leader.  
- As a user, I want access to a game state screen which provides information on the current round, including user scores, who is a leader and who is a player, and who has and hasn't chosen cards for the round.
- As a user, I want to the round to conclude after the round leader selects his or her favorite user card. 
- As a user, I want to see a round recap screen which includes all submitted cards.
