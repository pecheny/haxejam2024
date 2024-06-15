package j2024;

import bootstrap.DefNode;
import ec.Entity;
import loops.talk.TalkData;
import openfl.Assets;

class MrunesDefs {
    public var dialogs = new DefNode<Array<DialogDesc>>("dialogs", Assets.getLibrary(""));

    public function new() {}

    public function bind(e:Entity) {
        // e.addComponent(dialogs);
    }
}