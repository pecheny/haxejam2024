package j2024;

import al.layouts.PortionLayout;
import ec.Signal;
import fancy.domkit.Dkit.BaseDkit;
import ec.Entity;
import bootstrap.GameRunBase;

class AntoRun extends GameRunBase {
    @:once var model:J24Model;

    public function new(ctx:Entity, gui:AntoGui) {
        super(ctx, gui.ph);
        gui.onDone.listen(()->gameOvered.dispatch());

    }



}

class AntoGui extends BaseDkit {
    public var onDone:Signal<Void->Void> = new Signal();

    static var SRC = <anto-gui vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b()) id="lbl"  text={ "Nice turn" }  >
        </label>
        <button(b().v(pfr, .1).b())   text={ "again" } onClick={onOkClick}  />
    </anto-gui>

    function onOkClick() {
        onDone.dispatch();
    }
}
