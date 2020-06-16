/**
* Created by ricklamers on 18/02/14.
*/
var model = require('./Model');

var Game = (function () {
    function Game() {
        //instantiate a CardManager
        var cardManager = new model.CardManager();

        var deck = cardManager.getAnimalDeck();

        var startingMoneyCards = cardManager.getStartingMoneyCards();
        console.log(deck.length);

        var firstAnimalCard = startingMoneyCards[startingMoneyCards.length - 1];
        console.log(firstAnimalCard.getValue);
    }
    return Game;
})();
exports.Game = Game;
//# sourceMappingURL=Game.js.map
