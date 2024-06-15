package j2024;

import al.Builder;
import al.al2d.Placeholder2D;
import al.ec.WidgetSwitcher;
import bootstrap.Activitor;
import bootstrap.Executor;
import bootstrap.GameRunBase;
import bootstrap.SceneManager;
import ec.Entity;
import gameapi.GameRun;
import j2024.J24Gui.MrunesScreen;
import j2024.J24Model;
import j2024.MrunesDefs;
import loops.talk.TalkData;
import loops.talk.TalkingActivity;

class TalkingRun extends GameRunBase {
    @:once var defs:MrunesDefs;
    @:once var scenes:SceneManager<ActivityDesc>;
    @:once var acts:Activitor;
    @:once var fui:FuiBuilder;
    var logger:HintLogger;

     var model:J24Model;
    var gui:MrunesScreen;
    var act:GameRun;
    var switcher:WidgetSwitcher<Axis2D>;
    var talkingState:TalkState;

    public function new(ctx:Entity, w:Placeholder2D) {
        entity = ctx;
        gui = new MrunesScreen(w);
        defs = new MrunesDefs();
        model = new J24Model();
        logger = new HintLogger(gui.witchLabel);
        model.logger = logger;
        entity.addComponent(logger);
        entity.addComponent(model);
        entity.addComponent(defs);
        ctx.addComponent(gui);

        switcher = gui.switcher.switcher;
        scenes = ctx.addComponent(new SceneManager<ActivityDesc>());
        ctx.addComponent(new Actor());
        acts = new Activitor(ctx);
        // switcher = new WidgetSwitcher(w);
        super(ctx, w);
    }

    var inited = false;

    override function init() {
        talkingState = new TalkState(scenes, defs);
        entity.addComponent(talkingState);
        getView().entity.addComponent(fui.textStyles.getStyle("small-text"));
        var ctx = entity.addComponent(new ExecCtx(entity));
        entity.addComponent(new Executor(ctx.vars));
        var talking = addactivity(new TalkingActivity(new Entity("talk-run"), Builder.widget()));
        var battle = addactivity(new MrunesRun(new Entity("battle-run"), Builder.widget(), switcher));
        acts.regHandler(talking, DialogData);
        acts.regHandler(battle, BattleData);
        inited = true;
    }

    override function reset() {
        act?.reset();
        logger?.reset();
        talkingState?.reset();
    }

    function addactivity<T:GameRun>(act:T):T {
        act.reset();
        act.gameOvered.listen(onActEnd);
        entity.addChild(act.entity);
        return act;
    }

    function getNextDescr():ActivityDesc {
        var remains = entity.getComponent(SceneManager).pullScene();
        if (remains != null)
            return remains;
        return talkingState.getNextDialog();
    }

    override function startGame() {
        if (!inited)
            return;
        nextRoom();
    }

    function nextRoom() {
        this.act?.reset();
        var act = switch getNextDescr() {
            case Talk(b): acts.getHandler(DialogData).initDescr(b);
            case Battle(b): acts.getHandler(BattleData).initDescr(b);
        }
        switchAct(act);
    }

    function switchAct(act:GameRun) {
        this.act = act;
        switcher.switchTo(act.getView());
        act.startGame();
    }

    function onActEnd() {
        // if (player.getComponent(LiveStats).hlt <= 0)
        //     gameOvered.dispatch();
        // else {
        //     for (ch in checks) {
        //         if (ch.shouldActivate()) {
        //             switchAct(ch);
        //             return;
        //         }
        //     }
        //     nextRoom();
        // }
        nextRoom();
    }
}

class TalkState {
    var talkIds = ["chap-1", "chap-2"];
    var scenes:SceneManager<ActivityDesc>;
    var defs:MrunesDefs;
    var chapId:Int;
    var dialogId:Int;

    public function new(s, d) {
        this.scenes = s;
        this.defs = d;
    }

    public function reset() {
        startChap(0);
    }

    public function startChap(n:Int) {
        if (talkIds.length <= n)
            throw "no chap " + n;
        chapId = n;
        var tlkDsc = defs.dialogs.get(talkIds[chapId]);
        scenes.currentTalk = tlkDsc;
        dialogId = -1;
    }

    function hasChapters() {
        return chapId < talkIds.length - 1;
    }

    public function getNextDialog() {
        if (scenes.currentTalk.length < dialogId - 1) {
            if (hasChapters())
                startChap(chapId++)
            else
                startChap(0);
        }
        dialogId++;
        return Talk(scenes.currentTalk[dialogId]);
    }
}

typedef TalkId = String;


