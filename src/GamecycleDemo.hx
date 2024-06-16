package;

import al.ec.WidgetSwitcher;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import al.layouts.data.LayoutData.FixedSize;
import bootstrap.BootstrapMain;
import bootstrap.OneButtonActivity;
import bootstrap.SelfClosingScreen;
import bootstrap.SequenceRun;
import ec.CtxWatcher;
import ec.Entity;
import ec.Signal;
import fancy.Layouts.ContainerStyler;
import fancy.domkit.Dkit.BaseDkit;
import gameapi.GameRun;
import gameapi.GameRunBinder;
import ginp.Keyboard;
import htext.style.TextContextBuilder.TextContextStorage;
import j2024.TalkingRun;

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

        var sw = new WidgetSwitcher(ph);
        var run = new SequenceRun(new Entity("root-seq"), sw.widget(), sw);
        run.addActivity(new OneButtonActivity(new Entity("wlc"), new WelcomeWidget(Builder.widget())));
        run.addActivity(new TalkingRun(new Entity("game"), Builder.widget()));
        run.entity.addComponentByType(GameRun, run);

        new CtxWatcher(GameRunBinder, run.entity);
        rootEntity.addChild(run.entity);

        kbinder.addCommand(Keyboard.R, () -> {
            run.reset();
            run.startGame();
        });
    }

    override function textStyles() {
        var font = "fonts/robo.fnt";
        fui.addBmFont("", font); // todo
        fui.textStyles.newStyle("center").withAlign(horizontal, Center).build();
        var fitStyle = fui.textStyles.newStyle("fit")
            .withSize(pfr, .5)
            .withAlign(horizontal, Forward)
            .withAlign(vertical, Backward)
            .withPadding(horizontal, pfr, 0.33)
            .withPadding(vertical, pfr, 0.33)
            .build();
        rootEntity.addComponent(fitStyle);
        fui.textStyles.resetToDefaults();
        rootEntity.addComponentByType(TextContextStorage, fui.textStyles);
        fui.textStyles.newStyle("rune")
            .withSize(pfr, .7)
            .withAlign(horizontal, Center)
            .withAlign(vertical, Center) // .withPadding(horizontal, pfr, 0.33)
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
        var contLayouts = rootEntity.getComponent(ContainerStyler);
        contLayouts.reg("cards", distributer, WholefillLayout.instance);
    }
}

class WelcomeWidget extends BaseDkit implements SelfClosingScreen {
    public var onDone:Signal<Void->Void> = new Signal();

    static var SRC = <welcome-widget vl={PortionLayout.instance}>
    <base(b().v(pfr, .2).b()) />
    <base(b().b()) hl={PortionLayout.instance}>

        <label(b().v(sfr, .2).b()) id="lbl" style={"fit"} text={ "Mysterious Runes" }  />
        <base(b().v(pfr, 1).l().b()) id="portrait"   >
            ${fui.texturedQuad(__this__.ph, "witch-colored.png")}
        </base>
    </base>
    <button(b().v(sfr, .1).b())   text={ "Play" } onClick={onOkClick}  />
    <base(b().v(pfr, .2).b()) />
    </welcome-widget>

    function onOkClick() {
        onDone.dispatch();
    }
}
