package j2024;

import al.Builder;
import al.al2d.Widget2DContainer;
import al.al2d.Widget;
import widgets.Label;
import loops.talk.TalkData.DialogDesc;
import loops.talk.TalkingActivity.ITalkingWidget;
import al.al2d.Placeholder2D;
import al.ec.WidgetSwitcher;
import fancy.widgets.DeltaProgressBar2;
import widgets.ColouredQuad.InteractiveColors;
import gl.sets.ColorSet;
import widgets.ButtonBase.ClickViewProcessor;
import graphics.ShapesColorAssigner;
import al.al2d.ChildrenPool.DataChildrenPool;
import al.al2d.ChildrenPool.DataView;
import al.layouts.PortionLayout;
import ec.Signal;
import fancy.InteractivePanelBuilder;
import fancy.domkit.Dkit;
import j2024.CastingRun;
import j2024.J24Model;
import utils.Signal.IntSignal;

class CardView extends BaseDkit implements DataView<Card> {
    public var onDone:Signal<Void->Void> = new Signal();

    @:once var colors:ShapesColorAssigner<ColorSet>;
    @:once var viewProc:ClickViewProcessor;

    static var SRC = <card-view vl={PortionLayout.instance}>
        ${fui.quad(__this__.ph, 0x000000)}
        <label(b().v(pfr, 4).b()) id="suit"  style={"rune"}  />
        <label(b().v(pfr, 6).b()) id="rune"  style={"rune"}  />
    </card-view>

    override function init() {
        super.init();
        if (ibg)
            interactiveBg();
    }

    var ibg = false;

    public function interactiveBg() {
        if (viewProc == null)
            ibg = true;
        else
            viewProc.addHandler(new InteractiveColors(colors.setColor).viewHandler);
    }

    public function staticBg(c:Int) {
        colors.setColor(c);
    }

    public function initData(descr:Card) {
        if (descr == null) {
            suit.text = "_";
            rune.text = "_";
            suit.color = 0xffffff;
            return;
        }
        suit.text = descr.suit;
        rune.text = descr.rune;
        suit.color = switch descr.suit {
            case fire: 0xff0000;
            case water: 0x00a0ff;
            case wood: 0x00ff90;
        }
    }
}

@:uiComp("spell")
class SpellView implements ISpellView extends BaseDkit {
    static var SRC = <spell vl={PortionLayout.instance}>
    <label(b().v(pfr, .3).b()) id="lbl"  color={ 0xecb7b7 } text={ "" }  />
    <base(b().v(pfr, 1).b()) id="cardsContainer" layouts={GuiStyles.L_HOR_CARDS}  />
</spell>;

    public var onChoice(default, null) = new IntSignal();

    public function setAt(n:Int, state:Null<Card>) {
        input?.pool[n].initData(state);
    }

    var input:DataChildrenPool<Card, CardView>;

    override function init() {
        super.init();
        input = new InteractivePanelBuilder().withContainer(cardsContainer.c)
            .withWidget(() -> {
                var c = new CardView(b().h(sfr, 0.1).v(sfr, 0.1).b());
                c.staticBg(0x493C29);
                c;
            }) // .withInput((_, _) -> {})
            .withSignal(onChoice)
            .build();

        input.initData([null, null, null, null, null, null, null, null]);
    }
}

@:uiComp("cards")
class CardsView implements CardPicker extends BaseDkit {
    public var onChoice(default, null) = new IntSignal();

    var input:DataChildrenPool<Card, CardView>;

    static var SRC = <cards>
        <base(b().h(pfr, 1).v(pfr, 1).b()) id="cardsContainer" layouts={"cards"}  />
    </cards>;

    override function init() {
        super.init();
        input = new InteractivePanelBuilder().withContainer(cardsContainer.c)
            .withWidget(() -> {
                var c = new CardView(b().h(pfr, 0.1).v(sfr, 0.1).b());
                c.interactiveBg();
                c;
            })
            .withSignal(onChoice)
            .build();

        onChoice.listen(n -> input.pool[n].initData(null));
    }

    public function initData(descr:Array<Card>) {
        input?.initData(descr);
    }
}

class CastingGuiImpl extends BaseDkit implements CastingGui {
    static var SRC = <casting-gui-impl vl={PortionLayout.instance}>
        <spell(b().v(pfr, .3).b()) public id="spell"     />
        <cards(b().v(pfr, 1).b()) public id="cards"   />
    </casting-gui-impl>;
}

