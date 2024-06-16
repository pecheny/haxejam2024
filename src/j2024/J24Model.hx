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

    public function new() {
        spells.push(new FireSpell());
        spells.push(new PineSpell());
        spells.push(new RainSpell());
        caster = new Actor();
        target = new Actor();
    }

    public function init() {
        caster.getStat(hlt).init(20);
        target.getStat(hlt).init(20);
    }

    public function startGame() {}

    public function resetCtx() {
        spell = null;
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
    }

    public function hitTarget(dmg:Int, ?type:String) {
        target.hlt -= dmg;
        logger.addHint('$dmg damage dealt');
    }

    public function hitCaster(dmg:Int, ?type:String) {
        caster.hlt -= dmg;
        logger.addHint('$dmg damage dealt');
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

    function addCase(caze:Case) {
        caze.id = word + cases.length;
        cases.push(caze);
    }
}


typedef Case = {
    descr:String,
    ?id:String,
    matches:(cst:J24Model)->Bool,
    apply:(ctx:J24Model)->Void,
}

enum abstract SpellcrStat(String) to String from String {
    var hlt;
}

class SpellcrStats extends Stats<SpellcrStat, IntCapValue> {}
typedef Actor = SpellcrStats;


typedef BattleDesc = {
    deck:Array<Rune>,
    suits:Array<Suit>,
    checker:String
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
