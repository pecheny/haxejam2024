package;

import j2024.J24Model;
import j2024.AntoRun;
import j2024.J24Gui;
import ginp.GameButtons.GameButtonsImpl;
import j2024.CastingRun;
import al.al2d.Placeholder2D;
import al.ec.WidgetSwitcher;
import al.layouts.PortionLayout;
import bootstrap.BootstrapMain;
import bootstrap.OneButtonActivity;
import bootstrap.SelfClosingScreen;
import bootstrap.SequenceRun;
import ec.CtxWatcher;
import ec.Entity;
import ec.Signal;
import fancy.domkit.Dkit;
import gameapi.GameRun;
import gameapi.GameRunBinder;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

class GamecycleDemo extends BootstrapMain {
    public function new() {
        super();

        var ph = Builder.widget();
        fui.makeClickInput(ph);

        var e = new Entity("run");
        var m = new J24Model();
        m.init();
        e.addComponent(m);
        var sw = new WidgetSwitcher(ph);
        var run = new SequenceRun(e, sw.widget(), sw);
        run.addActivity(new CastingRun(new Entity("casting-run"), new CastingGuiImpl(Builder.widget())));
        run.addActivity(new AntoRun(new Entity("anti-run"), new AntoGui(Builder.widget())));
        run.entity.addComponentByType(GameRun, run);
        new CtxWatcher(GameRunBinder, run.entity);
        rootEntity.addChild(run.entity);
    }
}

class WelcomeWidget extends BaseDkit implements SelfClosingScreen {
    public var onDone:Signal<Void->Void> = new Signal();

    static var SRC = <welcome-widget vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b()) id="lbl"  text={ "Lets play!1" }  >
        </label>
        <button(b().v(pfr, .1).b())   text={ "Go!1" } onClick={onOkClick}  />
    </welcome-widget>

    function onOkClick() {
        onDone.dispatch();
    }
}

class GameoverWidget extends BaseDkit implements SelfClosingScreen {
    public var onDone:Signal<Void->Void> = new Signal();

    static var SRC = <gameover-widget vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b()) id="lbl"  text={ "Game Over" }  >
        </label>
        <button(b().v(pfr, .1).b())   text={ "again" } onClick={onOkClick}  />
    </gameover-widget>

    function onOkClick() {
        onDone.dispatch();
    }
}
