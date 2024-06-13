package;

import widgets.CMSDFLabel;
import j2024.BattleRun;
import j2024.MrunesRun;
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
        var run = new MrunesRun(e, ph);
        run.entity.addComponentByType(GameRun, run);
        new CtxWatcher(GameRunBinder, run.entity);
        rootEntity.addChild(run.entity);
    }
}