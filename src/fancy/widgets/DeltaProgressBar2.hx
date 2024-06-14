package fancy.widgets;

import update.UpdateBinder;
import ec.CtxWatcher;
import widgets.CMSDFLabel;
import update.Updatable;
import fancy.widgets.ProgressBarWidget;
import widgets.Widget;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

class DeltaProgressBar2 extends Widget implements Updatable {
    var healthRed:ProgressBarWidget;
    var healthbar:ProgressBarWidget;
    var value:Float = 0;
    var max:Float = 1;
    @:once var fui:FuiBuilder;
    var lbl:CMSDFLabel;

    public function new(w) {
        super(w);
        new ProgressBarWidget(w, 0x000000);
        healthRed = new ProgressBarWidget(w, 0xff0000);
        healthbar = new ProgressBarWidget(w);
        w.entity.addComponentByType(Updatable, this);
        new CtxWatcher(UpdateBinder, w.entity);
    }

    override function init() {
        lbl = new CMSDFLabel(ph, fui.textStyles.defaultStyle());
        lbl.setColor(0);
        lbl?.withText('$value/$max');
    }

    public function hideDelta() {
        healthRed.setPtogress(value/max);
        healthbar.setPtogress(value/max);
    }

    var t = 0.;
    public function setValue(v:Float, max:Float = 1) {
        value = v;
        this.max = max;
        lbl?.withText('$value/$max');
        healthbar.setPtogress(v / max);
        t=1;
    }
	public function update(dt:Float) {
        if (t <=0)
            return;
        t-=dt;
        if (t <=0)
            hideDelta();
    }
}
