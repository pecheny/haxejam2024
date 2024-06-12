package j2024;

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
        <label(b().v(pfr, .2).b()) id="suit"  text={ "Lets play!1" }  />
        <label(b().v(pfr, 1.2).b()) id="rune"  text={ "Lets play!1" }  />
    </card-view>

    override function init() {
        super.init();
        viewProc.addHandler(new InteractiveColors(colors.setColor).viewHandler);
    }
    public function initData(descr:Card) {
        if (descr == null) {
            suit.text = "_";
            rune.text = "_";
            return;
        }
        suit.text = descr.suit;
        rune.text = descr.rune;
        suit.color = switch descr.suit {
            case fire: 0xff0000;
            case water: 0x00a0ff;
            case wood: 0x00ff90;
            case _: 0xffffff;
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
        input.pool[n].initData(state);
    }

    var input:DataChildrenPool<Card, CardView>;

    override function init() {
        super.init();
        input = new InteractivePanelBuilder().withContainer(cardsContainer.c)
            .withWidget(() -> new CardView(b().h(sfr, 0.1).v(sfr, 0.1).b()))
            // .withInput((_, _) -> {})
            .withSignal(onChoice)
            .build();

        // onChoice.listen(n -> trace(@:privateAccess input.pool[n].suit.text));
        input.initData([null,null,null,null, null,null,null,null]);
    }
}

@:uiComp("cards")
class CardsView implements CardPicker extends BaseDkit {
    public var onChoice(default, null) = new IntSignal();

    var input:DataChildrenPool<Card, CardView>;

    static var SRC = <cards vl={PortionLayout.instance}>
        <label(b().v(pfr, .3).b()) id="lbl"  color={ 0xecb7b7 } text={ "" }  />
        <base(b().v(pfr, 1).b()) id="cardsContainer" layouts={GuiStyles.L_HOR_CARDS}  />
    </cards>;

    override function init() {
        super.init();
        input = new InteractivePanelBuilder().withContainer(cardsContainer.c)
            .withWidget(() -> new CardView(b().h(sfr, 0.1).v(sfr, 0.1).b()))
            .withSignal(onChoice)
            .build();

        onChoice.listen(n -> input.pool[n].initData(null));
    }
    

    public function initData(descr:Array<Card>) {
        input.initData(descr);
    }
}

class CastingGuiImpl extends BaseDkit implements CastingGui {
    static var SRC = <casting-gui-impl vl={PortionLayout.instance}>
        <spell(b().v(pfr, .3).b()) public id="spell"     />
        <cards(b().v(pfr, 1).b()) public id="cards" layouts={GuiStyles.L_HOR_CARDS}  />
    </casting-gui-impl>;
}
