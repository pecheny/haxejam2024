package j2024;

import hxmath.math.MathUtil;
import j2024.J24Model;
class FireSpell extends Spell {
    var dmg = 1;

    public function new() {
        word = "fire";
        addCase({
            matches: ctx -> true,
            apply: ctx -> {},
            descr: "You can put runes into the spell! It's interesting. Try to hurt me and if you so talented as it seems, I'll teach you more."
        });
        addCase({
            matches: ctx -> ctx.counts[fire] > 0,
            apply: ctx -> ctx.hitTarget(ctx.counts[fire] * dmg),
            descr: 'Fire spell deals $dmg damege per $fire rune used.'
        });
        addCase({
            matches: ctx -> ctx.counts[fire] > 0 && ctx.counts[water] > 0,
            apply: ctx -> {
                var pairs:Int = MathUtil.intMin(ctx.counts[fire], ctx.counts[water]);
                ctx.caster.hlt -= pairs * dmg;
            },
            descr: 'Each $water rune used along with $fire rune dameges caster $dmg by steam.'
        });
    }
}

class PineSpell extends Spell {
    var dmg = 2;

    public function new() {
        word = "pine";
        addCase({
            matches: ctx -> ctx.counts[wood] > 0,
            apply: ctx -> ctx.hitTarget(ctx.counts[wood] * dmg),
            descr: 'Pine spell deals $dmg damege per $wood rune used.'
        });
        addCase({
            matches: ctx -> ctx.counts[fire] > 0 && ctx.counts[wood] > 0,
            apply: ctx -> {
                var pairs:Int = MathUtil.intMin(ctx.counts[wood], ctx.counts[fire]);
                ctx.caster.hlt -= pairs * dmg;
            },
            descr: 'Each $fire rune used along with $wood rune dameges target $dmg as a torch.'
        });
    }
}

class RainSpell extends Spell {
    var dmg = 1;

    public function new() {
        word = "rain";
        addCase({
            matches: ctx -> ctx.counts[water] > 0,
            apply: ctx -> ctx.hitTarget(ctx.counts[water] * dmg),
            descr: 'Rain spell deals $dmg damege per $water rune used.'
        });
        // addCase({
        //     matches: ctx -> ctx.counts[fire] > 0 && ctx.counts[fire] > 0,
        //     apply: ctx -> {
        //         var pairs:Int = MathUtil.intMin(ctx.counts[fire], ctx.counts[fire]);
        //         ctx.caster.hlt -= pairs * dmg;
        //     },
        //     descr: 'Each $fire rune used along with $wood rune dameges target $dmg as a torch.'
        // });
    }
}

class PainSpell extends Spell {
    var dmg = 1;

    public function new() {
        word = "pain";
        addCase({
            matches: ctx -> true,
            apply: ctx -> ctx.hitTarget(ctx.counts[wood] * dmg),
            descr: 'Pain spell deals $dmg damege per any rune used.'
        });
    }
}
class PairSpell extends Spell {

    public function new() {
        word = "pair";
        modifier = true;
        addCase({
            matches: ctx -> true,
            apply: ctx -> ctx.multiplier = 2,
            descr: 'Pair spell multiplies the effect of following one by 2'
        });
    }
}

class FineSpell extends Spell {

    public function new() {
        word = "fine";
        modifier = true;
        addCase({
            matches: ctx -> true,
            apply: ctx -> ctx.multiplier = 3,
            descr: 'Fine spell multiplies the effect of following one by 3'
        });
    }
}