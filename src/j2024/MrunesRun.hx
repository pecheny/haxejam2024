package j2024;

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

        ctx.addComponent(model);
        battle = new BattleRun(new Entity("battle"), Builder.widget(), gui.switcher.switcher);
        addActivity(battle);

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
