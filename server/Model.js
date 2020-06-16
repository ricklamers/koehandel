var MoneyCard = (function () {
    function MoneyCard(value) {
        this._value = value;
    }
    Object.defineProperty(MoneyCard.prototype, "getValue", {
        get: function () {
            return this._value;
        },
        enumerable: true,
        configurable: true
    });
    return MoneyCard;
})();
exports.MoneyCard = MoneyCard;

var AnimalCard = (function () {
    function AnimalCard(name, value, translationNames, prefix) {
        if (typeof prefix === "undefined") { prefix = "de"; }
        this._value = value;
        this._name = name;
        this._prefix = prefix;
        this._nameTranslations = translationNames;
    }
    AnimalCard.prototype.getAnimalName = function () {
        return this._name;
    };
    AnimalCard.prototype.getAnimalValue = function () {
        return this.value;
    };
    Object.defineProperty(AnimalCard.prototype, "value", {
        get: function () {
            return this._value;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(AnimalCard.prototype, "name", {
        get: function () {
            return this._name;
        },
        enumerable: true,
        configurable: true
    });
    Object.defineProperty(AnimalCard.prototype, "dutchNameWithPrefix", {
        get: function () {
            return this._prefix + " " + this._nameTranslations[0];
        },
        enumerable: true,
        configurable: true
    });
    return AnimalCard;
})();
exports.AnimalCard = AnimalCard;

var CardManager = (function () {
    function CardManager() {
        this.animalNames = ["cat", "chicken", "cow", "dog", "donkey", "duck", "goat", "horse", "pig", "sheep"];
        this.animalPrefixes = ["de", "de", "de", "de", "de", "de", "de", "het", "het", "het"];
        this.animalNamesTranslations = [["kat"], ["kip"], ["koe"], ["hond"], ["ezel"], ["gans"], ["geit"], ["paard"], ["varken"], ["schaap"]];
        this.animalValues = [90, 10, 800, 160, 500, 40, 350, 1000, 650, 250];
        //empty construct
    }
    CardManager.prototype.getStartingMoneyCards = function () {
        var startingCards = [];

        // two 0, four 10, one 50
        startingCards.push(new MoneyCard(0));
        startingCards.push(new MoneyCard(0));

        startingCards.push(new MoneyCard(10));
        startingCards.push(new MoneyCard(10));
        startingCards.push(new MoneyCard(10));
        startingCards.push(new MoneyCard(10));

        startingCards.push(new MoneyCard(50));

        return startingCards;
    };

    CardManager.prototype.getAnimalDeck = function () {
        var animalDeck = [];
        for (var index in this.animalNames) {
            for (var x = 0; x < 4; x++) {
                animalDeck.push(new AnimalCard(this.animalNames[index], this.animalValues[index], this.animalNamesTranslations[index], this.animalPrefixes[index]));
            }
        }

        animalDeck.sort(this.randomSort);

        return animalDeck;
    };

    CardManager.prototype.randomSort = function (a, b) {
        if (Math.random() < 0.5)
            return -1;
        else
            return 1;
    };

    CardManager.haveAnimalWithValue = function (value, animalCards) {
        for (var x in animalCards) {
            var animalCard = animalCards[x];
            if (animalCard.value == value) {
                return true;
            }
        }
        return false;
    };
    CardManager.checkAmountForName = function (name, cards) {
        var amount = 0;
        for (var i in cards) {
            if (cards[i].getAnimalName() == name) {
                amount++;
            }
        }
        return amount;
    };

    CardManager.checkAmountForValue = function (value, moneyCards) {
        var amount = 0;
        for (var i in moneyCards) {
            if (moneyCards[i].getValue == value) {
                amount++;
            }
        }
        return amount;
    };
    CardManager.checkAnimalAmountForValue = function (value, animalCards) {
        var amount = 0;
        for (var i in animalCards) {
            if (animalCards[i].value == value) {
                amount++;
            }
        }
        return amount;
    };
    CardManager.getIndexOfMoneyCardForValue = function (value, moneyCards) {
        for (var x in moneyCards) {
            var moneyCard = moneyCards[x];
            if (moneyCard.getValue == value) {
                return parseInt(x);
            }
        }
        return -1;
    };
    CardManager.checkAmountOfDifferentAnimals = function (animalArray) {
        var count = 0;
        var countedAnimalsArray = [];
        for (var x in animalArray) {
            if (countedAnimalsArray.indexOf(animalArray[x].name) == -1) {
                countedAnimalsArray.push(animalArray[x].name);
                count++;
            }
        }
        return count;
    };
    CardManager.checkAmountOfDifferentMoneyCards = function (moneyCards) {
        var count = 0;
        var countedMoneyValues = [];
        for (var x in moneyCards) {
            if (countedMoneyValues.indexOf(moneyCards[x].getValue) == -1) {
                countedMoneyValues.push(moneyCards[x].getValue);
                count++;
            }
        }
        return count;
    };

    CardManager.getAnimalByName = function (animalName, animalCards) {
        for (var x in animalCards) {
            var animal = animalCards[x];
            if (animal.getAnimalName() == animalName) {
                return animal;
            }
        }
        return null;
    };

    CardManager.getMoneyCardByName = function (moneyCardValue, moneyCards) {
        for (var x in moneyCards) {
            var moneyCard = moneyCards[x];
            if (moneyCard.getValue == parseInt(moneyCardValue)) {
                return moneyCard;
            }
        }
        return null;
    };

    CardManager.getTotalForMoneyCards = function (moneyCards) {
        var amount = 0;
        for (var i in moneyCards) {
            amount += moneyCards[i].getValue;
        }
        return amount;
    };

    CardManager.checkAnimalAmountForName = function (name, animalCards) {
        var amount = 0;
        for (var i in animalCards) {
            if (animalCards[i].name == name) {
                amount++;
            }
        }
        return amount;
    };

    CardManager.doubleTradePossible = function (animalName, animalCards, animalCards2) {
        var amountPlayer1;
        for (var x in animalCards) {
            var animalCard = animalCards[x];
            if (animalCard.name == animalName) {
                amountPlayer1++;
            }
        }
        var amountPlayer2;
        for (var y in animalCards2) {
            var animalCard2 = animalCards2[y];
            if (animalCard2.name == animalName) {
                amountPlayer2++;
            }
        }
        console.log('here is all good');

        if (amountPlayer1 == 2 && amountPlayer2 == 2) {
            return true;
        }
        return false;
    };
    return CardManager;
})();
exports.CardManager = CardManager;
//# sourceMappingURL=Model.js.map
