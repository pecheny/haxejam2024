package j2024;

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
    var defs:MrunesDefs;
    var scenes:SceneManager<ActivityDesc>;
    var acts:Activitor;
    @:once var fui:FuiBuilder;
    var act:GameRun;
    var switcher:WidgetSwitcher<Axis2D>;

    override function init() {
        super.init();
        defs = new MrunesDefs();
        switcher = new WidgetSwitcher(getView());
        entity.addComponent(new Actor());
        getView().entity.addComponent(fui.textStyles.getStyle("small-text"));
        createCtx();
        nextRoom();
    }

    function createCtx() {
        scenes = entity.addComponent(new SceneManager<ActivityDesc>());
        var ctx = entity.addComponent(new ExecCtx(entity));
        entity.addComponent(new Executor(ctx.vars));
        var talking = addactivity(new TalkingActivity(new Entity("talk-run"), Builder.widget()));
        acts = new Activitor(entity);
        acts.regHandler(talking, DialogData);
    }

    function addactivity<T:GameRun>(act:T):T {
        act.gameOvered.listen(onActEnd);
        entity.addChild(act.entity);
        return act;
    }

    var talkIds = ["chap-1"];

    function getNextDescr():ActivityDesc {
        var remains = entity.getComponent(SceneManager).pullScene();
        if (remains != null)
            return remains;
        var talkId = talkIds[0];
        var tlkDsc = defs.dialogs.get(talkId);
        scenes.currentTalk = tlkDsc;
        return Talk(tlkDsc[0]);
    }

    function nextRoom() {
        trace("room");
        this.act?.reset();
        var act = switch getNextDescr() {
            case Talk(b): acts.getHandler(DialogData).initDescr(b);
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

    function get_vars():Dynamic {
        if (!_inited)
            throw "wrong";
        return vars;
    }
}
