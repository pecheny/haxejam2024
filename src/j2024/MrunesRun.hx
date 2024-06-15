package j2024;

import fancy.widgets.DeltaProgressBar2;
import bootstrap.Data.IntCapValue;
import al.Builder;
import ec.Entity;
import al.al2d.Placeholder2D;
import bootstrap.SequenceRun;
import bootstrap.GameRunBase;
import j2024.J24Gui;
import j2024.J24Model;
import bootstrap.Activitor;

class MrunesRun extends SequenceRun implements ActHandler<BattleDesc> {
    @:once var model:J24Model;
    @:once var gui:MrunesScreen;
    var battle:BattleRun;

    override function init() {

        bindBar(model.target.getStat(hlt), gui.witch.health);
        bindBar(model.caster.getStat(hlt), gui.seeker.health);

        entity.addComponent(model);
        battle = new BattleRun(new Entity("battle"), Builder.widget(), gui.switcher.switcher);
        addActivity(battle);
        reset();
    }

    function bindBar(stat:IntCapValue, dpb:DeltaProgressBar2) {
        stat.onChange.listen((v) -> {
            dpb.setValue(stat.getVal(), stat.max);
        });
    }

    public function initDescr(d:BattleDesc):ActHandler<BattleDesc> {
        trace("init btl");
        return this;
    }

    override function startGame() {
        super.startGame();
    }

    override function reset() {
        super?.reset();
        model?.init();
        model?.resetCtx();
    }
}
