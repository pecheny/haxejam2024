package j2024;

import bootstrap.DefNode;
import ec.Entity;
import j2024.J24Model;
import loops.talk.TalkData;
import openfl.Assets;

class MrunesDefs {
    public var dialogs = new DefNode<Array<DialogDesc>>("dialogs", Assets.getLibrary(""));
    public var battles = new DefNode<BattleDesc>("battles", Assets.getLibrary(""));

    public function new() {}

    public function bind(e:Entity) {
        // e.addComponent(dialogs);
    }
}