package j2024;

import bootstrap.Executor;
import j2024.J24Gui.AntoGui;
import al.layouts.PortionLayout;
import ec.Signal;
import fancy.domkit.Dkit.BaseDkit;
import ec.Entity;
import bootstrap.GameRunBase;

class AntoRun extends GameRunBase {
    @:once var model:J24Model;
    @:once var executor:Executor;

    public function new(ctx:Entity, gui:AntoGui) {
        super(ctx, gui.ph);
        gui.onDone.listen(() -> gameOvered.dispatch());
    }

    override function startGame() {
        super.startGame();
        var r = executor.run(model.curBattle.checker);
        trace("result ", r);
        if (r)
            gameOvered.dispatch();
    }
}
