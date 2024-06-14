package;

import bootstrap.BootstrapMain;
import ec.CtxWatcher;
import ec.Entity;
import gameapi.GameRun;
import gameapi.GameRunBinder;
import ginp.Keyboard;
import j2024.MrunesRun;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

class GamecycleDemo extends BootstrapMain {
    var kbinder = new utils.KeyBinder();

    public function new() {
        super();

        var ph = Builder.widget();
        fui.makeClickInput(ph);

        var e = new Entity("run");
        var run = new MrunesRun(e, ph);
        run.entity.addComponentByType(GameRun, run);
        new CtxWatcher(GameRunBinder, run.entity);
        rootEntity.addChild(run.entity);
        kbinder.addCommand(Keyboard.R, ()-> {
            run.reset();
            run.startGame();

        });
    }
    override function textStyles() {
        super.textStyles();
        var fitStyle = fui.textStyles.newStyle("rune")
        .withSize(pfr, .7)
        .withAlign(horizontal, Center)
        .withAlign(vertical, Center)
        // .withPadding(horizontal, pfr, 0.33)
        // .withPadding(vertical, pfr, 0.33)
        .build();
        fui.textStyles.resetToDefaults();

    }
}