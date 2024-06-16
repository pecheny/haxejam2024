package j2024;

import bootstrap.SimpleRunBinder;
import bootstrap.Executor;
import bootstrap.GameRunBase;
import ec.Entity;
import j2024.J24Gui.AntoGui;

class AntoRun extends GameRunBase {
    @:once var model:J24Model;
    @:once var executor:Executor;
    var gui:AntoGui;

    public function new(ctx:Entity, gui:AntoGui) {
        this.gui = gui;
        super(ctx, gui.ph);
        gui.onDone.listen(onGameOver);
    }

    function onGameOver() {
        if (gameOveredFlag) {
            var sr = entity.getComponentUpward(SimpleRunBinder);
            @:privateAccess sr.startGame();
        } else {
            gameOvered.dispatch();
        }
    }

    var gameOveredFlag = false;

    override function startGame() {
        super.startGame();
        gameOveredFlag = false;
        gui.setCaption("...");
        if (model.curBattle.last) {
            if (model.target.hlt <= 0) {
                model.logger.addHint("You killed the witch, now she cant teach your anything. Game Over.");
                gameOveredFlag = true;
            } else {
                if (model.target.hlt < model.lastWitchHealth) {
                    var newSpell = model.getUnlearnedSpell();
                    if (newSpell != null) {
                        model.logger.addHint('Okay, i see your talent, try to figure out how this spell works: <br/> $newSpell');
                    } else {
                        model.logger.addHint('You know all spells i do. I cant help you anymore.');
                        gui.setCaption("Thank  you very much!");
                        gameOveredFlag = true;
                    }
                }
            }
        } else {
            var r = executor.run(model.curBattle.checker);
            if (r) {
                model.battleDoneFlag = true;
                gameOvered.dispatch();
            }
        }
    }
}
