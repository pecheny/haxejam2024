package j2024;

import hxmath.math.MathUtil;
import j2024.J24Model;
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