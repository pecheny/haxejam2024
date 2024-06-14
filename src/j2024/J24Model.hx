package j2024;

import bootstrap.Data.IntCapValue;
import hxmath.math.MathUtil;
import bootstrap.Data.IntValue;
import stset.Stats;

class J24Model {
    public var spells:Array<Spell> = [];
    public var counts:Map<Suit, Int>;
    public var spell:Spell;
    public var cst:Array<Card>;
    public var caster:Actor;
    public var target:Actor;
    public var logger:HintLogger;

    public function new() {
        spells.push(new FireSpell());
        caster = new Actor();
        target = new Actor();
    }

    public function init() {
        caster.getStat(hlt).init(20);
        target.getStat(hlt).init(20);
        // caster.initAll({
        //     hlt: 20
        // });
        // target.initAll({
        //     hlt: 20
        // });
    }

    public function startGame() {
        
    }

    public function resetCtx() {
        spell = null;
        counts = new Map();
        for (s in AbstractEnumTools.getValues(Suit))
            counts[s] = 0;
        cst = [];
    }

    public function apply(spell:Spell, cst:Array<Card>) {
        this.spell = spell;
        this.cst = cst;
        for (c in cst)
            counts[c.suit]++;
        for (c in spell.cases) {
            if(!c.matches(this))
                continue;
            c.apply(this);
            logger.addHint(c.descr);
        }
    }
}

enum abstract Rune(String) to String {
    var r = "r";
    var i = "i";
    var a = "a";
    var f = "f";
    var n = "n";
    var p = "p";
    var e = "e";
}

enum abstract Suit(String) to String {
    var fire = "ў";
    var water = "ӯ";
    var wood = "Ó";
}

class Card {
    public var suit(default, null):Suit;
    public var rune(default, null):Rune;

    public function new(s, r) {
        this.suit = s;
        this.rune = r;
    }
}

class Spell {
    public var word(default, null):String;
    public var cases(default, null):Array<Case> = [];
}

// class Cast {
//     public var cards:Array<Card> = [];
// }

typedef Case = {
    public var descr:String;

    public function matches(cst:SpellCtx):Bool;
    public function apply(ctx:SpellCtx):Void;
}

enum abstract SpellcrStat(String) to String from String {
    var hlt;
}

class SpellcrStats extends Stats<SpellcrStat, IntCapValue> {}
typedef Actor = SpellcrStats;

typedef SpellCtx = {
    var caster:Actor;
    var target:Actor;
    var cst:Array<Card>;
    var spell:Spell;
    var counts:Map<Suit, Int>;
}

class FireSpell extends Spell {
    var dmg = 1;

    public function new() {
        word = "fire";
        cases.push({
            matches: ctx -> ctx.counts[fire] > 0,
            apply: ctx -> ctx.target.hlt -= ctx.counts[fire] * dmg,
            descr: 'Fire spell deals $dmg damege per $fire rune used.'
        });
        cases.push({
            matches: ctx -> ctx.counts[fire] > 0 && ctx.counts[water] > 0,
            apply: ctx -> {
                var pairs:Int = MathUtil.intMin(ctx.counts[fire], ctx.counts[water]);
                ctx.caster.hlt -= pairs * dmg;
            },
            descr: 'Each $water rune used along with $fire rune dameges caster $dmg by steam.'
        });
    }
}