@:uiComp("witch")
class WitchView extends BaseDkit {
    public var health:DeltaProgressBar2;

    static var SRC = <witch vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b())  text={ "The Witch" }  />
        <base(b().v(pfr, 1).b()) id="portrait"   />
        <base(b().v(sfr, .02).l().b())   >
        ${ health = new DeltaProgressBar2(__this__.ph)}
        </base>
    </witch>;
}

@:uiComp("seeker")
class SeekerView extends BaseDkit {
    public var health:DeltaProgressBar2;

    static var SRC = <seeker vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b())  text={ "The Seeker" }  />
        <base(b().v(sfr, .02).l().b())   >
        ${ health = new DeltaProgressBar2(__this__.ph)}
        </base>
    </seeker>;
}

@:uiComp("switcher")
class SwitcherView extends BaseDkit {
    public var switcher:WidgetSwitcher<Axis2D>;

    public function new(p:Placeholder2D, ?parent:BaseDkit) {
        super(p, parent);
        initComponent();
        // fui.quad(p,0xff0000);
        switcher = new WidgetSwitcher(p);
    }
}

class AntoGui extends BaseDkit {
    public var onDone:Signal<Void->Void> = new Signal();

    static var SRC = <anto-gui vl={PortionLayout.instance}>
        <base(b().v(pfr, .1).b()) />
        <button(b().v(pfr, .1).b()) id="button"   text={ "again" } onClick={onOkClick}  />
        <base(b().v(pfr, .1).b()) />
    </anto-gui>

    public function setCaption(s:String) {
        button.text = s;
    }

    function onOkClick() {
        onDone.dispatch();
    }
}

class MrunesScreen extends BaseDkit {
    static var SRC = <mrunes-screen vl={PortionLayout.instance}>
        <base(b().v(pfr, .4).b()) hl={PortionLayout.instance}>
            <witch(b().h(pfr,1).b()) public id="witch"/>
            <label(b().h(pfr,3).b()) public id="witchLabel" text={"– Hi there"} style={"logger"}/>
        </base>
        <switcher(b().v(pfr, .3).b()) public id="switcher">
        // ${fui.quad(__this__.ph, 0x000000)}
        </switcher>
        <seeker(b().v(pfr, .1).b()) public id="seeker"  />
    </mrunes-screen>
}

class TalkingGui implements ITalkingWidget extends BaseDkit {
    // var caption:Label;
    var logger:HintLogger;
    var container:Widget2DContainer;
    var input:DataChildrenPool<String, ResponceButton>;
    var data:DialogDesc;

    public var onChoise(default, null):IntSignal = new IntSignal();

    public function new(ph:Placeholder2D, l:HintLogger, ?parent:BaseDkit) {
        super(ph, parent);
        this.logger = l;
        container = Builder.createContainer(ph, vertical, Center);
        init();
        initComponent();
        // this.caption = capts;
    }

    public function initDescr(d:DialogDesc) {
        // caption.withText(d.caption);
        data = d;
        logger.addHint(d.caption);
        input.initData(d.responces.map(r -> r.caption));
    }

    override function init() {
        if (_inited)
            return;
        super.init();
        input = new InteractivePanelBuilder().withContainer(container).withWidget(() -> {
            var c = new ResponceButton(b().h(pfr, 0.1).v(sfr, 0.1).b());
            c;
        }).withSignal(onChoise).build();

        onChoise.listen(n -> logger.addHint(data.responces[n].caption));
    }
}

class ResponceButton extends BaseDkit implements DataView<String> {
    public var onDone:Signal<Void->Void> = new Signal();

    @:once var colors:ShapesColorAssigner<ColorSet>;
    @:once var viewProc:ClickViewProcessor;

    static var SRC = <responce-button vl={PortionLayout.instance}>
        ${fui.quad(__this__.ph, 0x000000)}
        <label(b().v(pfr, 6).b()) id="rune"  style={"small-text"}  />
    </responce-button>

    override function init() {
        super.init();
        viewProc.addHandler(new InteractiveColors(colors.setColor).viewHandler);
    }

    public function initData(descr:String) {
        rune.text = descr;
    }
}
