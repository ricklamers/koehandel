/**
 * Created by ricklamers on 18/02/14.
 */
import model = require('./Model');


export class Game{

    constructor(){

        //instantiate a CardManager

        var cardManager:model.CardManager = new model.CardManager();

        var deck:Array<model.AnimalCard> = cardManager.getAnimalDeck();


        var startingMoneyCards:Array<model.MoneyCard> = cardManager.getStartingMoneyCards();
        console.log(deck.length);

        var firstAnimalCard:model.MoneyCard = startingMoneyCards[startingMoneyCards.length-1];
        console.log(firstAnimalCard.getValue);

    }
}