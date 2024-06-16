package j2024;

import fancy.domkit.Dkit.LabelDkit;
import hxmath.math.MathUtil;
import widgets.Label;

class HintLogger {
    var label:LabelDkit;
    var hints:Array<String>;

    public function new(l) {
        this.label = l;
    }

    public function reset() {
        hints = [];
    }

    public function addHint(h:String) {
        hints.push(h);
        var numHints = 7;

        var start = MathUtil.intMax(0, hints.length - numHints);
        var r = "";
        for (i in start...hints.length)
            r += "– " + hints[i] + "<br/>";
        label.text = r;
    }
}
