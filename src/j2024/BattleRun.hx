package j2024;

import al.Builder;
import j2024.J24Gui;
import ec.Entity;
import bootstrap.SequenceRun;

class BattleRun extends SequenceRun {
    public function new(ctx, w, vtarg) {
        super(ctx, w, vtarg);
        addActivity(new CastingRun(new Entity("casting-run"), new CastingGuiImpl(Builder.widget())));
        addActivity(new AntoRun(new Entity("anti-run"), new AntoGui(Builder.widget())));
    }
}
