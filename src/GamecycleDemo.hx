package;

import al.layouts.PortionLayout;
import al.layouts.data.LayoutData.FixedSize;
import al.layouts.WholefillLayout;
import fancy.Layouts.ContainerStyler;
import j2024.TalkingRun;
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
        stage.window.frameRate = 20;

        var ph = Builder.widget();
        fui.makeClickInput(ph);

        var e = new Entity("run");
        // var run = new MrunesRun(e, ph);
        var run = new TalkingRun(e, ph);
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
    override function dkitDefaultStyles() {
        super.dkitDefaultStyles();
        var pcStyle = fui.textStyles.newStyle("small-text")
        .withSize(sfr, .045)
        .withPadding(horizontal, sfr, 0.1)
        .withAlign(vertical, Center)
        .build();
        var pcStyle = fui.textStyles.newStyle("logger")
        .withAlign(vertical, Forward)
        .withPadding(vertical, sfr, 0.1)
        .build();
        fui.textStyles.resetToDefaults();

        var distributer = new al.layouts.Padding(new FixedSize(.07), new PortionLayout(Center, new FixedSize(0.07)));
        var contLayouts = rootEntity.getComponent (ContainerStyler);
        contLayouts.reg("cards", distributer, WholefillLayout.instance);
    }
}