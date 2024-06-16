package j2024;

import al.al2d.Placeholder2D;
import utils.Signal.IntSignal;
import utils.Random;
import ec.Signal;
import j2024.J24Model;
import j2024.J24Gui;
import al.al2d.ChildrenPool.DataView;
import bootstrap.GameRunBase;

class CastingRun extends GameRunBase {
    var gui:CastingGui;
    @:once var model:J24Model;
    @:once var logger:HintLogger;

    var cards:Array<Card>;
    var word:Array<Card> = [];
    var numPicks:Int;
    var wasted:Array<Int> = [];

    public function new(ctx, gui) {
        this.gui = gui;
        gui.cards.onChoice.listen(onPick);
        super(ctx, gui.ph);
    }

    override function startGame() {
        model.resetCtx();
        word.resize(0);
        wasted.resize(0);
        numPicks = 0;
        for (i in 0...8)
            gui.spell.setAt(i, null);
        cards = getCards();
        gui.cards.initData(cards);
    }

    function onPick(n:Int) {
        if (wasted.contains(n))
            return;
        var card = cards[n];
        wasted.push(n);
        word.push(card);
        gui.spell.setAt(numPicks, card);
        numPicks++;
        checkWord();
    }

    function castSpell(spell:Spell) {
        model.apply(spell, word);
        gameOvered.dispatch();
    }

    function checkWord() {
        var fail = true;
        var spell:Spell = null;
        var input = word.map(c -> c.rune).join("");
        for (s in model.spells) {
            if (s.word == input) {
                spell = s;
                fail = false;
                break;
            } else if (s.word.indexOf(input) == 0)
                fail = false;
        }
        if (spell != null)
            castSpell(spell);
        if (fail) {
            gameOvered.dispatch();
            logger.addHint("Ha! Not a spell!");
        }
    }

    function getCards() {
        var suits = model.curBattle.suits;
        return [for (r in model.curBattle.deck) new Card(Random.fromArray(suits), r)];
    }

    function getCard() {
        // [for (i in 0...16) getCard()]
        // get deck from ctx
        var runes = AbstractEnumTools.getValues(Rune);
        var suits = AbstractEnumTools.getValues(Suit);
        return new Card(Random.fromArray(suits), Random.fromArray(runes));
    }
}

interface CastingGui {
    var cards:CardsView;
    var spell:SpellView;
    public var ph(get, null):Placeholder2D;
}

interface ISpellView {
    function setAt(n:Int, state:Null<Card>):Void;
}

interface CardPicker extends DataView<Array<Card>> {
    public var onChoice(default, null):IntSignal;
}
