package j2024;

import j2024.TalkingRun.TalkState;
import bootstrap.Data.IntCapValue;
import bootstrap.Data.IntValue;
import bootstrap.DescWrap;
import bootstrap.SceneManager;
import ec.Component;
import hxmath.math.MathUtil;
import j2024.Spells;
import loops.talk.TalkData;
import stset.Stats;

class J24Model {
    public var spells:Array<Spell> = [];
    public var counts:Map<Suit, Int>;
    public var spell:Spell;
    public var cst:Array<Card>;
    public var caster:Actor;
    public var target:Actor;
    public var logger:HintLogger;
    public var matchedCases:Map<String, Bool>;
    public var curBattle:BattleDesc;
    public var battleDoneFlag:Bool = false;
    public var lastWitchHealth:Int;

    public var allSpells:Array<String> = [];
    public var learnedSpells:Array<String> = [];
    public var multiplier:Int;

    public function new() {
        addSpell(new FireSpell());
        addSpell(new PineSpell());
        addSpell(new RainSpell());
        addSpell(new PainSpell());
        addSpell(new PairSpell());
        addSpell(new FineSpell());
        caster = new Actor();
        target = new Actor();
    }

    function addSpell(s:Spell) {
        spells.push(s);
        allSpells.push(s.word);
    }

    public function init() {
        caster.getStat(hlt).init(20);
        target.getStat(hlt).init(20);
        learnedSpells = ["fire"];
    }

    public function getUnlearnedSpell() {
        for (s in allSpells)
            if (!learnedSpells.contains(s))
                return s;
        return null;
    }

    public function resetCtx() {
        spell = null;
        multiplier = 1;
        matchedCases = new Map();
        counts = new Map();
        for (s in AbstractEnumTools.getValues(Suit))
            counts[s] = 0;
        cst = [];
        battleDoneFlag = false;
    }

    public function apply(spell:Spell, cst:Array<Card>) {
        this.spell = spell;
        this.cst = cst;

        logger.addHint('Casting ${spell.word} <br/>');
        if (!learnedSpells.contains(spell.word))
            learnedSpells.push(spell.word);
        for (c in cst)
            counts[c.suit]++;
        for (c in spell.cases) {
            if (!c.matches(this))
                continue;
            c.apply(this);
            if (!matchedCases.exists(c.id)) {
                matchedCases.set(c.id, true);
                logger.addHint(c.descr);
            }
        }
        for (s in AbstractEnumTools.getValues(Suit))
            counts[s] = 0;
    }

    public function hitTarget(dmg:Int, ?type:String) {
        var rdmg = dmg * multiplier;
        target.hlt -= rdmg;
        logger.addHint('$rdmg damage dealt');
    }

    public function hitCaster(dmg:Int, ?type:String) {
        var rdmg = dmg * multiplier;
        caster.hlt -= rdmg;
        logger.addHint('$rdmg damage dealt');
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
    public var modifier:Bool = false;

    function addCase(caze:Case) {
        caze.id = word + cases.length;
        cases.push(caze);
    }
}

typedef Case = {
    descr:String,
    ?id:String,
    matches:(cst:J24Model) -> Bool,
    apply:(ctx:J24Model) -> Void,
}

enum abstract SpellcrStat(String) to String from String {
    var hlt;
}

class SpellcrStats extends Stats<SpellcrStat, IntCapValue> {}
typedef Actor = SpellcrStats;

typedef BattleDesc = {
    deck:Array<Rune>,
    suits:Array<Suit>,
    checker:String,
    ?last:Bool
}

class BattleData extends DescWrap<BattleDesc> {}

enum ActivityDesc {
    Talk(talk:DialogDesc);
    Battle(b:BattleDesc);
}

@:keep
class ExecCtx extends Component {
    @:once var defs:MrunesDefs;
    @:once var model:J24Model;
    @:once var logger:HintLogger;
    @:once var scenes:SceneManager<ActivityDesc>;
    @:once var talking:TalkState;

    var ctx:ExecCtx;

    @:isVar public var vars(get, null):Dynamic = {};

    override function init() {
        Reflect.setField(vars, "ctx", this);
        ctx = this;
    }

    public function changeStat(statId, delta:Int) {
        trace("change " + statId + " " + delta + " " + this);
    }

    public function talk(id:String) {
        trace("addAct " + id);
        var ct = scenes.currentTalk;
        if (ct != null) {
            for (dd in ct)
                if (dd.id == id) {
                    scenes.pushScene(Talk(dd));
                    return;
                }
        } else
            throw "Wrong";
    }

    public function chapter(i:Int) {
        // trace("chap ", i);
        talking.startChap(i);
    }

    public function log(s:String) {
        logger.addHint(s);
    }

    public function casted(id:String) {
        return model.matchedCases.exists(id);
    }

    public function battle(id) {
        var btl = defs.battles.get(id);
        scenes.pushScene(Battle(btl));
    }

    function get_vars():Dynamic {
        if (!_inited)
            throw "wrong";
        return vars;
    }
}
