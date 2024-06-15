package j2024;

import al.al2d.Placeholder2D;
import haxe.CallStack;
import al.ec.WidgetSwitcher;
import gameapi.GameRun;
import al.Builder;
import ec.Entity;
import loops.talk.TalkingActivity;
import bootstrap.Activitor;
import loops.talk.TalkData;
import bootstrap.Executor;
import bootstrap.SceneManager;
import ec.Component;
import j2024.J24Model;
import j2024.MrunesDefs;
import bootstrap.GameRunBase;

class TalkingRun extends GameRunBase {
    @:once var defs:MrunesDefs;
    @:once var scenes:SceneManager<ActivityDesc>;
    @:once var acts:Activitor;
    @:once var fui:FuiBuilder;
    var act:GameRun;
    var switcher:WidgetSwitcher<Axis2D>;
    var talkingState:TalkState;

    public function new(ctx:Entity, w:Placeholder2D) {
        defs = new MrunesDefs();
        scenes = ctx.addComponent(new SceneManager<ActivityDesc>());
        ctx.addComponent(new Actor());
        acts = new Activitor(ctx);
        switcher = new WidgetSwitcher(w);
        super(ctx, w);
    }

    var inited = false;
    
    override function init() {
        talkingState = new TalkState(scenes, defs);
        getView().entity.addComponent(fui.textStyles.getStyle("small-text"));
        var ctx = entity.addComponent(new ExecCtx(entity));
        entity.addComponent(new Executor(ctx.vars));
        var talking = addactivity(new TalkingActivity(new Entity("talk-run"), Builder.widget()));
        var battle = addactivity(new MrunesRun(new Entity("battle-run"), Builder.widget()));
        acts.regHandler(talking, DialogData);
        acts.regHandler(battle, BattleData);
        inited = true;
    }

    override function reset() {
        act?.reset();
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
    var talkIds = ["chap-1"];
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

@:keep
class ExecCtx extends Component {
    @:once var stats:Actor;
    @:once var scenes:SceneManager<ActivityDesc>;

    var ctx:ExecCtx;

    @:isVar public var vars(get, null):Dynamic = {};

    override function init() {
        for (k in stats.stats.keys())
            Reflect.setField(vars, k, k);
        Reflect.setField(vars, "ctx", this);
        ctx = this;
    }

    public function changeStat(statId, delta:Int) {
        trace("change " + statId + " " + delta + " " + this);
    }

    public function talk(id:String) {
        trace("addAct " + id);
        var ct = scenes.currentTalk;
        if (ct != null) {
            for (dd in ct)
                if (dd.id == id) {
                    scenes.pushScene(Talk(dd));
                    return;
                }
        } else
            throw "Wrong";
    }

    public function battle() {
        scenes.pushScene(Battle({}));
    }

    function get_vars():Dynamic {
        if (!_inited)
            throw "wrong";
        return vars;
    }
}
