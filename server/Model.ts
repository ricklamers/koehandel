export class MoneyCard{
	_value:number;
	constructor(value:number){
		this._value = value;
	}

	get getValue(){
		return this._value;
	}
}

export class AnimalCard{
    _name:string;
    _value:number;
    _prefix:string;
    _nameTranslations:Array<string>;

    constructor(name:string, value:number, translationNames:Array<string>, prefix:string = "de"){
        this._value = value;
        this._name = name;
        this._prefix = prefix;
        this._nameTranslations = translationNames;
    }

    public getAnimalName():string{
        return this._name;
    }
    public getAnimalValue():number{
        return this.value;
    }
    public get value():number{
        return this._value;
    }
    public get name():string{
        return this._name;
    }
    public get dutchNameWithPrefix():string{
        return this._prefix+" "+this._nameTranslations[0];
    }
}


export class CardManager
{
    public animalNames:Array<string> = ["cat","chicken","cow","dog","donkey","duck","goat","horse","pig","sheep"];
    public animalPrefixes:Array<string> = ["de", "de", "de", "de", "de", "de", "de", "het", "het", "het"];
    public animalNamesTranslations:Array<Array<string>> = [["kat"],["kip"],["koe"],["hond"],["ezel"],["gans"],["geit"],["paard"],["varken"],["schaap"]];
    public animalValues:Array<number> = [90,10,800,160,500,40,350,1000,650,250];

    constructor()
    {
        //empty construct
    }
    public getStartingMoneyCards():Array<MoneyCard>{
        var startingCards:Array<MoneyCard> = [];

        // two 0, four 10, one 50
        startingCards.push(new MoneyCard(0));
        startingCards.push(new MoneyCard(0));

        startingCards.push(new MoneyCard(10));
        startingCards.push(new MoneyCard(10));
        startingCards.push(new MoneyCard(10));
        startingCards.push(new MoneyCard(10));

        startingCards.push(new MoneyCard(50));

        return startingCards;
    }

    public getAnimalDeck():Array<AnimalCard>{
        var animalDeck:Array<AnimalCard> = [];
        for(var index in this.animalNames){
            for(var x = 0;x<4;x++){
                animalDeck.push(new AnimalCard(this.animalNames[index],this.animalValues[index], this.animalNamesTranslations[index], this.animalPrefixes[index]));
            }
        }

        animalDeck.sort(this.randomSort);

        return animalDeck;
    }

    private randomSort(a:any, b:any):number
    {
            if (Math.random() < 0.5) return -1;
            else return 1;
    }

public static haveAnimalWithValue(value:number, animalCards:Array<AnimalCard>):Boolean{
    for(var x in animalCards){
        var animalCard:AnimalCard = animalCards[x];
        if(animalCard.value == value){
            return true;
        }
    }
    return false;
}
public static checkAmountForName(name:string, cards:Array<AnimalCard>):number{
    var amount:number = 0;
    for(var i in cards){
        if(cards[i].getAnimalName() == name){
            amount ++;
        }
    }
    return amount;
}

public static checkAmountForValue(value:number,moneyCards:Array<MoneyCard>):number{
    var amount:number = 0;
    for(var i in moneyCards){
        if(moneyCards[i].getValue == value){
            amount ++;
        }
    }
    return amount;
}
public static checkAnimalAmountForValue(value:number,animalCards:Array<AnimalCard>):number{
    var amount:number = 0;
    for(var i in animalCards){
        if(animalCards[i].value == value){
            amount ++;
        }
    }
    return amount;
}
public static getIndexOfMoneyCardForValue(value:number, moneyCards:Array<MoneyCard>):number{
    for(var x in moneyCards){
        var moneyCard:MoneyCard = moneyCards[x];
        if(moneyCard.getValue == value){
            return parseInt(x);
        }
    }
    return -1;
}
public static checkAmountOfDifferentAnimals(animalArray:Array<AnimalCard>):number
{
    var count:number = 0;
    var countedAnimalsArray:Array<string> = [];
    for(var x in animalArray){
        if(countedAnimalsArray.indexOf(animalArray[x].name) == -1){
            countedAnimalsArray.push(animalArray[x].name);
            count ++;
        }
    }
    return count;
}
public static checkAmountOfDifferentMoneyCards(moneyCards:Array<MoneyCard>):number{
    var count:number = 0;
    var countedMoneyValues:Array<number> = [];
    for(var x in moneyCards){
        if(countedMoneyValues.indexOf(moneyCards[x].getValue) == -1){
            countedMoneyValues.push(moneyCards[x].getValue);
            count ++;
        }
    }
    return count;
}

public static getAnimalByName(animalName:string, animalCards:Array<AnimalCard>):AnimalCard
{
    for(var x in animalCards){
        var animal:AnimalCard = animalCards[x];
        if(animal.getAnimalName() == animalName){
            return animal;
        }
    }
    return null;
}

public static getMoneyCardByName(moneyCardValue:string, moneyCards:Array<MoneyCard>):MoneyCard
{
    for(var x in moneyCards){
        var moneyCard:MoneyCard = moneyCards[x];
        if(moneyCard.getValue == parseInt(moneyCardValue)){
            return moneyCard;
        }
    }
    return null;
}

public static getTotalForMoneyCards(moneyCards:Array<MoneyCard>):number
{
    var amount:number = 0;
    for(var i in moneyCards){
        amount += moneyCards[i].getValue;
    }
    return amount;
}


public static  checkAnimalAmountForName(name:string,animalCards:Array<AnimalCard>):number{
    var amount:number = 0;
    for(var i in animalCards){
        if(animalCards[i].name == name){
            amount ++;
        }
    }
    return amount;
}

public static doubleTradePossible(animalName:string, animalCards:Array<AnimalCard>, animalCards2:Array<AnimalCard>):Boolean
{
    var amountPlayer1:number;
    for(var x in animalCards){
        var animalCard:AnimalCard = animalCards[x];
        if(animalCard.name == animalName){
            amountPlayer1 ++;
        }
    }
    var amountPlayer2:number;
    for(var y in animalCards2){
        var animalCard2:AnimalCard = animalCards2[y];
        if(animalCard2.name == animalName){
            amountPlayer2 ++;
        }
    }
    console.log('here is all good');

    if(amountPlayer1 == 2 && amountPlayer2 == 2){
        return true;
    }
    return false;
}
}