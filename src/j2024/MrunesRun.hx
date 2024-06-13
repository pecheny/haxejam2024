package j2024;

import fancy.widgets.DeltaProgressBar2;
import bootstrap.Data.IntCapValue;
import al.Builder;
import ec.Entity;
import al.al2d.Placeholder2D;
import bootstrap.SequenceRun;
import bootstrap.GameRunBase;
import j2024.J24Gui;

class MrunesRun extends SequenceRun {
    var model:J24Model;
    var gui:MrunesScreen;
    var battle:BattleRun;

    public function new(ctx, ph:Placeholder2D) {
        gui = new MrunesScreen(ph);
        super(ctx, ph, gui.switcher.switcher);
        model = new J24Model();

        bindBar(model.target.getStat(hlt), gui.witch.health);
        bindBar(model.caster.getStat(hlt), gui.seeker.health);

        ctx.addComponent(model);
        battle = new BattleRun(new Entity("battle"), Builder.widget(), gui.switcher.switcher);
        addActivity(battle);
    }

    function bindBar(stat:IntCapValue, dpb:DeltaProgressBar2) {
        stat.onChange.listen((v) -> {
            dpb.setValue(stat.getVal(), stat.max);
        });
    }

    override function startGame() {
        super.startGame();
    }

    override function reset() {
        super.reset();
        model.init();
        model.resetCtx();
    }
}
