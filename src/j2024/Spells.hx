package j2024;

import hxmath.math.MathUtil;
import j2024.J24Model;
class FireSpell extends Spell {
    var dmg = 1;

    public function new() {
        word = "fire";
        cases.push({
            matches: ctx -> ctx.counts[fire] > 0,
            apply: ctx -> ctx.hitTarget(ctx.counts[fire] * dmg),
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

class PineSpell extends Spell {
    var dmg = 1;

    public function new() {
        word = "pine";
        cases.push({
            matches: ctx -> ctx.counts[wood] > 0,
            apply: ctx -> ctx.hitTarget(ctx.counts[wood] * dmg),
            descr: 'Pine spell deals $dmg damege per $wood rune used.'
        });
        cases.push({
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
        cases.push({
            matches: ctx -> ctx.counts[water] > 0,
            apply: ctx -> ctx.hitTarget(ctx.counts[water] * dmg),
            descr: 'Rain spell deals $dmg damege per $water rune used.'
        });
        // cases.push({
        //     matches: ctx -> ctx.counts[fire] > 0 && ctx.counts[fire] > 0,
        //     apply: ctx -> {
        //         var pairs:Int = MathUtil.intMin(ctx.counts[fire], ctx.counts[fire]);
        //         ctx.caster.hlt -= pairs * dmg;
        //     },
        //     descr: 'Each $fire rune used along with $wood rune dameges target $dmg as a torch.'
        // });
    }
}